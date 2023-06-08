locals {
  guest_assignments = setproduct(local.account_ids, [aws_identitystore_group.guests.group_id])
}

resource "aws_ssoadmin_permission_set" "guest" {
  for_each = local.aws_accounts

  name             = "${local.org}-guest-${each.value}"
  instance_arn     = local.identity_center_arn
  session_duration = local.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "guest" {
  for_each = local.aws_accounts

  instance_arn       = local.identity_center_arn
  permission_set_arn = aws_ssoadmin_permission_set.guest[each.key].arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowAssumeGuestRoles"

        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = ["arn:aws:iam::*:role/guest/${local.org}-guest-*"]
      }
    ]
  })
}

resource "aws_ssoadmin_account_assignment" "guest" {
  for_each = { for i, v in local.guest_assignments : "${i}" => { account_id = v[0], group_id = v[1] } }

  instance_arn       = local.identity_center_arn
  permission_set_arn = aws_ssoadmin_permission_set.guest[each.value.account_id].arn

  principal_id   = each.value.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
