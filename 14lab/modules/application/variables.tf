variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ssh_sg_id" {
  description = "Security Group ID for SSH"
  type        = string
}

variable "public_http_sg" {
  description = "Security Group ID for Public HTTP"
  type        = string
}

variable "private_http_sg_id" {
  description = "Security Group ID for Private HTTP"
  type        = string
}
