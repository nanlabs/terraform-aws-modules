# Shared Module Variables
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_ssm_parameters" {
  description = "Whether to create SSM parameters for RDS instance details"
  type        = bool
  default     = true
}

variable "ssm_parameter_prefix" {
  description = "Prefix for SSM parameter names. If not provided, will use '/{name}'"
  type        = string
  default     = ""
}
