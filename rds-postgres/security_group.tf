data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "main" {
  count = length(data.aws_subnets.main.ids)

  id = data.aws_subnets.main.ids[count.index]
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

resource "aws_security_group" "main" {
  name        = "${local.org}-${var.project}-${var.db_name}-sg-${var.environment}"
  vpc_id      = data.aws_vpc.main.id
  description = "Default security group for the${local.db_name}."

  ingress {
    description = "allow traffic from itself"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    self        = true
  }

  ingress {
    description = "allow traffic from the subnet"
    cidr_blocks = data.aws_subnet.main[*].cidr_block
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
    Name = "${local.org}-${var.project}-${var.db_name}-sg-${var.environment}"
  }
}
