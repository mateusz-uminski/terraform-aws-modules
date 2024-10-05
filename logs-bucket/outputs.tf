output "arn" {
  value       = aws_s3_bucket.logs.arn
  description = "The ARN of the created S3 bucket.."
}

output "name" {
  value       = aws_s3_bucket.logs.id
  description = "The name of the created S3 bucket."
}
