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

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "The version of Kubernetes."
}

variable "kubernetes_pod_cidr" {
  type        = string
  description = "The CIDR block for Kubernetes pods that will be associated with the vpc."
}

variable "cluster_pod_subnets" {
  type        = list(string)
  description = "The list of EKS subnets in the VPC."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC in which the EKS cluster will be created."
}

variable "subnet_names" {
  type        = list(string)
  description = "The names of subnets in which the EKS control plane interfaces will be placed."
}

variable "enable_private_endpoint" {
  type        = string
  description = "Indicates whether to enable a private endpoint for the EKS cluster."
  default     = true
}

variable "enable_public_endpoint" {
  type        = bool
  description = "Indicates whether to enable a public endpoint for the EKS cluster."
  default     = false
}

variable "endpoint_allowed_cidrs" {
  type        = list(string)
  description = "A list of allowed CIDR blocks for accessing the EKS cluster's endpoint."
  default     = []
}

variable "kubernetes_service_cidr" {
  type        = string
  description = "The CIDR block for Kubernetes services."
  default     = "172.20.0.0/16"
}

variable "cluster_role_name" {
  type        = string
  description = "The name of the IAM role associated with the EKS cluster."
  default     = ""
}

variable "enable_enhanced_logging" {
  type        = bool
  description = "Indicates whether to enable enhanced logging for the EKS cluster."
  default     = false
}

variable "permission_boundary_policy_arn" {
  type        = string
  description = "The ARN of a permissions boundary policy that will be attached to the default EKS cluster role."
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
