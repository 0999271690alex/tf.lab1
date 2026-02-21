############################################
# Get existing VPC
############################################

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-pf5k68pq-vpc"]
  }
}

############################################
# Get subnets from this VPC
############################################

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

############################################
# Get existing Security Group
############################################

data "aws_security_group" "sg" {
  name = "cmtr-pf5k68pq-sg"
}

############################################
# Get latest Amazon Linux 2 AMI
############################################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

############################################
# Create EC2 Instance
############################################

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  subnet_id              = data.aws_subnets.subnets.ids[0]
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name    = "cmtr-pf5k68pq-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-pf5k68pq"
  }
}
