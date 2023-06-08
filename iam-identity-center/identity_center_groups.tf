resource "aws_identitystore_group" "cloudadmins" {
  display_name = "cloudadmins"
  description  = "Members of this group manage all cloud resources in the organization."

  identity_store_id = local.identity_center_id
}

resource "aws_identitystore_group" "cloudviewers" {
  display_name = "cloudviewers"
  description  = "Members of this group have read only access to all cloud resources in the organization."

  identity_store_id = local.identity_center_id
}

resource "aws_identitystore_group" "guests" {
  display_name = "guests"
  description  = "Each person in this group has individual, fine-grained access to particular cloud resources."

  identity_store_id = local.identity_center_id
}
