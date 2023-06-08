# iam permissions boundary policies

Terraform module that creates a set of permissions boundary policies. The set contains:
- `permissions-boundary-application`: should be assigned to every application role (service account) created in an AWS account. It currently denies access to IAM service.
- `permissions-boundary-provisioner`: should be assigned to every resource that can provision resources in an AWS account (e.g., an EC2 instance with Atlantis).
- `permissions-boundary-admin`: should be assigned to every individual who can manage the project's infrastructure. Currently, this policy has the same permissions as `permissions-boundary-provisioner`. However, it would be better to differentiate them in case there is a need to limit actions for provisioners while allowing project-specific admins unrestricted access.

Both `permissions-boundary-provisioner` and `permissions-boundary-admin` deny IAM actions that could escalate privileges when IAM management is delegated.

These permissions boundary policies are required by the following module:
- [iam-identity-center-project](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-project)

List of modules used for sso configuration:
- [iam-identity-center](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center)
- [iam-identity-center-project](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-project)
- [iam-permissions-boundary-policies](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-permissions-boundary-policies)
- [iam-identity-center-users](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/iam-identity-center-users)

# Example of usage
```terraform
module "iam_permissions_boundary_policies" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//iam-permissions-boundary-policies?ref=main"

  # required variables
  org_abbreviated_name = var.org_abbreviated_name
}
```
