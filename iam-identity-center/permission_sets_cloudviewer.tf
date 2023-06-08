locals {
  cloudviewer_assignments = setproduct(local.account_ids, [aws_identitystore_group.cloudviewers.group_id])
}

resource "aws_ssoadmin_permission_set" "cloudviewer" {
  for_each = local.aws_accounts

  name             = "${local.org}-cloudviewer-${each.value}"
  instance_arn     = local.identity_center_arn
  session_duration = local.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "cloudviewer" {
  for_each = local.aws_accounts

  instance_arn       = local.identity_center_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.cloudviewer[each.key].arn
}

resource "aws_ssoadmin_account_assignment" "cloudviewer" {
  for_each = { for i, v in local.cloudviewer_assignments : "${i}" => { account_id = v[0], group_id = v[1] } }

  instance_arn       = local.identity_center_arn
  permission_set_arn = aws_ssoadmin_permission_set.cloudviewer[each.value.account_id].arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
