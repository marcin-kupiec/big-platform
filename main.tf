terraform {
  required_version = "= 1.0.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }

  backend "s3" {
    region         = "eu-central-1"
    key            = "terraform.tfstate"
    bucket         = "big-platform-tfm"
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "./modules/vpc"

  infra_env       = var.infra_env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
