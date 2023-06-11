resource "aws_iam_policy" "project_provisioner_permissions_boundary" {
  name = "${local.org}-project-provisioner-permissions-boundary-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowAll"
        Effect   = "Allow"
        Action   = ["*"]
        Resource = ["*"]
      },
      {
        Sid    = "DenyIAMUserCreate"
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:CreateAccessKey"
        ]
        Resource = ["*"]
      },
      {
        Sid    = "EnforceSAPermissionsBoundaryPolicy"
        Effect = "Deny"
        Action = [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:PutRolePermissionsBoundary"
        ]
        Resource = "*"
        Condition = {
          StringNotLike = {
            "iam:PermissionsBoundary" : "arn:aws:iam::*:policy/${local.org}-application-permissions-boundary-policy"
          }
        },
      },
      {
        Sid    = "DenyPermissionsBoundaryPolicyEdit"
        Effect = "Deny"
        Action = [
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:SetDefaultPolicyVersion"
        ]
        Resource = [
          "arn:aws:iam::*:policy/${local.org}-application-permissions-boundary-policy",
          "arn:aws:iam::*:policy/${local.org}-project-admin-permissions-boundary-policy",
          "arn:aws:iam::*:policy/${local.org}-project-provisioner-permissions-boundary-policy"
        ]
      },
      {
        Sid      = "DenyPermissionsBoundaryPolicyDelete"
        Effect   = "Deny"
        Action   = ["iam:DeleteRolePermissionsBoundary"]
        Resource = ["*"]
      }
    ]
  })
}
