output "arn" {
  value       = aws_s3_bucket.vpc_flow_logs.arn
  description = "The ARN of the created S3 bucket for VPC flow logs."
}

output "name" {
  value       = aws_s3_bucket.vpc_flow_logs.id
  description = "The name of the created S3 bucket for VPC flow logs."
}
