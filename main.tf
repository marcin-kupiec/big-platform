module "vpc" {
  source = "./modules/vpc"

  infra_env = var.infra_env
  vpc_cidr  = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
