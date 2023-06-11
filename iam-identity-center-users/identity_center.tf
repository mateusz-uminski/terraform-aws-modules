data "aws_ssoadmin_instances" "organization" {}

locals {
  identity_center_id  = data.aws_ssoadmin_instances.organization.identity_store_ids[0]
  identity_center_arn = data.aws_ssoadmin_instances.organization.arns[0]
}
