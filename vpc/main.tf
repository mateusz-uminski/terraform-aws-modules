locals {
  tag_names = {
    subnet_tier = "${var.org_code}:subnet-tier"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
