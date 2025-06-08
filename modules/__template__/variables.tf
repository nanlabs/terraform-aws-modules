variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket"
  type        = bool
  default     = false
}

variable "acl" {
  description = "Canned ACL to apply to the bucket"
  type        = string
  default     = "private"
}

variable "enable_versioning" {
  description = "Whether to enable versioning"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "enable_lifecycle_rule" {
  description = "Enable lifecycle rule"
  type        = bool
  default     = true
}

variable "lifecycle_transition_days" {
  description = "Number of days after which to transition objects"
  type        = number
  default     = 30
}

variable "lifecycle_storage_class" {
  description = "Storage class for lifecycle transition"
  type        = string
  default     = "GLACIER"
}

variable "lifecycle_expiration_days" {
  description = "Number of days after which to expire objects"
  type        = number
  default     = 90
}

variable "logging_bucket" {
  description = "S3 bucket for access logs"
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id      = string
    enabled = bool
    transition = optional(object({
      days          = number
      storage_class = string
    }))
    expiration = optional(object({
      days = number
    }))
    noncurrent_version_expiration = optional(object({
      days = number
    }))
  }))
  default = []
}
