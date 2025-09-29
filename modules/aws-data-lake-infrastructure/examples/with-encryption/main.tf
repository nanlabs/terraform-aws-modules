# Example with custom KMS encryption

# First create KMS key for encryption
resource "aws_kms_key" "data_lake" {
  description             = "KMS key for data lake encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "dwh-dev-example-s3-key"
    Environment = "development"
    Project     = "data-warehouse"
    Purpose     = "example"
  }
}

resource "aws_kms_alias" "data_lake" {
  name          = "alias/dwh-dev-example-s3"
  target_key_id = aws_kms_key.data_lake.key_id
}

# Data lake infrastructure with custom encryption
module "data_lake_infrastructure" {
  source = "../../"

  name = "dwh-dev-example"
  tags = {
    Environment = "development"
    Project     = "data-warehouse"
    Purpose     = "example"
  }

  # Use custom KMS key for encryption
  kms_key_arn = aws_kms_key.data_lake.arn

  # Custom medallion architecture with additional layers
  data_lake_layers = {
    raw     = "raw"
    bronze  = "bronze"
    silver  = "silver"
    gold    = "gold"
    export  = "export"
    archive = "archive"
  }

  # Apache Iceberg configuration
  iceberg_warehouse_path  = "iceberg-warehouse"
  iceberg_artifacts_path  = "iceberg-artifacts"
  iceberg_migrations_path = "iceberg-migrations"
  spark_event_logs_path   = "spark-event-logs"

  # Enhanced settings
  enable_versioning         = true
  enable_lifecycle_rules    = true
  create_temp_bucket        = true
  export_retention_days     = 90
  spark_logs_retention_days = 180
}

# Outputs
output "data_lake_bucket_id" {
  description = "The name of the data lake bucket"
  value       = module.data_lake_infrastructure.data_lake_bucket_id
}

output "data_lake_bucket_arn" {
  description = "The ARN of the data lake bucket"
  value       = module.data_lake_infrastructure.data_lake_bucket_arn
}

output "temp_bucket_id" {
  description = "The name of the temporary bucket"
  value       = module.data_lake_infrastructure.temp_bucket_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = aws_kms_key.data_lake.arn
}
