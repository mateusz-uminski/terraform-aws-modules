resource "aws_budgets_budget" "monthly_budget" {
  name              = "monthly-learning-budget-${var.budget_limit}USD"
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_period_start = timestamp() # "2022-03-05_00:00"
  time_period_end   = timeadd(timestamp(), var.budget_duration)
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.email_address]
  }
}
