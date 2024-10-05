# budget

Terraform module that creates a monthly budget in the AWS cloud and sets up
an email notification. The email notification is sent when the actual
costs have exceed 80% of the budget.


# Usage
```terraform
module "monthly_budget" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget?ref=main"

  # required variables
  org_code      = "org"
  email_address = "recipient@domain.com"

  # optional variables
  usd_limit = 10
}
```
