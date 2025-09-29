# AWS Glue Code Registry Module
# This module creates AWS Glue Code Registry resources for managing code libraries,
# JAR files, and dependencies used by Glue jobs in a centralized manner

# Get current AWS account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local values for resource naming and configuration
locals {
  resource_prefix = var.name
}

# S3 bucket for storing code artifacts (JARs, Python wheels, etc.)
module "code_artifacts_bucket" {
  count = var.create_s3_bucket ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  bucket = var.s3_bucket_name != null ? var.s3_bucket_name : "${local.resource_prefix}-glue-code-artifacts"

  # Enable versioning for code artifact management
  versioning = {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.s3_kms_key_id
        sse_algorithm     = var.s3_kms_key_id != null ? "aws:kms" : "AES256"
      }
      bucket_key_enabled = var.s3_kms_key_id != null ? true : false
    }
  }

  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Lifecycle configuration for cost optimization
  lifecycle_rule = var.s3_lifecycle_rules

  # Force destroy setting
  force_destroy = var.force_destroy

  tags = var.tags
}

# S3 bucket policy to allow cross-account access from workload accounts
resource "aws_s3_bucket_policy" "code_artifacts_cross_account" {
  count = var.create_s3_bucket && length(var.workload_account_ids) > 0 ? 1 : 0

  bucket = module.code_artifacts_bucket[0].s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowWorkloadAccountsAccess"
        Effect = "Allow"
        Principal = {
          AWS = [for account_id in var.workload_account_ids : "arn:aws:iam::${account_id}:root"]
        }
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          module.code_artifacts_bucket[0].s3_bucket_arn,
          "${module.code_artifacts_bucket[0].s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

# CloudWatch Log Groups for code registry monitoring
resource "aws_cloudwatch_log_group" "code_registry" {
  for_each = var.enable_cloudwatch_logging ? { "code-registry" = true } : {}

  name              = "/aws/glue/code-registry/${local.resource_prefix}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.cloudwatch_kms_key_id

  tags = var.tags
}

# IAM role for Glue Code Registry access
resource "aws_iam_role" "code_registry_access" {
  count = var.create_iam_role ? 1 : 0

  name        = "${local.resource_prefix}-glue-code-registry-access"
  description = "IAM role for accessing Glue Code Registry and code artifacts"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "glue.amazonaws.com"
          ]
        }
      }
    ]
  })

  max_session_duration = var.max_session_duration

  tags = var.tags
}

# IAM policy for S3 access to code artifacts bucket
resource "aws_iam_role_policy" "s3_code_artifacts_access" {
  count = var.create_iam_role ? 1 : 0

  name = "${local.resource_prefix}-s3-code-artifacts-access"
  role = aws_iam_role.code_registry_access[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ]
        Resource = [
          var.create_s3_bucket ? module.code_artifacts_bucket[0].s3_bucket_arn : "arn:aws:s3:::${var.existing_s3_bucket_name}",
          var.create_s3_bucket ? "${module.code_artifacts_bucket[0].s3_bucket_arn}/*" : "arn:aws:s3:::${var.existing_s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# IAM policy for additional S3 bucket access (for external libraries)
resource "aws_iam_role_policy" "additional_s3_access" {
  count = var.create_iam_role && length(var.additional_s3_bucket_arns) > 0 ? 1 : 0

  name = "${local.resource_prefix}-additional-s3-access"
  role = aws_iam_role.code_registry_access[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:ListBucketVersions"
        ]
        Resource = flatten([
          var.additional_s3_bucket_arns,
          [for arn in var.additional_s3_bucket_arns : "${arn}/*"]
        ])
      }
    ]
  })
}

# CloudWatch Logs policy (if CloudWatch logging is enabled)
resource "aws_iam_role_policy" "cloudwatch_logs" {
  count = var.create_iam_role && var.enable_cloudwatch_logging ? 1 : 0

  name = "${local.resource_prefix}-code-registry-cloudwatch"
  role = aws_iam_role.code_registry_access[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          for log_group in aws_cloudwatch_log_group.code_registry : "${log_group.arn}:*"
        ]
      }
    ]
  })
}
