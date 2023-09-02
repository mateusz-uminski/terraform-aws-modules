variable "org_abbreviated_name" {
  type        = string
  description = "An abbreviated name of the organization."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
}

variable "vpc_tier" {
  type        = string
  description = "The tier or category of the account in which the vpc is created."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnets in the VPC."
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnets in the VPC."
}

variable "storage_subnets" {
  type        = list(string)
  description = "The list of storage subnets in the VPC."
}

variable "vpc_flow_logs_s3_bucket_arn" {
  type    = string
  default = "The Amazon Resource Name (ARN) of the S3 bucket where VPC flow logs will be stored."
}

variable "private_subnets_ingress_nacl" {
  type        = map(string)
  description = "A map specifying ingress network access control list (NACL) rules for the private subnets."
  default     = {}
}

variable "domain_name" {
  type        = string
  description = "The suffix domain name to use by default when resolving non FQDNs."
  default     = ""
}

variable "transit_gateway_id" {
  type        = string
  description = "The ID of a transit gateway to be attached to the VPC."
  default     = ""
}
