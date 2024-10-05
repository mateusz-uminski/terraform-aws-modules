output "arn" {
  value       = aws_ram_principal_association.invite.resource_share_arn
  description = "The ARN of the resource share."
}
