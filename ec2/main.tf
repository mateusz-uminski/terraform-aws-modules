locals {
  org = var.org_abbreviated_name
}

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

  security_groups = concat(
    [aws_security_group.main.id],
    data.aws_security_groups.additional.ids
  )

  tags = {
    Name = "${local.org}-${var.project}-${var.instance_name}-ec2-${var.environment}"
  }
}
