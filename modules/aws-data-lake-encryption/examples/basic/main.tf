# Basic example of aws-data-lake-encryption module

module "data_lake_encryption" {
  source = "../../"

  name = "dwh-dev-example"
  tags = {
    Environment = "development"
    Project     = "data-warehouse"
    Purpose     = "example"
  }

  # Basic KMS configuration
  kms_deletion_window = 7 # Short deletion window for development
  enable_key_rotation = true

  # Basic security controls
  create_permission_boundary = true
  enable_kms_logging         = false # Disable CloudTrail for basic example
  cloudtrail_bucket_name     = null

  # Allow basic AWS services
  allowed_services = [
    "s3.amazonaws.com",
    "glue.amazonaws.com"
  ]
}

# Outputs
output "s3_kms_key_arn" {
  description = "ARN of the S3 KMS key"
  value       = module.data_lake_encryption.s3_kms_key_arn
}

output "glue_kms_key_arn" {
  description = "ARN of the Glue KMS key"
  value       = module.data_lake_encryption.glue_kms_key_arn
}

output "permission_boundary_arn" {
  description = "ARN of the IAM permission boundary"
  value       = module.data_lake_encryption.permission_boundary_arn
}
