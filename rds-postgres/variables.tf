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

variable "db_name" {
  type        = string
  description = "The name of the RDS instance."
}

variable "db_instance_class" {
  type        = string
  description = "The RDS instance class."
}

variable "storage_size" {
  type        = number
  description = "The size of storage allocated to the RDS instance in GB."
}

variable "db_engine_version" {
  type        = string
  description = "The version of the database engine."
}

variable "parameter_group_family" {
  type        = string
  description = "The parameter group family for the RDS instance."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC in which the RDS instance will be created."
}

variable "subnet_names" {
  type        = list(string)
  description = "The names of the subnets in which the RDS instance will be placed."
}

variable "db_port" {
  type        = number
  description = "The port on which the RDS instance will listen."
  default     = 5432
}

variable "is_mutli_az" {
  type        = bool
  description = "Indicates whether the RDS instance is multi-AZ."
  default     = false
}

variable "is_public" {
  type        = bool
  description = "Indicates whether the RDS instance is publicly accessible."
  default     = false
}

variable "db_username" {
  type        = string
  description = "The admin username for the RDS instance."
  default     = "cloudadmin"
}

variable "db_password" {
  type        = string
  description = "The admin password for the RDS instance."
  default     = "cloudadmin"
}

variable "ca_identifier" {
  type        = string
  description = "The identifier for the certificate authority (CA) used by the RDS instance."
  default     = "rds-ca-rsa2048-g1"
}

variable "number_of_standby_instances" {
  type        = number
  description = "The number of standby instances for high availability."
  default     = 0
}

variable "enable_enhanced_monitoring" {
  type        = bool
  description = "Indicates whether enhanced monitoring is enabled."
  default     = false
}

variable "enable_performance_insights" {
  type        = bool
  description = "Indicates whether performance insights are enabled."
  default     = false
}

variable "permissions_boundary_policy_arn" {
  type        = string
  description = "The ARN of a permissions boundary policy attached to the monitoring role."
  default     = ""
}

variable "parameters" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "A list of database parameters to override the default parameters from the parameter group family."
  default     = []
}

variable "additional_security_groups" {
  type        = list(string)
  description = "A list of additional security group names to attach to the EC2 instance."
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
