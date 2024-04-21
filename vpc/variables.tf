variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "project_code" {
  type        = string
  description = "A unique identifier or code for the project."
}

variable "env_code" {
  type        = string
  description = "A unique code or identifier for the environment."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
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

variable "create_nat_gateway" {
  type        = bool
  description = "Specifies whether to create a NAT gateways in each private subnet."
  default     = false
}

variable "vpc_flow_logs_s3_bucket_arn" {
  type        = string
  description = "The Amazon R esource Name (ARN) of the S3 bucket where VPC flow logs will be stored."
  default     = ""
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

variable "transit_gateway_destination_cidr" {
  type        = string
  description = "The ID of a transit gateway to be attached to the VPC."
  default     = "0.0.0.0/0"
}

variable "tags" {
  type        = map(string)
  description = "Defines custom tags to be applied to all AWS resources created by the module."
  default     = {}
}
