############################
# SSH Security Group
############################

resource "aws_security_group" "ssh_sg" {
  name   = "cmtr-pf5k68pq-ssh-sg"
  vpc_id = var.vpc_id

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh_sg.id
}

resource "aws_security_group_rule" "ssh_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh_sg.id
}

############################
# Public HTTP Security Group
############################

resource "aws_security_group" "public_http_sg" {
  name   = "cmtr-pf5k68pq-public-http-sg"
  vpc_id = var.vpc_id

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

resource "aws_security_group_rule" "public_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http_sg.id
}

resource "aws_security_group_rule" "public_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http_sg.id
}

############################
# Private HTTP Security Group
############################

resource "aws_security_group" "private_http_sg" {
  name   = "cmtr-pf5k68pq-private-http-sg"
  vpc_id = var.vpc_id

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}

resource "aws_security_group_rule" "private_http_ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_http_sg.id
  security_group_id        = aws_security_group.private_http_sg.id
}

resource "aws_security_group_rule" "private_icmp" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.public_http_sg.id
  security_group_id        = aws_security_group.private_http_sg.id
}

############################
# Attach SG to Public Instance
############################

resource "aws_network_interface_sg_attachment" "public_ssh_attach" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.public_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "public_http_attach" {
  security_group_id    = aws_security_group.public_http_sg.id
  network_interface_id = data.aws_instance.public_instance.primary_network_interface_id
}

############################
# Attach SG to Private Instance
############################

resource "aws_network_interface_sg_attachment" "private_ssh_attach" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.private_instance.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_http_attach" {
  security_group_id    = aws_security_group.private_http_sg.id
  network_interface_id = data.aws_instance.private_instance.primary_network_interface_id
}

############################
# Data sources for instances
############################

data "aws_instance" "public_instance" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private_instance" {
  instance_id = var.private_instance_id
}
