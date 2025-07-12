# Shared Variables (used across multiple modules)

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Any extra tags to assign to objects"
  type        = map(any)
  default     = {}
}

# SSM Parameters
variable "create_ssm_parameters" {
  description = "Whether to create SSM parameters for bastion host details"
  type        = bool
  default     = true
}

variable "ssm_parameter_prefix" {
  description = "Prefix for SSM parameter names. If not provided, will use '/{name}'"
  type        = string
  default     = ""
}
