resource "aws_identitystore_group" "project_admins" {
  display_name = "${var.project_name}-admins"
  description  = "Members of this group manage all ${var.project_name} project resources in the organization."

  identity_store_id = local.identity_center_id
}

resource "aws_identitystore_group" "project_developers" {
  display_name = "${var.project_name}-developers"
  description  = "Members of this group have limited access to ${var.project_name} project resource management in the organization."

  identity_store_id = local.identity_center_id
}
