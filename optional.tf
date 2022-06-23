variable "name" {
  description = "(optional) Name of the ECR repository (defaults to product if null)"
  default     = null
  type        = string
}

variable "scan_on_push" {
  description = "(optional) Security scan on push"
  default     = true
  type        = bool
}

variable "images_to_retain" {
  description = "(optional) Number of most recent images to retain (set to null for no retention policy)"
  default     = 50
  type        = number
  validation {
    condition     = var.images_to_retain == null || try(var.images_to_retain > 0, false)
    error_message = "Images_to_retain must be a number greater than zero or null."
  }
}

variable "image_tag_mutability" {
  description = "(optional) Image tag mutability (allowance for a tag be reassigned to another image)"
  default     = "IMMUTABLE"
  type        = string
  validation {
    condition     = can(regex("^MUTABLE$|^IMMUTABLE$", var.image_tag_mutability))
    error_message = "Valid values are \"MUTABLE\" and \"IMMUTABLE\"."
  }
}
