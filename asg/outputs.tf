output "target_group_arn" {
  value = local.create_tg ? aws_lb_target_group.asg[0].arn : ""
}
