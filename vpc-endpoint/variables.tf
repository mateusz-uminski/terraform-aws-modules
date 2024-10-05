variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "env_code" {
  type        = string
  description = "A unique code or identifier for the environment."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC in which the endpoint will be created."
}

variable "subnet_names" {
  type        = list(string)
  description = "The name of the subnet in which the EC2 instance will be launched."
}

variable "vpc_endpoint_name" {
  type        = string
  description = "The name of the VPC endpoint to be created."
}

variable "aws_service" {
  type        = string
  description = "The AWS service for which the VPC endpoint is being created."
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks for allowed inbound traffic."
  default     = []
}

variable "allowed_ingress_sgs" {
  type        = list(string)
  description = "A list of security group names for allowed inbound traffic."
  default     = []
}

variable "vpc_endpoint_policy" {
  type        = string
  description = "An optional policy document defining the permissions for the VPC endpoint."
  default     = ""
}
