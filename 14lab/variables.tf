variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "allowed_ip_range" {
  description = "List of IP address ranges for secure access to SSH and HTTP"
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "cmtr-pf5k68pq-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}
