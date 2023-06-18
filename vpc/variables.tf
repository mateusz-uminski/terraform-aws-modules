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

variable "vpc_flow_logs" {
  type        = bool
  description = "A boolean value indicating whether VPC flow logs should be enabled."
  default     = true
}

variable "private_subnets_ingress_nacl" {
  type        = map(string)
  description = "A map specifying ingress network access control list (NACL) rules for the private subnets."
  default     = {}
}
