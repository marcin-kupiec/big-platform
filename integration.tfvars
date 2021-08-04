infra_env = "int"

vpc_cidr = "10.0.128.0/17"

azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
public_subnets  = ["10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24"]
private_subnets = ["10.0.228.0/24", "10.0.229.0/24", "10.0.230.0/24"]
