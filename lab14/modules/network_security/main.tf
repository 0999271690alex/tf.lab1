resource "aws_security_group" "ssh" {
  name   = "cmtr-pf5k68pq-ssh-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group" "public_http" {
  name   = "cmtr-pf5k68pq-public-http-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "public_http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_range
  security_group_id = aws_security_group.public_http.id
}
