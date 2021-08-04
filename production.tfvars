infra_env = "prod"

vpc_cidr = "10.0.0.0/17"

azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
