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

variable "asg_name" {
  type        = string
  description = "The name of the Auto Scaling Group."
}

variable "asg_capacity" {
  type        = number
  description = "The desired capacity of the Auto Scaling Group."
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

variable "subnet_names" {
  type        = list(string)
  description = "The names of the subnets in which the EC2 instance will be launched."
}

variable "placement_group" {
  type        = string
  description = "The name of the placement strategy."
  default     = "partition"
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

variable "root_ebs" {
  type = object({
    device_name = string
    size        = number
  })
  description = "Configuration for the root EBS volume, including the device name and size in gigabytes."
  default = {
    device_name = ""
    size        = 0
  }
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

variable "exposed_port" {
  type        = number
  description = "Port for target group (0 if not applicable)."
  default     = 0
}

variable "protocol" {
  type        = string
  description = "Target group protocol. Leave empty if not used."
  default     = ""
}
