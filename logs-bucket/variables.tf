variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "service_name" {
  type        = string
  description = "The name of the service that will generate the logs to be stored in."
}

variable "service_addr" {
  type        = string
  description = " The logging endpoint or domain of the service that sends logs to the S3 bucket (e.g., awslogs.elb.amazon.com)."
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
