variable "vpc_id" {
  description = "The ID of the pre-created VPC"
  type        = string
  default     = "vpc-0b2ca3d55bdc7321a"
}

variable "public_instance_id" {
  description = "The ID of the public EC2 instance"
  type        = string
  default     = "i-078881213cbe0482b"
}

variable "private_instance_id" {
  description = "The ID of the private EC2 instance"
  type        = string
  default     = "i-0da348aef33c16e89"
}

variable "allowed_ip_range" {
  description = "List of IP ranges allowed to access public resources"
  type        = list(string)
}

variable "project_tag" {
  description = "Project identifier for tagging"
  type        = string
  default     = "cmtr-pf5k68pq"
}
