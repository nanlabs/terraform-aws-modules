# ---------------------------------------------------------------------------------------------------------------------
# SHARED/COMMON VARIABLES
# These variables are used across multiple resources in the module
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
# SSM PARAMETER INTEGRATION
# ---------------------------------------------------------------------------------------------------------------------

variable "create_ssm_parameters" {
  description = "Whether to create SSM parameters for MongoDB Atlas cluster details"
  type        = bool
  default     = false
}

variable "ssm_parameter_prefix" {
  description = "Prefix for SSM parameter names (e.g., '/myapp/mongodb')"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS SECRETS MANAGER INTEGRATION
# ---------------------------------------------------------------------------------------------------------------------

variable "create_secret" {
  description = "Whether to create AWS Secrets Manager secret for MongoDB Atlas connection details"
  type        = bool
  default     = false
}

variable "secret_prefix" {
  description = "Prefix for secret names (e.g., 'myapp/mongodb')"
  type        = string
  default     = ""
}

variable "secret_description" {
  description = "Description for the AWS Secrets Manager secret"
  type        = string
  default     = "MongoDB Atlas cluster connection details"
}

variable "secret_recovery_window_in_days" {
  description = "Recovery window in days for the secret deletion"
  type        = number
  default     = 7
}
