variable "org_abbreviated_name" {
  type        = string
  description = "An abbreviated name of the organization, that is an owner of the budget."
}

variable "account_id" {
  type        = string
  description = "The ID of the account where the bucket will be created."
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "The list of accounts that are allowed to access the bucket."
  default     = []
}
