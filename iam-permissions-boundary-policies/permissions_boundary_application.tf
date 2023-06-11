resource "aws_iam_policy" "application_permissions_boundary" {
  name = "${local.org}-application-permissions-boundary-policy"
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
        Sid    = "DenyIAM"
        Effect = "Deny"
        Action = [
          "iam:*",
        ]
        Resource = ["*"]
      }
    ]
  })
}
