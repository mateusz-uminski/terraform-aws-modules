# cloudtrail

Terraform module that configures CloudTrail for an AWS account and optionally creates a shared S3 bucket for storing CloudTrail logs that can be accessed by specified account IDs.

## Usage
```terraform
module "cloudtrail" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//cloudtrail?ref=main"

  # Required variables
  org_code     = "org"
  account_name = "org-dev"

  # Optional variables
  allowed_account_ids = ["123456789012", "234567890123"]
  bucket_name         = ""
}
```
