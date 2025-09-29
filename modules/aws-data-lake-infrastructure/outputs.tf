output "storage_bucket_id" {
  description = "The ID (name) of the main storage bucket"
  value       = aws_s3_bucket.storage.id
}

output "storage_bucket_arn" {
  description = "The ARN of the main storage bucket"
  value       = aws_s3_bucket.storage.arn
}

output "storage_bucket_domain_name" {
  description = "The bucket domain name for the main storage bucket"
  value       = aws_s3_bucket.storage.bucket_domain_name
}

output "storage_bucket_regional_domain_name" {
  description = "The bucket regional domain name for the main storage bucket"
  value       = aws_s3_bucket.storage.bucket_regional_domain_name
}

output "temp_bucket_id" {
  description = "The ID (name) of the temporary bucket (if created)"
  value       = var.create_temp_bucket ? aws_s3_bucket.temp[0].id : null
}

output "temp_bucket_arn" {
  description = "The ARN of the temporary bucket (if created)"
  value       = var.create_temp_bucket ? aws_s3_bucket.temp[0].arn : null
}

# Data Lake Layer Paths
output "data_lake_paths" {
  description = "S3 paths for each data lake layer"
  value = {
    raw_zone = "s3://${aws_s3_bucket.storage.id}/${var.data_lake_layers.raw_zone}/"
    bronze   = "s3://${aws_s3_bucket.storage.id}/${var.data_lake_layers.bronze}/"
    silver   = "s3://${aws_s3_bucket.storage.id}/${var.data_lake_layers.silver}/"
    gold     = "s3://${aws_s3_bucket.storage.id}/${var.data_lake_layers.gold}/"
    export   = "s3://${aws_s3_bucket.storage.id}/${var.data_lake_layers.export}/"
  }
}

# Apache Iceberg Paths
output "iceberg_paths" {
  description = "S3 paths for Apache Iceberg components"
  value = {
    warehouse  = "s3://${aws_s3_bucket.storage.id}/${var.iceberg_warehouse_path}/"
    artifacts  = "s3://${aws_s3_bucket.storage.id}/${var.iceberg_artifacts_path}/"
    migrations = "s3://${aws_s3_bucket.storage.id}/${var.iceberg_migrations_path}/"
  }
}

# Spark Paths
output "spark_paths" {
  description = "S3 paths for Spark components"
  value = {
    event_logs = "s3://${aws_s3_bucket.storage.id}/${var.spark_event_logs_path}/"
  }
}

# Complete bucket configuration for external reference
output "bucket_configuration" {
  description = "Complete configuration details for the data lake buckets"
  value = {
    storage = {
      id                      = aws_s3_bucket.storage.id
      arn                     = aws_s3_bucket.storage.arn
      domain_name             = aws_s3_bucket.storage.bucket_domain_name
      regional_domain_name    = aws_s3_bucket.storage.bucket_regional_domain_name
      versioning_enabled      = var.enable_versioning
      lifecycle_rules_enabled = var.enable_lifecycle_rules
      kms_encryption_enabled  = var.kms_key_arn != null
    }
    temp = var.create_temp_bucket ? {
      id                   = aws_s3_bucket.temp[0].id
      arn                  = aws_s3_bucket.temp[0].arn
      domain_name          = aws_s3_bucket.temp[0].bucket_domain_name
      regional_domain_name = aws_s3_bucket.temp[0].bucket_regional_domain_name
      auto_cleanup_enabled = true
      retention_days       = 7
    } : null
  }
}
