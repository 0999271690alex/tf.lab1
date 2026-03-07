resource "aws_launch_template" "blue" {

  name_prefix   = "cmtr-pf5k68pq-blue-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.http.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
echo "<h1>Blue Environment</h1>" > /var/www/html/index.html
EOF
  )
}

resource "aws_launch_template" "green" {

  name_prefix   = "cmtr-pf5k68pq-green-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    data.aws_security_group.http.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
echo "<h1>Green Environment</h1>" > /var/www/html/index.html
EOF
  )
}
