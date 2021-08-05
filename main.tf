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

  infra_env = var.infra_env
  vpc_cidr  = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
  # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.vpc_public_subnets, 0)
  associate_public_ip_address = true
  key_name                    = "web"

  tags = {
    Name = "web-hello-world"
  }
}
