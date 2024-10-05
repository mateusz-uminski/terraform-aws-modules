resource "aws_cloudtrail" "main" {
  name                          = "${var.account_name}-multiregion-trail"
  s3_bucket_name                = var.bucket_name == "" ? aws_s3_bucket.cloudtrail[0].id : var.bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = ""
}
