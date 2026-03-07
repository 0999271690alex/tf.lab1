variable "vpc_id" {
  description = "VPC ID for the application resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the autoscaling group"
  type        = list(string)
}

variable "ssh_sg" {
  description = "SSH security group ID"
  type        = string
}

variable "public_http_sg" {
  description = "Public HTTP security group ID"
  type        = string
}

variable "private_http_sg" {
  description = "Private HTTP security group ID"
  type        = string
}
