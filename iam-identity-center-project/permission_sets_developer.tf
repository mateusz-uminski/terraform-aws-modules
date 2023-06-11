locals {
  developer_assignments = setproduct(local.account_ids, [aws_identitystore_group.project_admins.group_id])
}

resource "aws_ssoadmin_permission_set" "developer" {
  for_each = local.aws_accounts

  name             = "${local.org}-${var.project_name}-developer-${each.value}"
  instance_arn     = local.identity_center_arn
  session_duration = local.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "developer" {
  for_each = local.aws_accounts

  instance_arn       = local.identity_center_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer[each.key].arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowManageEC2"

        Effect   = "Allow"
        Action   = ["ec2:*"]
        Resource = ["arn:aws:ec2::*:${local.org}-${var.project_name}-*"]
      }
    ]
  })
}

resource "aws_ssoadmin_managed_policy_attachment" "developer" {
  for_each = local.aws_accounts

  instance_arn       = local.identity_center_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.developer[each.key].arn
}

resource "aws_ssoadmin_account_assignment" "developer" {
  for_each = { for i, v in local.admin_assignments : "${i}" => { account_id = v[0], group_id = v[1] } }

  instance_arn       = local.identity_center_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer[each.value.account_id].arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
