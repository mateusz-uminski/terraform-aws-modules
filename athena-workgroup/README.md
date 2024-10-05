# athena-workgroup

Terraform module for creating Athena workgroups and configuring associated settings.

# Usage
```terraform
module "athena_workgroup" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//athena-workgroup?ref=main"

  # Required variables
  org_code       = "org"
  workgroup_name = "main"
  bucket_owner   = "123456789012"
}
```
