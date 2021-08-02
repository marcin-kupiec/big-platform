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

// public ips

resource "aws_eip" "nat" {
  tags = {
    Name = "eip-nat"
  }

  depends_on = [aws_internet_gateway.main]
}

// subnets

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  count             = length(var.public_subnets)
  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnets[count.index]

  tags = {
    Name        = "subnet-public"
    Environment = var.infra_env
    Terraform   = true
    Tier        = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  count             = length(var.private_subnets)
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = {
    Name        = "subnet-private"
    Environment = var.infra_env
    Terraform   = true
    Tier        = "Private"
  }
}

// gateways

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-main"
    Environment = var.infra_env
    Terraform   = true
  }
}

locals {
  eip_ids = aws_eip.nat.*.id
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = {
    Name        = "nat-gw"
    Environment = var.infra_env
    Terraform   = true
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_vpn_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "vgw-main"
    Environment = var.infra_env
    Terraform   = true
  }
}

// route tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
