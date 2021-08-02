terraform {
  required_version = "= 1.0.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc-main-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  for_each          = var.public_subnets
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name        = "subnet-public-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
    Subnet      = "public-${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  for_each          = var.private_subnets
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name        = "subnet-private-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
    Subnet      = "private-${each.key}-${each.value}"
  }
}