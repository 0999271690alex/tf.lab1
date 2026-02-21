# --- SSH Security Group ---
resource "aws_security_group" "ssh_sg" {
  name        = "cmtr-pf5k68pq-ssh-sg"
  description = "Allow SSH and ICMP from allowed IPs"
  vpc_id      = var.vpc_id

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

# --- Public HTTP Security Group ---
resource "aws_security_group" "public_http_sg" {
  name        = "cmtr-pf5k68pq-public-http-sg"
  description = "Allow HTTP and ICMP from allowed IPs"
  vpc_id      = var.vpc_id

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

# --- Private HTTP Security Group ---
resource "aws_security_group" "private_http_sg" {
  name        = "cmtr-pf5k68pq-private-http-sg"
  description = "Allow HTTP 8080 and ICMP from Public HTTP SG"
  vpc_id      = var.vpc_id

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

# --- Data sources to get Network Interface IDs ---
data "aws_instance" "public" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private" {
  instance_id = var.private_instance_id
}

# --- Attachments ---
resource "aws_network_interface_sg_attachment" "public_ssh_attach" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

resource "aws_network_interface_sg_attachment" "public_http_attach" {
  security_group_id    = aws_security_group.public_http_sg.id
  network_interface_id = data.aws_instance.public.network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_ssh_attach" {
  security_group_id    = aws_security_group.ssh_sg.id
  network_interface_id = data.aws_instance.private.network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_http_attach" {
  security_group_id    = aws_security_group.private_http_sg.id
  network_interface_id = data.aws_instance.private.network_interface_id
}
