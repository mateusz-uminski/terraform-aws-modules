variable "org_abbreviated_name" {
  type        = string
  description = "An abbreviated name of the organization."
}

variable "aws_accounts" {
  type = list(object({
    account_name = string
    account_tier = string
    account_id   = string
  }))
  description = "The list of aws accounts for which SSO access should be configured."
}
