# vpc-endpoint

Terraform module that creates interface type vpc endpoint in given subnets.

# Usage
```terraform
module "s3_main_vpc_endpoint" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//vpc-endpoint?ref=main"

  # required variables
  org_code          = "org"
  env_code          = "dev"
  vpc_name          = "org-main-vpc-dev"
  vpc_endpoint_name = "s3-main"
  aws_service       = "com.amazonaws.us-east-1.s3"

  subnets = [
    "org-main-private-sn1-dev",
    "org-main-private-sn2-dev",
    "org-main-private-sn3-dev",
  ]

  # optional variables
  allowed_ingress_cidrs = ["10.0.0.0/8"]
  allowed_ingress_sgs   = [""]
  vpc_endpoint_policy   = ""
}
```
