provider "aws" {
  region = "us-east-1"
}

############################
# Data sources (existing infra)
############################

data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-pf5k68pq-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }

  filter {
    name   = "cidr-block"
    values = ["10.0.1.0/24", "10.0.3.0/24"]
  }
}

data "aws_security_group" "ec2_sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-pf5k68pq-ec2_sg"]
  }
}

data "aws_security_group" "http_sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-pf5k68pq-http_sg"]
  }
}

data "aws_security_group" "lb_sg" {
  filter {
    name   = "group-name"
    values = ["cmtr-pf5k68pq-sglb"]
  }
}

############################
# Launch Template
############################

resource "aws_launch_template" "template" {
  name = "cmtr-pf5k68pq-template"

  image_id      = "ami-09e6f87a47903347c"
  instance_type = "t3.micro"
  key_name      = "cmtr-pf5k68pq-keypair"

  iam_instance_profile {
    name = "cmtr-pf5k68pq-instance_profile"
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups = [
      data.aws_security_group.ec2_sg.id,
      data.aws_security_group.http_sg.id
    ]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd aws-cli jq

systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/local-ipv4)

echo "This message was generated on instance $INSTANCE_ID with the following IP: $PRIVATE_IP" \
> /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Terraform = "true"
      Project   = "cmtr-pf5k68pq"
    }
  }

  tags = {
    Terraform = "true"
    Project   = "cmtr-pf5k68pq"
  }
}

############################
# Target Group
############################

resource "aws_lb_target_group" "tg" {
  name     = "cmtr-pf5k68pq-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.existing.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Terraform = "true"
    Project   = "cmtr-pf5k68pq"
  }
}

############################
# Application Load Balancer
############################

resource "aws_lb" "alb" {
  name               = "cmtr-pf5k68pq-loadbalancer"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids
  security_groups    = [data.aws_security_group.lb_sg.id]

  tags = {
    Terraform = "true"
    Project   = "cmtr-pf5k68pq"
  }
}

############################
# Listener
############################

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

############################
# Auto Scaling Group
############################

resource "aws_autoscaling_group" "asg" {
  name                = "cmtr-pf5k68pq-asg"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = data.aws_subnets.public.ids

  target_group_arns = [
    aws_lb_target_group.tg.arn
  ]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      load_balancers
    ]
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "cmtr-pf5k68pq"
    propagate_at_launch = true
  }
}

############################
# Attachment (required by test)
############################

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}
