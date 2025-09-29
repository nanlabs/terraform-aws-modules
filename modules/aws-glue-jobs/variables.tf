#------------------------------------------------------------------------------
# Required Variables
#------------------------------------------------------------------------------

variable "name" {
  description = "Name to be used as prefix for all resources created by this module"
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "Name cannot be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "glue_jobs" {
  description = "Map of Glue jobs to create"
  type = map(object({
    description               = string
    glue_version              = optional(string, "5.0")
    worker_type               = optional(string, "G.1X")
    number_of_workers         = optional(number, 2)
    max_capacity              = optional(number, null)
    max_retries               = optional(number, 0)
    timeout                   = optional(number, 2880)
    security_configuration    = optional(string, null)
    connections               = optional(list(string), [])
    max_concurrent_runs       = optional(number, null)
    notify_delay_after        = optional(number, null)
    job_bookmark_option       = optional(string, "job-bookmark-enable")
    non_overridable_arguments = optional(map(string), {})
    default_arguments         = optional(map(string), {})

    command = object({
      name            = optional(string, "glueetl")
      script_location = string
      python_version  = optional(string, "3")
    })
  }))
  default = {}
}

#------------------------------------------------------------------------------
# S3 Configuration Variables
#------------------------------------------------------------------------------

variable "create_s3_bucket" {
  description = "Whether to create a new S3 bucket for Glue scripts"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Glue scripts. If not provided, will be auto-generated"
  type        = string
  default     = null
}

variable "existing_s3_bucket_name" {
  description = "Name of existing S3 bucket to use for Glue scripts (when create_s3_bucket is false)"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to allow destruction of S3 bucket with objects (use with caution in production)"
  type        = bool
  default     = false
}

variable "s3_kms_key_id" {
  description = "KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used"
  type        = string
  default     = null
}

variable "data_kms_key_arn" {
  description = "KMS key ARN for data encryption/decryption in S3 data buckets. If not provided, no KMS permissions will be granted"
  type        = string
  default     = null
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

#------------------------------------------------------------------------------
# IAM Configuration Variables
#------------------------------------------------------------------------------

variable "max_session_duration" {
  description = "Maximum session duration for the Glue execution role (in seconds)"
  type        = number
  default     = 3600
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 and 43200 seconds."
  }
}

variable "data_bucket_arns" {
  description = "List of S3 bucket ARNs that Glue jobs need access to for data processing"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# CloudWatch Configuration Variables
#------------------------------------------------------------------------------

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs for Glue jobs"
  type        = number
  default     = 14
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch Logs retention period."
  }
}

variable "cloudwatch_kms_key_id" {
  description = "KMS key ID for CloudWatch Logs encryption"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# VPC Configuration Variables
#------------------------------------------------------------------------------

variable "vpc_id" {
  description = "VPC ID where Glue jobs will run. If not provided, jobs will run in AWS-managed VPC"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs where Glue jobs will run. Required when vpc_id is provided"
  type        = list(string)
  default     = []

  validation {
    condition = length(var.subnet_ids) == 0 || (
      var.vpc_id != null && length(var.subnet_ids) > 0
    )
    error_message = "subnet_ids must be provided when vpc_id is specified."
  }
}

variable "security_group_ids" {
  description = "List of security group IDs for Glue jobs. Required when vpc_id is provided"
  type        = list(string)
  default     = []

  validation {
    condition = length(var.security_group_ids) == 0 || (
      var.vpc_id != null && length(var.security_group_ids) > 0
    )
    error_message = "security_group_ids must be provided when vpc_id is specified."
  }
}
