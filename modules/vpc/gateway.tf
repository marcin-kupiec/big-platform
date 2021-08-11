// public ips

resource "aws_eip" "nat" {
  count = length(var.azs)

  tags = {
    Name        = "nat-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
  }

  depends_on = [aws_internet_gateway.main]
}

// gateways

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "main-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
  }
}

locals {
  eip_ids = aws_eip.nat.*.id
}

resource "aws_nat_gateway" "main" {
  count = length(var.azs)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "main-${var.infra_env}-${count.index}"
    Environment = var.infra_env
    Terraform   = true
  }

  depends_on = [aws_internet_gateway.main]
}
