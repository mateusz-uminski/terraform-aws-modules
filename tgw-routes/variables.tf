variable "tgw_attachment_id" {
  type        = string
  description = "The ID of the transit gateway attachment to associate with the route table."
}

variable "associate_tgw_rt" {
  type        = string
  description = "The name of the transit gateway route table to be associated with the attachment."
}

variable "propagate_tgw_rt" {
  type        = list(string)
  description = "The list of transit gateway route tables to which routes should be propagated."
  default     = []
}

variable "blackholes" {
  type        = list(string)
  description = "The list of CIDRs to define blackhole routes."
  default     = []
}

variable "static_routes" {
  type = list(object({
    cidr          = string
    attachment_id = string
  }))
  description = "The list of static routes."
  default     = []
}
