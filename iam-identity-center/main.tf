locals {
  org = var.org_abbreviated_name

  aws_accounts     = { for i in var.aws_accounts : i.account_id => i.account_tier }
  account_ids      = [for i in var.aws_accounts : i.account_id]
  session_duration = "PT2H"
}
