# r53-private-zone

Terraform module that creates a Route53 Private Hosted Zone. This module allows associating VPCs,
including those from other AWS accounts, with the Private Hosted Zone.

# Usage
```terraform
module "dev_use1_example_internal" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//r53-private-zone?ref=main"

  # required variables
  zone_name = "dev.use1.example.internal"
  vpcs      = {
    "main_vpc_use1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "us-east-1"
    },
    "main_vpc_euw1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "eu-west-1"
    },
  }

  # optional variables
  external_vpcs = {
    "external_vpc_use1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "us-east-1"
    },
    "external_vpc_euw1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "eu-west-1"
    },
  }
}
```
