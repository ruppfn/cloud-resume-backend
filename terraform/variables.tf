variable "environment" {
  type    = string
  default = "develop"

  validation {
    condition     = contains(["develop", "production"], var.environment)
    error_message = "Variable 'environment' must be 'develop' or 'production'"
  }
}
