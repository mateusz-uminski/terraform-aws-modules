data "aws_ami" "main" {
  owners      = ["aws-marketplace"]
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

data "aws_subnets" "asg" {
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

resource "aws_placement_group" "main" {
  name     = "${var.org_code}-${var.project_code}-${var.asg_name}-placement-grp-${var.env_code}"
  strategy = var.placement_group
}

locals {
  security_groups = concat([aws_security_group.ec2.id], data.aws_security_groups.additional.ids)

  root_ebs = {
    "root_ebs" = {
      device_name = var.root_ebs.device_name
      size        = var.root_ebs.size
      type        = ""
    }
  }
  ebs = merge(local.root_ebs, var.additional_ebs)
}

resource "aws_launch_template" "main" {
  name        = "${var.org_code}-${var.project_code}-${var.asg_name}-lnch-tpl-${var.env_code}"
  description = "Launch template of ${local.asg_name} autoscaling group."

  image_id      = data.aws_ami.main.id
  instance_type = var.instance_type
  key_name      = var.key_pair

  dynamic "network_interfaces" {
    for_each = var.assign_public_ip ? [1] : []

    content {
      associate_public_ip_address = var.assign_public_ip
      security_groups             = var.assign_public_ip ? local.security_groups : []
    }
  }

  dynamic "iam_instance_profile" {
    for_each = var.instance_profile_name != "" ? [1] : []
    content {
      name = var.instance_profile_name
    }
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  vpc_security_group_ids = var.assign_public_ip ? [] : local.security_groups

  dynamic "block_device_mappings" {
    for_each = local.ebs
    iterator = i

    content {
      device_name = i.value.device_name
      ebs {
        volume_size = i.value.size
        # delete_on_termination = true
        volume_type = i.value.type != "" ? i.value.type : null
      }
    }
  }

  user_data = base64encode(var.user_data)

  placement {
    group_name = aws_placement_group.main.id
  }

  update_default_version = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.org_code}-${var.project_code}-${var.asg_name}-asg-${var.env_code}"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.org_code}-${var.project_code}-${var.asg_name}-ebs-${var.env_code}"
    }
  }
}
