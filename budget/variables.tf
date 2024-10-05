variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "email_address" {
  type        = string
  description = "An email address of the recipient who should be notified when threshold has exceeded."

  validation {
    # it is a simple regex to validate email address
    condition     = can(regex("^(.+)@(.+)[.](.+)$", var.email_address))
    error_message = "The email address must follow the pattern [username@domain.com]."
  }
}

variable "usd_limit" {
  type        = number
  description = "The number of dollars that can be spent per month without triggering a notification."
  default     = 10
}
