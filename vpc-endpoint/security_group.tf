data "aws_security_groups" "allowed_ingress" {
  filter {
    name   = "group-name"
    values = var.allowed_ingress_sgs
  }
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id      = data.aws_vpc.main.id
  name        = "${local.org}-${var.vpc_endpoint_name}-vpc-endpoint-sg-${var.vpc_endpoint_tier}"
  description = "Default security group for the ${local.org}-${var.vpc_endpoint_name}-vpc-endpoint-${var.vpc_endpoint_tier}."

  ingress {
    description = "allow traffic from itself"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    self        = true
  }

  ingress {
    description = "allow traffic from the vpc"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    description = "allow traffic from specified cidr blocks"
    cidr_blocks = var.allowed_ingress_cidrs
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  ingress {
    description     = "allow traffic from specified security groups"
    security_groups = data.aws_security_groups.allowed_ingress.ids
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
  }

  egress {
    description = "allow all traffic to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.org}-${var.vpc_endpoint_name}-sg-${var.vpc_endpoint_tier}"
  }
}

resource "aws_vpc_endpoint_security_group_association" "main" {
  vpc_endpoint_id   = aws_vpc_endpoint.main.id
  security_group_id = aws_security_group.vpc_endpoint.id
}
