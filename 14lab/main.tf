module "network" {
  source   = "./modules/network"
  vpc_name = "cmtr-pf5k68pq-vpc"
  vpc_cidr = "10.10.0.0/16"
}

# Назва має бути САМЕ network_security для тестів
module "network_security" { 
  source           = "./modules/network_security"
  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
}

module "application" {
  source             = "./modules/application"
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  
  # Змінюємо module.security на module.network_security
  ssh_sg_id          = module.network_security.ssh_sg_id
  public_http_sg     = module.network_security.public_http_sg_id
  private_http_sg_id = module.network_security.private_http_sg_id
}
