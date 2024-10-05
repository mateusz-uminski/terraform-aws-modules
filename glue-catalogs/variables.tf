variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "database_name" {
  type        = string
  description = "The name of the Glue database where the tables will be created."
}

variable "account_ids" {
  type        = list(string)
  description = "A list of AWS account IDs that are used to create partition projections based on the account ID values in the data."
}

variable "regions" {
  type        = list(string)
  description = "A list of regions that are used to create partition projections based on the region values in the data."
}

variable "cloudtrail_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where CloudTrail logs are stored. If left empty, the table creation will be skipped."
  default     = ""
}

variable "vpc_flow_logs_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where CloudTrail logs are stored. If left empty, the table creation will be skipped."
  default     = ""
}
