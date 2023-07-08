variable "org_abbreviated_name" {
  type        = string
  description = "An abbreviated name of the organization, that is an owner of the budget."
}

variable "workgroup_name" {
  type        = string
  description = "The name of the athena workgroup."
}

variable "bucket_owner" {
  type        = string
  description = "The AWS account ID of the owner of the S3 bucket where the Athena workgroup's results are stored."
}
