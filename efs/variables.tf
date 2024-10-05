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

variable "efs_name" {
  type        = string
  description = "The name of the Elastic File System."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC in which the EFS will be created."
}

variable "subnet_names" {
  type        = list(string)
  description = "The names of the subnets in which the EFS mount targets will be created."
}

variable "access_point_dir" {
  type = object({
    path        = string
    owner       = number
    group       = number
    permissions = string
  })
  description = "Configuration for the access point directory."
  default = {
    path        = ""
    owner       = 1000
    group       = 1000
    permissions = "444"
  }
}

variable "access_point_user" {
  type = object({
    uid      = number
    group_id = number
  })
  description = "Configuration for the access point user."
  default = {
    uid      = 1000
    group_id = 1000
  }
}

variable "additional_security_groups" {
  type        = list(string)
  description = "A list of additional security group names to attach to the Elastic File System."
  default     = []
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
