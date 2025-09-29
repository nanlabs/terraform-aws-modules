variable "name" {
  description = "Name to be used as prefix for all resources created by this module"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

# S3 Configuration
variable "create_s3_bucket" {
  description = "Whether to create a new S3 bucket for code artifacts"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for code artifacts. If not provided, will be auto-generated"
  type        = string
  default     = null
}

variable "existing_s3_bucket_name" {
  description = "Name of existing S3 bucket to use for code artifacts (when create_s3_bucket is false)"
  type        = string
  default     = null
}

variable "s3_kms_key_id" {
  description = "KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to allow destruction of S3 bucket with objects (use with caution in production)"
  type        = bool
  default     = false
}

variable "s3_lifecycle_rules" {
  description = "S3 bucket lifecycle rules for cost optimization"
  type        = any
  default = [
    {
      id     = "delete_old_versions"
      status = "Enabled"

      noncurrent_version_expiration = {
        days = 90
      }

      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    }
  ]
}

variable "additional_s3_bucket_arns" {
  description = "List of additional S3 bucket ARNs that the code registry IAM role needs access to"
  type        = list(string)
  default     = []
}

# S3 Notifications
variable "enable_s3_notifications" {
  description = "Whether to enable S3 bucket notifications for code artifact uploads"
  type        = bool
  default     = false
}

variable "s3_notification_configurations" {
  description = "List of S3 notification configurations for code artifact uploads"
  type = list(object({
    id            = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = [
    {
      id            = "code-upload-notification"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".jar"
    },
    {
      id            = "wheel-upload-notification"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".whl"
    }
  ]
}

# IAM Configuration
variable "create_iam_role" {
  description = "Whether to create IAM role for code registry access"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum session duration for the code registry access role (in seconds)"
  type        = number
  default     = 3600
}

# CloudWatch Configuration
variable "enable_cloudwatch_logging" {
  description = "Whether to enable CloudWatch logging for code registry"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "cloudwatch_kms_key_id" {
  description = "KMS key ID for CloudWatch Logs encryption"
  type        = string
  default     = null
}

# Cross-Account Access Configuration
variable "workload_account_ids" {
  description = "List of AWS account IDs that should have cross-account access to the code artifacts bucket"
  type        = list(string)
  default     = []
}
