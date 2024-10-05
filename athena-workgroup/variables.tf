variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "workgroup_name" {
  type        = string
  description = "The name of the athena workgroup."
}

variable "bucket_owner" {
  type        = string
  description = "The AWS account ID of the owner of the S3 bucket where the Athena workgroup's results are stored."
}
