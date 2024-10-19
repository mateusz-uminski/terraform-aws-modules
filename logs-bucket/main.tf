locals {
  account_ids = concat(
    [var.account_id],
    var.allowed_account_ids
  )
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.org_code}-${var.service_name}-logs"

  force_destroy = true
}

data "aws_iam_policy_document" "allow_from_svc" {
  dynamic "statement" {
    for_each = toset(local.account_ids)
    iterator = i

    content {
      sid = "AWSLogDeliveryWrite${i.key}"

      principals {
        type        = "Service"
        identifiers = [var.service_addr]
      }

      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${i.key}/*"]

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
        values   = ["${var.service_arn_prefix}:*:${i.key}:*"]
      }
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = [var.service_addr]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [for account in local.account_ids : account]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [for account in local.account_ids : "${var.service_arn_prefix}:*:${account}:*"]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.allow_from_svc.json
}
