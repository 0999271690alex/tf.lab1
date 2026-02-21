provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "remote_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  subnet_id = data.terraform_remote_state.base_infra.outputs.public_subnet_id

  vpc_security_group_ids = [
    data.terraform_remote_state.base_infra.outputs.security_group_id
  ]

  tags = {
    Name      = "${var.project_id}-remote-ec2"
    Terraform = "true"
    Project   = var.project_id
  }
}
