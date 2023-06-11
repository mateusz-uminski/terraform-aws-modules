resource "aws_identitystore_user" "main" {
  for_each = var.users

  identity_store_id = local.identity_center_id

  display_name = each.value.display_name
  user_name    = each.key

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value = each.value.email
  }
}

locals {
  assigments = flatten([
    for k, v in local.users : [
      for group in v.groups : {
        user_name  = k
        group_name = group
      }
    ]
  ])
}

data "aws_identitystore_group" "main" {
  for_each = { for i in local.assigments : "${i.user_name}-${i.group_name}" => i.group_name }

  identity_store_id = local.identity_center_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}

data "aws_identitystore_user" "main" {
  for_each = { for i in local.assigments : "${i.user_name}-${i.group_name}" => i.user_name }

  identity_store_id = local.identity_center_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }

  depends_on = [aws_identitystore_user.main]
}

resource "aws_identitystore_group_membership" "main" {
  for_each = { for i in local.assigments : "${i.user_name}-${i.group_name}" => null }

  identity_store_id = local.identity_center_id

  group_id  = data.aws_identitystore_group.main[each.key].id
  member_id = data.aws_identitystore_user.main[each.key].user_id
}
