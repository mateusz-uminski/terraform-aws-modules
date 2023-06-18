# vpc flow logs bucket

Terraform module that creates an S3 bucket for vpc flow logs.

# Example of usage
```terraform
module "vpc_flow_logs_bucket" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//vpc-flow-logs-bucket?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  account_id           = "111111111111"

  # optional variables
  allowed_account_ids = [
    "222222222222",
  ]
}
```
