resource "aws_subnet" "storage" {
  count = length(var.storage_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.storage_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-storage-sn${count.index + 1}-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "storage"
    },
    var.tags
  )
}

resource "aws_route_table" "storage" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-storage-rt-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "storage"
    },
    var.tags
  )
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

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-storage-nacl-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "storage"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "storage_ingress_allow_private_subnets" {
  for_each = local.storage_nacl_rules

  network_acl_id = aws_network_acl.storage.id
  egress         = false
  rule_number    = each.key
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = each.value
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "storage_egress_allow_vpc" {
  network_acl_id = aws_network_acl.storage.id
  egress         = true
  rule_number    = 1000
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 0
}
