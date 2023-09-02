# route53-private-zone

Terraform module that creates a Route53 Private Hosted Zone. This module allows associating VPCs,
including those from other AWS accounts, with the Private Hosted Zone.

# Example of usage
```terraform
module "ue1_dev_corp_example_com" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//route53-private-zone?ref=main"

  # required variables
  zone_name = "ue1.dev.corp.example.com"
  vpcs      = {
    "main_vpc_ue1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "us-east-1"
    },
    "main_vpc_ew1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "eu-west-1"
    },
  }

  # optional variables
  external_vpcs = {
    "external_vpc_ue1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "us-east-1"
    },
    "external_vpc_ew1_dev" = {
      "vpc_id" = "vpc-12345678901234567"
      "region" = "eu-west-1"
    },
  }
}
```
