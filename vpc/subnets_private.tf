resource "aws_eip" "natgw" {
  count = var.create_nat_gateway ? length(var.public_subnets) : 0

  domain = "vpc"

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-natgw${count.index + 1}-eip-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "private"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "private" {
  count = var.create_nat_gateway ? length(var.public_subnets) : 0

  allocation_id = aws_eip.natgw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-natgw${count.index + 1}-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "private"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-private-sn${count.index + 1}-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "private"
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-private-rt${count.index + 1}-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "private"
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "natgw" {
  count = var.create_nat_gateway ? length(var.public_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private[count.index].id
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.private : s.id]

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-private-nacl-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "private"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "private_ingress_allow_vpc" {
  network_acl_id = aws_network_acl.private.id
  egress         = false
  rule_number    = 1000
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_egress_allow_all" {
  network_acl_id = aws_network_acl.private.id
  egress         = true
  rule_number    = 1000
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_ingress_custom" {
  for_each = var.private_subnets_ingress_nacl

  network_acl_id = aws_network_acl.private.id
  egress         = false
  rule_number    = each.key
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 0
  to_port        = 0
}
