# iam identity center users

Terraform module that creates users in IAM Identity Center. Currently, it is not possible to fill in the `Job-related information` section using
the `aws_identitystore_user` resource, so it has to be filled in manually.

Note: remember that the `divison` field is mapped to the `ac:project` tag.

Important: This module depends on the following modules:
- [iam-identity-center](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center)
- [iam-identity-center-project](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-project)
- [iam-permissions-boundary-policies](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-permissions-boundary-policies)

This module requires the IAM Identity Center to be enabled. You can accomplish this by following the steps outlined below:
1. Enable IAM Identity Center
2. Change MFA settings to:
- `Every time they sign in (always-on)`
- `Require them to register an MFA device at sign in`
3. Enable `Attributes for access control`
4. Add the following attribute: `ac:project = ${path:enterprise.division}`

List of modules used for sso configuration:
- [iam-identity-center](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center)
- [iam-identity-center-project](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-project)
- [iam-permissions-boundary-policies](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-permissions-boundary-policies)
- [iam-identity-center-users](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-users)

# Example of usage
```terraform
module "iam_identity_center_users" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//iam-identity-center-users?ref=main"

  # required variables
  users = {
    "superuser" = {
      display_name = "superuser"
      given_name   = "superuser"
      family_name  = "superuser"
      project      = "architecture"
      email        = "superuser@domain.com"
      groups = [
        "cloudadmins", "cloudviewers", "guests",
        "microdata-admins", "microdata-developers",
        "micropost-admins", "micropost-developers"
      ]
    },
    "guestuser" = {
      display_name = "guestuser"
      given_name   = "guestuser"
      family_name  = "guestuser"
      project      = ""
      email        = "guestuser@domain.com"
      groups = [
        "guests",
      ]
    }
  }
}
```
