resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-igw-${var.env_code}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-public-sn${count.index + 1}-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "public"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-public-rt-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "public"
    },
    var.tags
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.public : s.id]

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-public-nacl-${var.env_code}"

      "${local.tag_names["subnet_tier"]}" = "public"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "public_ingress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  egress         = false
  rule_number    = 1000
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public_egress_allow_all" {
  network_acl_id = aws_network_acl.public.id
  egress         = true
  rule_number    = 1000
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
