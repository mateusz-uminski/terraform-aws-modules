output "target_group_arn" {
  value       = local.create_tg ? aws_lb_target_group.asg[0].arn : ""
  description = "The ARN of the associated target group, or an empty string if not created."
}
