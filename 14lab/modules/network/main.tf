resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = var.vpc_name }
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.this.id
  cidr_block              = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"][count.index]
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]
  map_public_ip_on_launch = true
  tags = { Name = ["cmtr-pf5k68pq-subnet-public-a", "cmtr-pf5k68pq-subnet-public-b", "cmtr-pf5k68pq-subnet-public-c"][count.index] }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "cmtr-pf5k68pq-igw" }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "cmtr-pf5k68pq-rt" }
}

resource "aws_route_table_association" "this" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.this.id
}
