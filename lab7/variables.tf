variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_id" {
  description = "Project identifier for tagging"
  type        = string
  default     = "cmtr-pf5k68pq"
}

variable "state_bucket" {
  description = "S3 bucket name for remote state"
  type        = string
}

variable "state_key" {
  description = "S3 key path for remote state file"
  type        = string
}
