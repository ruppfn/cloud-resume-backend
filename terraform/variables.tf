variable "environment" {
  type    = string
  default = "develop"

  validation {
    condition     = contains(["develop", "production"], var.environment)
    error_message = "Variable 'environment' must be 'develop' or 'production'"
  }
}

variable "zone_id" {
  type        = string
  description = "Route 53 Hosted zone ID"
}
