aws_region = "us-east-1"

vpc_name = "cmtr-pf5k68pq-01-vpc"
vpc_cidr = "10.10.0.0/16"

igw_name         = "cmtr-pf5k68pq-01-igw"
route_table_name = "cmtr-pf5k68pq-01-rt"

public_subnets = [
  {
    name              = "cmtr-pf5k68pq-01-subnet-public-a"
    cidr_block        = "10.10.1.0/24"
    availability_zone = "us-east-1a"
  },
  {
    name              = "cmtr-pf5k68pq-01-subnet-public-b"
    cidr_block        = "10.10.3.0/24"
    availability_zone = "us-east-1b"
  },
  {
    name              = "cmtr-pf5k68pq-01-subnet-public-c"
    cidr_block        = "10.10.5.0/24"
    availability_zone = "us-east-1c"
  }
]
