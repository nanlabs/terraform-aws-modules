variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "tags" {
  description = "Any extra tags to assign to objects"
  type        = map(any)
  default     = {}
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs (required when create_s3_bucket is true)"
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "The prefix for the S3 bucket keys"
  type        = string
  default     = "cloudtrail"
}

variable "include_global_service_events" {
  description = "Specifies whether the trail is publishing events from global services"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Specifies whether the trail is created in all regions"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enables logging for the trail"
  type        = bool
  default     = true
}

variable "event_selector" {
  description = "Event selector configuration"
  type = list(object({
    read_write_type                  = optional(string, "All")
    include_management_events        = optional(bool, true)
    exclude_management_event_sources = optional(list(string), [])
    data_resource = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  }))
  default = []
}

variable "insight_selector" {
  description = "Insight selector configuration for CloudTrail Insights"
  type = list(object({
    insight_type = string
  }))
  default = []
}

variable "kms_key_id" {
  description = "The KMS key ID to use for encryption"
  type        = string
  default     = null
}

variable "create_s3_bucket" {
  description = "Whether to create the S3 bucket for CloudTrail logs"
  type        = bool
  default     = true
}

variable "s3_bucket_arn" {
  description = "ARN of an existing S3 bucket for CloudTrail logs (used when create_s3_bucket is false)"
  type        = string
  default     = null
}

variable "cross_account_source_arns" {
  description = "List of source ARNs from other accounts that can write to this CloudTrail bucket"
  type        = list(string)
  default     = []
}

# Phase 1 hardening variables
variable "enable_log_file_validation" {
  description = "Enable CloudTrail log file validation to detect tampering"
  type        = bool
  default     = true
}

variable "enforce_tls" {
  description = "Deny S3 access to the bucket over insecure (non-SSL) transport"
  type        = bool
  default     = true
}

variable "bucket_encryption_mode" {
  description = "Default bucket encryption mode for CloudTrail bucket (SSE_S3 or SSE_KMS)"
  type        = string
  default     = "SSE_S3"
  validation {
    condition     = contains(["SSE_S3", "SSE_KMS"], var.bucket_encryption_mode)
    error_message = "bucket_encryption_mode must be one of: SSE_S3, SSE_KMS."
  }
}

variable "bucket_kms_key_arn" {
  description = "KMS key ARN to use when bucket_encryption_mode is SSE_KMS"
  type        = string
  default     = null
}

variable "lifecycle_days_ia" {
  description = "Days after which to transition CloudTrail objects to STANDARD_IA (optional)"
  type        = number
  default     = null
}

variable "lifecycle_days_glacier" {
  description = "Days after which to transition CloudTrail objects to GLACIER (optional)"
  type        = number
  default     = null
}

variable "lifecycle_expire_days" {
  description = "Days after which to expire CloudTrail objects (optional)"
  type        = number
  default     = null
}
