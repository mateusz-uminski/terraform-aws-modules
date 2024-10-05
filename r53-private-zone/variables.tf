variable "zone_name" {
  type        = string
  description = "The name of the route53 private hosted zone."
}

variable "vpcs" {
  type = map(object({
    vpc_id = string
    region = string
  }))
  description = "A map of VPCs and their respective regions for associating with the private hosted zone."
}

variable "external_vpcs" {
  type = map(object({
    vpc_id = string
    region = string
  }))
  description = "A map of VPCs from other AWS accounts and their respective regions for associating with the private hosted zone."
  default     = {}
}
