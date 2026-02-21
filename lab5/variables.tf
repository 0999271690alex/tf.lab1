variable "allowed_ip_range" {
  description = "List of allowed IP ranges for secure access."
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the existing VPC."
  type        = string
}

variable "public_instance_id" {
  description = "ID of the public EC2 instance."
  type        = string
}

variable "private_instance_id" {
  description = "ID of the private EC2 instance."
  type        = string
}
