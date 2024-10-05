variable "unit_prefixes" {
  type        = list(string)
  description = "List of prefixes for organizational units."
}

variable "operating_regions" {
  type        = list(string)
  description = <<EOF
List of regions in which the organization operates.
All AWS actions in regions that are not on this list are blocked"
EOF
}
