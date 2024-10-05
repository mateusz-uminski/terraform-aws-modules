variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "account_name" {
  type        = string
  description = "The name of the aws account for which cloudtrail will be configured."
}

variable "allowed_account_ids" {
  type        = list(string)
  description = "A list of account IDs that are allowed to access the cloudtrail logs bucket."
  default     = []
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store cloudtrail logs. If left empty, a new bucket will not be created."
  default     = ""
}
