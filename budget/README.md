# budget

Terraform module that creates a monthly budget in the AWS cloud and sets up
an email notification. The email notification is sent when the actual
costs have exceed 100% of the budget.

# How to use?
1. Import from main branch
```sh
source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget"
```
2. Import from a specific branch
```sh
source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget?ref=branch"
```
3. Import a specific version
```sh
source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget?ref=v0.0.1"
```

# Example usage
```terraform
module "monthly_budget" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//budget?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  email_address        = "recipient@domain.com"

  # optional variables
  usd_limit = 10
}
```
