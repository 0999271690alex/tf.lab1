resource "aws_launch_template" "this" {
  name          = "cmtr-pf5k68pq-template"
  image_id      = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"

  network_interfaces {
    device_index          = 0
    delete_on_termination = true
    security_groups       = [var.ssh_sg_id, var.private_http_sg_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    COMPUTE_INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
    echo "This message was generated on instance $COMPUTE_INSTANCE_ID with the following UUID $COMPUTE_MACHINE_UUID" > /var/www/html/index.html
  EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name                = "cmtr-pf5k68pq-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_lb" "this" {
  name               = "cmtr-pf5k68pq-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_http_sg]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "this" {
  name     = "cmtr-pf5k68pq-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = aws_lb_target_group.this.arn
}
