variable "vpc_id" {
  description = "VPC ID for target group and load balancer"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG and ALB"
  type        = list(string)
}

variable "ssh_sg_id" {
  description = "Security Group ID for SSH access"
  type        = string
}

variable "public_http_sg" {
  description = "Security Group ID for the public Load Balancer"
  type        = string
}

variable "private_http_sg" {
  description = "Security Group ID for the private application instances"
  type        = string
}

variable "private_http_sg_id" {
  description = "The ID of the Private HTTP Security Group"
  type        = string
}

variable "ssh_sg_id" {
  description = "The ID of the SSH Security Group"
  type        = string
}
