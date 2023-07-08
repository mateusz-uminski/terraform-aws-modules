# athena-workgroup

Terraform module for creating Athena workgroups and configuring associated settings.

# Example of usage
```terraform
module "athena_workgroup" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//athena-workgroup?ref=main"

  # Required variables
  org_abbreviated_name = "mcd"
  workgroup_name       = "main"
  bucket_owner         = "111111111111"
}
```
