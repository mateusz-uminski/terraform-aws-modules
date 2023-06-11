variable "users" {
  type = map(object({
    display_name = string
    given_name   = string
    family_name  = string
    email        = string
    project      = string
    groups       = list(string)
  }))
  description = "The map that defines user details including AWS Identity groups to which the user should be assigned. The keys correspond to user logins."
}
