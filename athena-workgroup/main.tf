locals {
  org = var.org_abbreviated_name
}

resource "aws_s3_bucket" "output" {
  bucket = "${local.org}-${var.workgroup_name}-athena-query-output"
}

resource "aws_s3_bucket_lifecycle_configuration" "output" {
  bucket = aws_s3_bucket.output.id

  rule {
    id     = "expire-after-7d"
    status = "Enabled"

    filter {}

    expiration {
      days = 7
    }
  }
}

resource "aws_athena_workgroup" "main" {
  name = "${local.org}-${var.workgroup_name}-athena-workgroup"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location       = "s3://${aws_s3_bucket.output.bucket}/"
      expected_bucket_owner = var.bucket_owner
    }
  }
}
