# Example with full security controls including CloudTrail logging

# Create S3 bucket for CloudTrail logs (in real scenario, this would be centralized)
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "dwh-dev-example-cloudtrail-logs"

  tags = {
    Name        = "dwh-dev-example-cloudtrail-logs"
    Environment = "development"
    Project     = "data-warehouse"
    Purpose     = "example"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Data lake encryption with full security controls
module "data_lake_encryption" {
  source = "../../"

  name = "dwh-dev-example"
  tags = {
    Environment = "development"
    Project     = "data-warehouse"
    Purpose     = "example"
  }

  # Production-like KMS configuration
  kms_deletion_window = 14
  enable_key_rotation = true

  # Full security controls
  create_permission_boundary = true
  enable_kms_logging         = true
  cloudtrail_bucket_name     = aws_s3_bucket.cloudtrail_logs.id

  # Extended list of allowed services
  allowed_services = [
    "s3.amazonaws.com",
    "glue.amazonaws.com",
    "athena.amazonaws.com",
    "lambda.amazonaws.com"
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

output "cloudtrail_trail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = module.data_lake_encryption.cloudtrail_trail_arn
}

output "cloudtrail_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail_logs.id
}
