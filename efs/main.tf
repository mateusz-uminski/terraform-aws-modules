locals {
  efs_name = "${var.org_code}-${var.project_code}-${var.efs_name}-efs-${var.env_code}"
}

resource "aws_efs_file_system" "main" {
  creation_token = local.efs_name

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name = local.efs_name
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "efs" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = var.subnet_names
  }
}

data "aws_security_groups" "additional" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "group-name"
    values = var.additional_security_groups
  }
}

resource "aws_efs_mount_target" "main" {
  for_each = toset(data.aws_subnets.efs.ids)

  file_system_id = aws_efs_file_system.main.id
  subnet_id      = each.key

  security_groups = concat(
    [aws_security_group.efs.id],
    data.aws_security_groups.additional.ids
  )
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_efs_file_system_policy" "main" {
  file_system_id = aws_efs_file_system.main.id
  policy         = data.aws_iam_policy_document.policy.json
}

locals {
  create_access_point = var.access_point_dir.path != "" ? true : false
}

resource "aws_efs_access_point" "main" {
  count = local.create_access_point ? 1 : 0

  file_system_id = aws_efs_file_system.main.id

  root_directory {
    path = var.access_point_dir.path
    creation_info {
      owner_uid   = var.access_point_dir.owner
      owner_gid   = var.access_point_dir.group
      permissions = var.access_point_dir.permissions
    }
  }

  posix_user {
    uid = var.access_point_user.uid
    gid = var.access_point_user.group_id
  }

  tags = {
    Name = "${var.org_code}-${var.project_code}-${var.efs_name}-efs-ap-${var.env_code}"
  }
}
