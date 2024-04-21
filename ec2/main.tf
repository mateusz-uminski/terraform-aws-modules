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

data "aws_subnet" "main" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

data "aws_security_groups" "additional" {
  filter {
    name   = "group-name"
    values = var.additional_security_groups
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.main.id
  subnet_id     = data.aws_subnet.main.id
  instance_type = var.instance_type
  key_name      = var.key_pair

  associate_public_ip_address = var.assign_public_ip
  iam_instance_profile        = var.instance_profile_name
  monitoring                  = var.enable_detailed_monitoring

  vpc_security_group_ids = concat(
    [aws_security_group.main.id],
    data.aws_security_groups.additional.ids
  )

  dynamic "root_block_device" {
    for_each = var.root_ebs_size != 0 ? [1] : []

    content {
      volume_size = var.root_ebs_size

      tags = merge(
        {
          Name = "${var.org_code}-${var.project_code}-${var.instance_name}-root-ebs-${var.env_code}"
        },
        var.tags
      )
    }
  }

  user_data = var.user_data

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.instance_name}-ec2-${var.env_code}"
    },
    var.tags
  )
}

resource "aws_ebs_volume" "additional" {
  for_each = var.additional_ebs

  availability_zone = data.aws_subnet.main.availability_zone
  size              = each.value.size

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.instance_name}-${each.key}-${var.env_code}"
    },
    var.tags
  )
}

resource "aws_volume_attachment" "additional" {
  for_each = var.additional_ebs

  instance_id = aws_instance.main.id
  volume_id   = aws_ebs_volume.additional[each.key].id
  device_name = each.value.device_name
}
