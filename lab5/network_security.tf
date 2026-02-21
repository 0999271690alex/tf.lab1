# Отримуємо дані про інтерфейси існуючих машин
data "aws_instance" "public" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private" {
  instance_id = var.private_instance_id
}

# 1. SSH Security Group
resource "aws_security_group" "ssh_sg" {
  name   = "cmtr-pf5k68pq-ssh-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Project = var.project_tag }
}

# 2. Public HTTP Security Group
resource "aws_security_group" "public_http_sg" {
  name   = "cmtr-pf5k68pq-public-http-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ip_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Project = var.project_tag }
}

# 3. Private HTTP Security Group (з використанням source_security_group_id)
resource "aws_security_group" "private_http_sg" {
  name   = "cmtr-pf5k68pq-private-http-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http_sg.id]
  }
  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.public_http_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Project = var.project_tag }
}

# ПРИКРІПЛЕННЯ (те, що шукає помилка №9)
resource "aws_network_interface_sg_attachment" "pub_ssh" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

resource "aws_network_interface_sg_attachment" "pub_http" {
  security_group_id    = aws_security_group.public_http_sg.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

resource "aws_network_interface_sg_attachment" "priv_ssh" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.private.network_interface_id
}

resource "aws_network_interface_sg_attachment" "priv_http" {
  security_group_id    = aws_security_group.private_http_sg.id
  network_interface_id = data.aws_instance.private.network_interface_id
}
