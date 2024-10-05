locals {
  asg_name = "${var.org_code}-${var.project_code}-${var.asg_name}-asg-${var.env_code}"
}

resource "aws_autoscaling_group" "main" {
  name             = local.asg_name
  min_size         = var.asg_capacity
  max_size         = var.asg_capacity
  desired_capacity = var.asg_capacity

  vpc_zone_identifier = data.aws_subnets.asg.ids

  launch_template {
    name    = aws_launch_template.main.name
    version = aws_launch_template.main.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage       = 50
      scale_in_protected_instances = "Refresh"
      standby_instances            = "Terminate"
    }
  }
}

locals {
  create_tg = var.exposed_port != 0 && var.protocol != "" ? true : false
}

resource "aws_lb_target_group" "asg" {
  count = local.create_tg ? 1 : 0

  name        = "${var.org_code}-${var.project_code}-${var.asg_name}-asg-tg-${var.env_code}"
  target_type = "instance"
  port        = var.exposed_port
  protocol    = var.protocol

  vpc_id = data.aws_vpc.main.id

}

resource "aws_autoscaling_attachment" "asg" {
  count = local.create_tg ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.main.id
  lb_target_group_arn    = aws_lb_target_group.asg[count.index].arn
}
