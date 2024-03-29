# vpc-endpoint

Terraform module that creates interface type vpc endpoint in given subnets.

# Example of usage
```terraform
module "s3_main_vpc_endpoint" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//vpc-endpoint?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  vpc_name             = "mcd-main-vpc-shared"
  vpc_endpoint_name    = "s3-main"
  vpc_endpoint_tier    = "shared"
  aws_service          = "com.amazonaws.us-east-1.s3"

  subnets = [
    "mcd-main-private-sn1-shared",
    "mcd-main-private-sn2-shared",
    "mcd-main-private-sn3-shared",
  ]

  # optional variables
  allowed_ingress_cidrs = ["10.0.0.0/8"]
  allowed_ingress_sgs   = [""]
  vpc_endpoint_policy   = ""
}
```
