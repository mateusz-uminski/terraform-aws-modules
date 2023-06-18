resource "aws_subnet" "storage" {
  count = length(var.storage_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.storage_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${local.org}-${var.vpc_name}-storage-sn${count.index + 1}-${var.vpc_tier}"
  }
}

resource "aws_route_table" "storage" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.org}-${var.vpc_name}-storage-rt-${var.vpc_tier}"
  }
}

resource "aws_route_table_association" "storage" {
  count = length(var.storage_subnets)

  subnet_id      = aws_subnet.storage[count.index].id
  route_table_id = aws_route_table.storage.id
}


locals {
  storage_nacl_rules = {
    for i, v in var.private_subnets : "${1000 + 100 * i}" => v
  }
}

resource "aws_network_acl" "storage" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.storage : s.id]

  dynamic "ingress" {
    for_each = local.storage_nacl_rules

    content {
      protocol   = "all"
      rule_no    = ingress.key
      action     = "allow"
      cidr_block = ingress.value
      from_port  = 0
      to_port    = 0
    }
  }

  egress {
    protocol   = "all"
    rule_no    = 1000
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${local.org}-${var.vpc_name}-storage-nacl-${var.vpc_tier}"
  }
}
