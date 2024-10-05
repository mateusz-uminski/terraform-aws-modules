data "aws_security_groups" "allowed_ingress" {
  filter {
    name   = "group-name"
    values = var.allowed_ingress_sgs
  }
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id      = data.aws_vpc.main.id
  name        = "${var.org_code}-${var.vpc_endpoint_name}-vpc-endpoint-sg-${var.env_code}"
  description = "Default security group for the ${var.org_code}-${var.vpc_endpoint_name}-vpc-endpoint-${var.env_code}."

  tags = {
    Name = "${var.org_code}-${var.vpc_endpoint_name}-sg-${var.env_code}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_self" {
  description       = "allow traffic from itself"
  security_group_id = aws_security_group.vpc_endpoint.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0

  referenced_security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc" {
  description       = "allow traffic from the vpc"
  security_group_id = aws_security_group.vpc_endpoint.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = [data.aws_vpc.main.cidr_block]
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_specified_cidrs" {
  for_each = toset(var.allowed_ingress_cidrs)

  description       = "allow traffic from ${each.key}"
  security_group_id = aws_security_group.vpc_endpoint.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = each.key
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_specified_sgs" {
  for_each = toset(data.aws_security_groups.allowed_ingress.ids)

  description       = "allow traffic from ${each.key}"
  security_group_id = aws_security_group.vpc_endpoint.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0

  referenced_security_group_id = each.key
}

resource "aws_vpc_security_group_egress_rule" "allow_to_world" {
  description       = "allow all traffic to the world"
  security_group_id = aws_security_group.vpc_endpoint.id

  ip_protocol = "-1"
  from_port   = 0
  to_port     = 0
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_endpoint_security_group_association" "main" {
  vpc_endpoint_id   = aws_vpc_endpoint.main.id
  security_group_id = aws_security_group.vpc_endpoint.id
}
