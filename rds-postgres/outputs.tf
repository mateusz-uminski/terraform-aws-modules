output "primary_rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "The primary endpoint of the RDS instance."
}

output "standby_rds_endpoints" {
  value       = aws_db_instance.standby[*].endpoint
  description = "The endpoint addresses of standby RDS instances, if any exist."
}
