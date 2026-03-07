variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "ssh_sg" {
  description = "SSH security group"
  type        = string
}

variable "private_http_sg" {
  description = "Private HTTP security group"
  type        = string
}
