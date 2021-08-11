resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "main-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
  }
}
