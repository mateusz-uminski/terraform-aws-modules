# cloudtrail

Terraform module that configures CloudTrail for an AWS account and optionally creates a shared S3 bucket for storing CloudTrail logs that can be accessed by specified account IDs.

## Example Usage

```terraform
module "cloudtrail" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//cloudtrail?ref=main"

  # Required variables
  org_abbreviated_name = "mcd"
  account_name         = "mcd-shared"

  # Optional variables
  allowed_account_ids = ["111111111111", "222222222222"]
  bucket_name         = ""
}
```
