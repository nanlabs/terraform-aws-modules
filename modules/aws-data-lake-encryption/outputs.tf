output "s3_kms_key_id" {
  description = "The ID of the S3 KMS key"
  value       = aws_kms_key.s3.key_id
}

output "s3_kms_key_arn" {
  description = "The ARN of the S3 KMS key"
  value       = aws_kms_key.s3.arn
}

output "s3_kms_key_alias" {
  description = "The alias of the S3 KMS key"
  value       = aws_kms_alias.s3.name
}

output "glue_kms_key_id" {
  description = "The ID of the Glue KMS key"
  value       = aws_kms_key.glue.key_id
}

output "glue_kms_key_arn" {
  description = "The ARN of the Glue KMS key"
  value       = aws_kms_key.glue.arn
}

output "glue_kms_key_alias" {
  description = "The alias of the Glue KMS key"
  value       = aws_kms_alias.glue.name
}

output "permission_boundary_arn" {
  description = "The ARN of the IAM permission boundary policy (if created)"
  value       = var.create_permission_boundary ? aws_iam_policy.data_lake_boundary[0].arn : null
}

output "permission_boundary_name" {
  description = "The name of the IAM permission boundary policy (if created)"
  value       = var.create_permission_boundary ? aws_iam_policy.data_lake_boundary[0].name : null
}

output "kms_logging_trail_arn" {
  description = "The ARN of the CloudTrail for KMS logging (if created)"
  value       = var.enable_kms_logging ? aws_cloudtrail.kms_logging[0].arn : null
}

# Comprehensive encryption configuration
output "encryption_configuration" {
  description = "Complete encryption configuration for the data lake"
  value = {
    s3_encryption = {
      kms_key_id           = aws_kms_key.s3.key_id
      kms_key_arn          = aws_kms_key.s3.arn
      kms_alias            = aws_kms_alias.s3.name
      key_rotation_enabled = var.enable_key_rotation
    }
    glue_encryption = {
      kms_key_id           = aws_kms_key.glue.key_id
      kms_key_arn          = aws_kms_key.glue.arn
      kms_alias            = aws_kms_alias.glue.name
      key_rotation_enabled = var.enable_key_rotation
    }
    security_controls = {
      permission_boundary_enabled = var.create_permission_boundary
      permission_boundary_arn     = var.create_permission_boundary ? aws_iam_policy.data_lake_boundary[0].arn : null
      kms_logging_enabled         = var.enable_kms_logging
      cloudtrail_arn              = var.enable_kms_logging ? aws_cloudtrail.kms_logging[0].arn : null
    }
  }
}

# Service-specific KMS key mapping
output "service_kms_keys" {
  description = "Mapping of services to their respective KMS keys"
  value = {
    s3 = {
      key_id = aws_kms_key.s3.key_id
      arn    = aws_kms_key.s3.arn
      alias  = aws_kms_alias.s3.name
    }
    glue = {
      key_id = aws_kms_key.glue.key_id
      arn    = aws_kms_key.glue.arn
      alias  = aws_kms_alias.glue.name
    }
  }
}
