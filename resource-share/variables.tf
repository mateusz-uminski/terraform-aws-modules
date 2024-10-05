variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "name" {
  type        = string
  description = "The name of the resource share."
}

variable "resource_arn" {
  type        = string
  description = "The ARN of the resource to share."
}

variable "principal" {
  type        = string
  description = "The destination entity that receives access to the shared resource."
}
