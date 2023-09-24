output "efs_id" {
  value       = aws_efs_file_system.main.id
  description = "The ID of the created Elastic File System."
}

output "efs_dns_name" {
  value       = aws_efs_file_system.main.dns_name
  description = "The DNS name associated with the created Elastic File System."
}
