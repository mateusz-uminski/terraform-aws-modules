variable "email_address" {
  type        = string
  description = "The email address of the recipient to notify when threshold has exceeded."

  validation {
    # it is a simple regex to validate email address
    condition     = can(regex("^(.+)@(.+)[.](.+)$", var.email_address))
    error_message = "The email address must follow the pattern [username@domain.com]."
  }
}

variable "budget_limit" {
  type        = string
  description = ""

}

variable "budget_duration" {
  type        = string
  description = ""

}
