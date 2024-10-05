data "aws_organizations_organization" "org" {}

locals {
  root_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "groups" {
  count = length(var.unit_prefixes)

  name      = "${var.unit_prefixes[count.index]}-accounts"
  parent_id = local.root_id
}

data "aws_iam_policy_document" "limit_to_regions" {
  statement {
    not_actions = [
      "aws-portal:*",
      "cloudfront:*",
      "iam:*",
      "route53:*",
      "support:*"
    ]
    effect    = "Deny"
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = var.operating_regions
    }
  }
}

resource "aws_organizations_policy" "limit_to_regions" {
  name = "limit-access-only-to-regions-where-organization-operates"

  content = data.aws_iam_policy_document.limit_to_regions.json
}

resource "aws_organizations_policy_attachment" "limit_to_regions_root" {
  policy_id = aws_organizations_policy.limit_to_regions.id
  target_id = local.root_id
}
