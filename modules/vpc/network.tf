// subnets

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  count             = length(var.public_subnets)
  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnets[count.index]

  tags = {
    Name        = "public-${var.infra_env}"
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
    Name        = "private-${var.infra_env}"
    Environment = var.infra_env
    Terraform   = true
    Tier        = "Private"
  }
}

// routing tables

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
  count  = length(aws_nat_gateway.main.*.id)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.main.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
