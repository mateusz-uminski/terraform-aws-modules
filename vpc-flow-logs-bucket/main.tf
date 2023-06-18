locals {
  org = var.org_abbreviated_name

  account_ids = concat(
    [var.account_id],
    var.allowed_account_ids
  )
}

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "${local.org}-vpc-flow-logs"

  force_destroy = true
}

data "aws_iam_policy_document" "vpc_flow_logs" {
  dynamic "statement" {
    for_each = toset(local.account_ids)
    iterator = i

    content {
      sid = "AWSLogDeliveryWrite${i.key}"

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.vpc_flow_logs.arn}/AWSLogs/${i.key}/*"]

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
        values   = ["arn:aws:logs:*:${i.key}:*"]
      }
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.vpc_flow_logs.arn}"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [for account in local.account_ids : account]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [for account in local.account_ids : "arn:aws:logs:*:${account}:*"]
    }
  }
}

resource "aws_s3_bucket_policy" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id
  policy = data.aws_iam_policy_document.vpc_flow_logs.json
}
