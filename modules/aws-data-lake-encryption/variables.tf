variable "name" {
  description = "The name prefix for resources created by this module. Should be in the format: namespace-short_domain-account_name (e.g., dwh-wl-workloads-data-lake-develop)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}

# KMS Configuration
variable "kms_deletion_window" {
  description = "The waiting period, specified in number of days, after which the KMS key is deleted"
  type        = number
  default     = 7
}

variable "enable_key_rotation" {
  description = "Whether to enable automatic rotation of the KMS keys"
  type        = bool
  default     = true
}

# IAM Permission Boundary
variable "create_permission_boundary" {
  description = "Whether to create an IAM permission boundary for data lake jobs"
  type        = bool
  default     = true
}

# CloudTrail Logging
variable "enable_kms_logging" {
  description = "Whether to enable CloudTrail logging for KMS key usage"
  type        = bool
  default     = true
}

variable "cloudtrail_bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs (required if enable_kms_logging is true)"
  type        = string
  default     = null
}

# Service Integration
variable "allowed_services" {
  description = "List of AWS services that should have access to the KMS keys"
  type        = list(string)
  default     = ["s3.amazonaws.com", "glue.amazonaws.com"]
}

variable "additional_kms_policy_statements" {
  description = "Additional policy statements to add to the KMS key policies"
  type        = list(any)
  default     = []
}

# Optional QuickSight service role ARN to allow accessing S3 KMS key for Athena result encryption
variable "quicksight_role_arn" {
  description = "(Optional) QuickSight IAM role ARN to permit kms:Decrypt/GenerateDataKey via S3 for Athena result access"
  type        = string
  default     = null
}
