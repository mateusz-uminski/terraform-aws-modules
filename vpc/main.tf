locals {
  org = var.org_abbreviated_name
}

data "aws_availability_zones" "available" {
  state = "available"
}
