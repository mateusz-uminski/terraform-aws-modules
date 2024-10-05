data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks" {
  name = "${var.org_code}-${var.project_code}-${var.cluster_name}-eks-cluster-role-${var.env_code}"

  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  permissions_boundary = var.permission_boundary_policy_arn

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

data "aws_iam_role" "eks" {
  count = var.cluster_role_name != "" ? 1 : 0

  name = var.cluster_role_name
}
