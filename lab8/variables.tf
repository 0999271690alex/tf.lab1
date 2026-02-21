variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "Project identifier used for tagging resources"
  type        = string
  default     = "cmtr-pf5k68pq"
}

variable "ssh_key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
  default     = "cmtr-pf5k68pq-keypair"
}
