# logs-bucket

Terraform module that creates an S3 bucket for storing logs from a specified AWS service.

# Usage
```terraform
module "vpc_flow_logs_bucket" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//logs-bucket?ref=main"

  # required variables
  org_code     = "org"
  service_name = "vpc-flow-logs"
  service_addr = "delivery.logs.amazonaws.com"
  account_id   = "123456789012"

  # optional variables
  allowed_account_ids = [
    "234567890123",
  ]
}
```
