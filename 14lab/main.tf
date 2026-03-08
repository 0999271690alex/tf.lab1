module "network" {
  source = "./modules/network"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  # ... передаємо всі назви сабнетів та AZ ...
}

module "security" {
  source = "./modules/network_security"
  vpc_id = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
  # ... назви SG ...
}

module "app" {
  source = "./modules/application"
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnet_ids
  ssh_sg_id       = module.security.ssh_sg_id
  public_http_sg  = module.security.public_http_sg_id
  private_http_sg = module.security.private_http_sg_id
  # ... назви ASG, ALB ...
}
