resource "aws_budgets_budget" "monthly" {
  name              = "${var.org_code}-monthly-budget-${var.usd_limit}USD"
  budget_type       = "COST"
  limit_amount      = var.usd_limit
  limit_unit        = "USD"
  time_period_start = formatdate("YYYY-MM-DD_hh:mm", timestamp())
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.email_address]
  }

  lifecycle {
    ignore_changes = [time_period_start]
  }
}

module "monthly_budget" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget?ref=main"

  # required variables
  org_code      = "mcd"
  email_address = "recipient@domain.com"

  # optional variables
  usd_limit = 10
}
