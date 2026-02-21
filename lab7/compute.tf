resource "aws_instance" "public_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  # Використання даних з remote state
  subnet_id              = data.terraform_remote_state.base_infra.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.base_infra.outputs.security_group_id]

  tags = {
    Name      = "${var.project_id}-instance"
    Terraform = "true"
    Project   = var.project_id
  }
}
