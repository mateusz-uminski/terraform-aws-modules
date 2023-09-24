# efs

Terraform module that creates an elastic file system.

# Example of usage
```terraform
module "efs" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//efs?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  project              = "infra"
  environment          = "dev"

  efs_name     = "asg"
  vpc_name     = "mcd-main-vpc-nonprod"
  subnet_names = ["mcd-main-public-sn1-nonprod"]

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
