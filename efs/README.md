# efs

Terraform module that creates an elastic file system.

# Usage
```terraform
module "efs" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//efs?ref=main"

  # required variables
  org_code     = "org"
  project_code = "infra"
  env_code     = "dev"

  efs_name     = "asg"
  vpc_name     = "org-main-vpc-dev"
  subnet_names = ["org-main-public-sn1-dev"]

  # optional variables
  access_point_dir = {
    path        = ""
    owner       = 1000
    group       = 1000
    permissions = "444"
  }

  access_point_user = {
    uid      = 1000
    group_id = 1000
  }

  additional_security_groups = []
  allowed_ingress_cidrs      = []
  allowed_ingress_sgs        = []
}
```
