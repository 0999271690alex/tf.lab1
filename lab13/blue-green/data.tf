data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-pf5k68pq-vpc"]
  }
}

data "aws_subnet" "public1" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-pf5k68pq-public-subnet1"]
  }
}

data "aws_subnet" "public2" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-pf5k68pq-public-subnet2"]
  }
}

data "aws_security_group" "lb" {
  filter {
    name   = "group-name"
    values = ["cmtr-pf5k68pq-sg-lb"]
  }
}

data "aws_security_group" "http" {
  filter {
    name   = "group-name"
    values = ["cmtr-pf5k68pq-sg-http"]
  }
}
