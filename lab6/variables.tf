variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "cmtr-pf5k68pq-01-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets configuration"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))

  default = [
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
}
