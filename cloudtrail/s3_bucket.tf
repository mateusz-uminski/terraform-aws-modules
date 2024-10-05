locals {
  account_ids = var.allowed_account_ids

  create_bucket = var.bucket_name == "" ? true : false
}

resource "aws_s3_bucket" "cloudtrail" {
  count = local.create_bucket == true ? 1 : 0

  bucket        = "${var.org_code}-multiregion-cloudtrail-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "cloudtrail" {
  count = local.create_bucket == true ? 1 : 0

  dynamic "statement" {
    for_each = toset(local.account_ids)
    iterator = i

    content {
      sid = "CloudTrailWrite${i.key}"

      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }

      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.cloudtrail[0].arn}/AWSLogs/${i.key}/*"]

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = ["${i.key}"]
      }

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = ["arn:aws:cloudtrail:*:${i.key}:trail/*"]
      }
    }
  }

  statement {
    sid = "CloudTrailACLCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.cloudtrail[0].arn}"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [for account in local.account_ids : account]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [for account in local.account_ids : "arn:aws:cloudtrail:*:${account}:trail/*"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  count = local.create_bucket == true ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail[0].id
  policy = data.aws_iam_policy_document.cloudtrail[0].json
}
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
