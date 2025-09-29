output "resource_prefix" {
  description = "Resource prefix used for naming"
  value       = local.resource_prefix
}

# S3 Bucket Outputs
output "code_artifacts_bucket_id" {
  description = "ID of the S3 bucket used for code artifacts"
  value       = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_id : var.existing_s3_bucket_name
}

output "code_artifacts_bucket_name" {
  description = "Name of the S3 bucket used for code artifacts"
  value       = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_id : var.existing_s3_bucket_name
}

output "code_artifacts_bucket_arn" {
  description = "ARN of the S3 bucket used for code artifacts"
  value       = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_arn : "arn:aws:s3:::${var.existing_s3_bucket_name}"
}

output "code_artifacts_bucket_domain_name" {
  description = "Domain name of the S3 bucket used for code artifacts"
  value       = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_bucket_domain_name : "${var.existing_s3_bucket_name}.s3.amazonaws.com"
}

output "code_artifacts_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket used for code artifacts"
  value       = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_bucket_regional_domain_name : "${var.existing_s3_bucket_name}.s3.${data.aws_region.current.id}.amazonaws.com"
}

# IAM Role Outputs
output "code_registry_role_arn" {
  description = "ARN of the code registry access IAM role"
  value       = var.create_iam_role ? aws_iam_role.code_registry_access[0].arn : null
}

output "code_registry_role_name" {
  description = "Name of the code registry access IAM role"
  value       = var.create_iam_role ? aws_iam_role.code_registry_access[0].name : null
}

output "code_registry_role_id" {
  description = "ID of the code registry access IAM role"
  value       = var.create_iam_role ? aws_iam_role.code_registry_access[0].id : null
}

# CloudWatch Logs Outputs
output "log_group_names" {
  description = "Names of the CloudWatch log groups for code registry"
  value       = var.enable_cloudwatch_logging ? [for lg in aws_cloudwatch_log_group.code_registry : lg.name] : []
}

output "log_group_arns" {
  description = "ARNs of the CloudWatch log groups for code registry"
  value       = var.enable_cloudwatch_logging ? [for lg in aws_cloudwatch_log_group.code_registry : lg.arn] : []
}

# Summary Outputs
output "code_registry_summary" {
  description = "Summary of code registry configuration"
  value = {
    bucket_name              = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_id : var.existing_s3_bucket_name
    bucket_arn               = var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_arn : "arn:aws:s3:::${var.existing_s3_bucket_name}"
    iam_role_arn             = var.create_iam_role ? aws_iam_role.code_registry_access[0].arn : null
    cloudwatch_enabled       = var.enable_cloudwatch_logging
    s3_notifications_enabled = var.enable_s3_notifications
  }
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = var.tags
}
