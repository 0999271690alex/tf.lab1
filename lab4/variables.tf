variable "bucket_name" {
  description = "Name of the S3 bucket to which write access will be granted."
  type        = string
  default     = "cmtr-pf5k68pq-bucket-1771684355"
}

variable "project_tag" {
  description = "Project name for tagging resources"
  type        = string
  default     = "cmtr-pf5k68pq"
}
