locals {
  org = var.org_abbreviated_name

  vpc_endpoint_policy = var.vpc_endpoint_policy != "" ? var.vpc_endpoint_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "AllowAll",

      Effect    = "Allow",
      Principal = "*"
      Action    = "*"
      Resource  = "*"
      }
    ]
  })
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "main" {
  filter {
    name   = "tag:Name"
    values = var.subnets
  }
}

resource "aws_vpc_endpoint" "main" {
  vpc_id            = data.aws_vpc.main.id
  subnet_ids        = data.aws_subnets.main.ids
  service_name      = var.aws_service
  vpc_endpoint_type = "Interface"

  tags = {
    Name = "${local.org}-${var.vpc_endpoint_name}-vpc-endpoint-${var.vpc_endpoint_tier}"
  }
}

resource "aws_vpc_endpoint_policy" "main" {
  vpc_endpoint_id = aws_vpc_endpoint.main.id
  policy          = local.vpc_endpoint_policy
}
