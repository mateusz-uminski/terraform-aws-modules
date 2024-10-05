variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "name" {
  type        = string
  description = "The name of the transit gateway."
}

variable "asn" {
  type        = string
  description = "Private Autonomous System Number (ASN) for the Amazon side of BGP session."
}

variable "route_table_names" {
  type        = list(string)
  description = "The list of names for the transit gateway route tables."
}
