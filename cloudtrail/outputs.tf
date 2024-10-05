output "bucket_name" {
  value       = local.create_bucket == true ? aws_s3_bucket.cloudtrail[0].id : ""
  description = "The name of the created S3 bucket for the cloudtrail."
}
