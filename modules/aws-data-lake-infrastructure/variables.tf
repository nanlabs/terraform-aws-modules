variable "name" {
  description = "The name prefix for resources created by this module. Should be in the format: namespace-short_domain-account_name (e.g., dwh-wl-workloads-data-lake-develop)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for S3 bucket encryption. If not provided, AES256 encryption will be used"
  type        = string
  default     = null
}

variable "enable_versioning" {
  description = "Whether to enable versioning on the S3 storage bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Whether to enable lifecycle rules for cost optimization"
  type        = bool
  default     = true
}

variable "create_temp_bucket" {
  description = "Whether to create a separate temporary bucket for working data"
  type        = bool
  default     = false
}

# Data Lake Layer Configuration
variable "data_lake_layers" {
  description = "Configuration for data lake layers (medallion architecture)"
  type = object({
    raw_zone = string
    bronze   = string
    silver   = string
    gold     = string
    export   = string
  })
  default = {
    raw_zone = "raw-zone"
    bronze   = "iceberg-warehouse/bronze"
    silver   = "iceberg-warehouse/silver"
    gold     = "iceberg-warehouse/gold"
    export   = "export"
  }
}

# Apache Iceberg Configuration
variable "iceberg_warehouse_path" {
  description = "S3 path for Iceberg warehouse metadata (contains bronze, silver, gold)"
  type        = string
  default     = "iceberg-warehouse"
}

variable "iceberg_artifacts_path" {
  description = "S3 path for Iceberg job dependencies (libs, scripts)"
  type        = string
  default     = "iceberg-artifacts"
}

variable "iceberg_migrations_path" {
  description = "S3 path for Iceberg schema changes and migration scripts"
  type        = string
  default     = "iceberg-migrations"
}

# Spark Configuration
variable "spark_event_logs_path" {
  description = "S3 path for Spark event logs"
  type        = string
  default     = "spark-event-logs"
}

# Retention Configuration
variable "export_retention_days" {
  description = "Number of days to retain files in the export layer before deletion"
  type        = number
  default     = 30
}

variable "spark_logs_retention_days" {
  description = "Number of days to retain Spark event logs before deletion"
  type        = number
  default     = 90
}

variable "quicksight_role_arn" {
  description = "Optional QuickSight service or author role ARN granted read/write (as needed) to temp/storage buckets for Athena validation"
  type        = string
  default     = null
}
