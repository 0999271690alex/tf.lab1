resource "aws_launch_template" "this" {
  name          = "cmtr-pf5k68pq-template"
  image_id      = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"

  # ВИДАЛІТЬ ЦЕЙ РЯДОК ЗВІДСИ:
  # vpc_security_group_ids = [var.ssh_sg_id, var.private_http_sg_id] 

  network_interfaces {
    device_index          = 0
    description           = "Primary network interface"
    delete_on_termination = true
    # ПЕРЕНЕСІТЬ СЮДИ:
    security_groups = [var.ssh_sg_id, var.private_http_sg_id]
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
