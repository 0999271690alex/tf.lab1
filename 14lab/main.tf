# 1. Модуль мережі: створює VPC, сабнети та маршрутизацію
module "network" {
  source   = "./modules/network"
  vpc_name = "cmtr-pf5k68pq-vpc"
  vpc_cidr = "10.10.0.0/16"
}

# 2. Модуль безпеки: створює Security Groups
module "security" {
  source           = "./modules/network_security"
  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
}

# 3. Модуль додатка: створює ALB, ASG та Launch Template
module "application" {
  source             = "./modules/application"
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  ssh_sg_id          = module.security.ssh_sg_id
  public_http_sg     = module.security.public_http_sg_id
  private_http_sg_id = module.security.private_http_sg_id # Виправлено назву аргументу
}
