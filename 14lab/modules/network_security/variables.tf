variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "allowed_ip_range" {
  description = "Allowed IP addresses for ingress rules"
  type        = list(string)
}
