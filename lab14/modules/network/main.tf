resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "cmtr-pf5k68pq-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.10.1.0/24"

  tags = {
    Name = "cmtr-pf5k68pq-subnet-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.10.3.0/24"

  tags = {
    Name = "cmtr-pf5k68pq-subnet-public-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1c"
  cidr_block        = "10.10.5.0/24"

  tags = {
    Name = "cmtr-pf5k68pq-subnet-public-c"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "cmtr-pf5k68pq-igw"
  }
}
