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

variable "instance_name" {
  type        = string
  description = "The name of the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "The type of the EC2 instance."
}

variable "ami_name_pattern" {
  type        = string
  description = "The pattern for selecting AMI for the EC2 instance."
}

variable "key_pair" {
  type        = string
  description = "The key pair name used for."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC in which the EC2 instance will be launched."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet in which the EC2 instance will be launched."
}

variable "assign_public_ip" {
  type        = bool
  description = "Indicates whether to assign a public IP address to the EC2 instance."
  default     = false
}

variable "instance_profile_name" {
  type        = string
  description = "The name of the instance profile tto attach to the instance."
  default     = ""
}

variable "enable_detailed_monitoring" {
  type        = bool
  description = "Whether to enable detailed monitoring for the EC2 instance (true/false)."
  default     = false
}

variable "root_ebs_size" {
  type        = number
  description = "The size of the root block device in gigabytes."
  default     = 0
}

variable "additional_ebs" {
  type = map(object({
    size        = number
    device_name = string
    type        = string
  }))
  description = "Additional EBS volumes to attach to the instance, specified as a map with size, device name, and type for each volume."
  default     = {}
}

variable "user_data" {
  type        = string
  description = "Custom script to be executed during the launch of the EC2 instance."
  default     = ""
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

variable "tags" {
  type        = map(string)
  description = "Defines custom tags to be applied to all AWS resources created by the module."
  default     = {}
}
