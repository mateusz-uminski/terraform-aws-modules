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
  name        = "${local.org}-${var.project}-${var.cluster_name}-eks-sg-${var.cluster_tier}"
  vpc_id      = data.aws_vpc.main.id
  description = "Additional security group for the ${local.cluster_name} eks cluster."

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
    Name = "${local.org}-${var.project}-${var.cluster_name}-eks-sg-${var.cluster_tier}"
  }
}
