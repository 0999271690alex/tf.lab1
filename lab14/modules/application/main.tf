resource "aws_launch_template" "main" {
  name_prefix   = "cmtr-pf5k68pq-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    var.ssh_sg,
    var.private_http_sg
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd

UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid)
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

echo "This message was generated on instance $INSTANCE_ID with the following UUID $UUID" > /var/www/html/index.html
EOF
  )
}
