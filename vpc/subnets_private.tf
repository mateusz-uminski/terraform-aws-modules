resource "aws_eip" "natgw" {
  count = length(var.public_subnets)

  domain = "vpc"

  tags = {
    Name = "${local.org}-${var.vpc_name}-natgw${count.index + 1}-eip-${var.vpc_tier}"
  }
}

resource "aws_nat_gateway" "private" {
  count = length(var.public_subnets)

  allocation_id = aws_eip.natgw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${local.org}-${var.vpc_name}-natgw${count.index + 1}-${var.vpc_tier}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${local.org}-${var.vpc_name}-private-sn${count.index + 1}-${var.vpc_tier}"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.org}-${var.vpc_name}-private-rt${count.index + 1}-${var.vpc_tier}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "natgw" {
  count = length(var.private_subnets)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private[count.index].id
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.public : s.id]

  ingress {
    protocol   = "all"
    rule_no    = 1000
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "all"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  dynamic "ingress" {
    for_each = var.private_subnets_ingress_nacl

    content {
      protocol   = "all"
      rule_no    = ingress.key
      action     = "allow"
      cidr_block = ingress.value
      from_port  = 0
      to_port    = 0
    }
  }

  tags = {
    Name = "${local.org}-${var.vpc_name}-private-nacl-${var.vpc_tier}"
  }
}
