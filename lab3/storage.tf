terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "cmtr-pf5k68pq-bucket-1771681345"

  tags = {
    Project = "cmtr-pf5k68pq"
  }
}
