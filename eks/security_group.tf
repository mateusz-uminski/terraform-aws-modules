data "aws_subnet" "main" {
  count = length(data.aws_subnets.eks.ids)

  id = data.aws_subnets.eks.ids[count.index]
}

data "aws_security_groups" "allowed_ingress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "group-name"
    values = var.allowed_ingress_sgs
  }
}

resource "aws_security_group" "eks" {
  name        = "${var.org_code}-${var.project_code}-${var.cluster_name}-eks-sg-${var.env_code}"
  vpc_id      = data.aws_vpc.main.id
  description = "Additional security group for the ${local.cluster_name} eks cluster."

  tags = {
    Name = "${var.org_code}-${var.project_code}-${var.cluster_name}-eks-sg-${var.env_code}"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_self" {
  description       = "allow traffic from itself"
  security_group_id = aws_security_group.eks.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0

  referenced_security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_subnets" {
  for_each          = toset(data.aws_subnet.main[*].cidr_block)
  description       = "allow traffic from the subnet ${each.key}"
  security_group_id = aws_security_group.eks.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = each.key
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_specified_cidrs" {
  for_each = toset(var.allowed_ingress_cidrs)

  description       = "allow traffic from ${each.key}"
  security_group_id = aws_security_group.eks.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = each.key
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_specified_sgs" {
  for_each = toset(data.aws_security_groups.allowed_ingress.ids)

  description       = "allow traffic from ${each.key}"
  security_group_id = aws_security_group.eks.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0

  referenced_security_group_id = each.key
}

resource "aws_vpc_security_group_egress_rule" "allow_to_world" {
  description       = "allow all traffic to the world"
  security_group_id = aws_security_group.eks.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = "0.0.0.0/0"
}
