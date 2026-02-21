variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets configuration"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}
