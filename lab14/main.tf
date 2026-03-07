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

module "network" {
  source = "./modules/network"
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
}

module "application" {
  source = "./modules/application"

  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.subnet_ids
  ssh_sg          = module.network_security.ssh_sg
  public_http_sg  = module.network_security.public_http_sg
  private_http_sg = module.network_security.private_http_sg
}
