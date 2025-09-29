# Get current AWS account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# S3 bucket for CloudTrail logs (only create if requested)
resource "aws_s3_bucket" "cloudtrail" {
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = merge({
    Name = var.s3_bucket_name
  }, var.tags)
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Get bucket name from created bucket or provided ARN
locals {
  bucket_arn  = var.create_s3_bucket ? aws_s3_bucket.cloudtrail[0].arn : var.s3_bucket_arn
  bucket_name = var.create_s3_bucket ? aws_s3_bucket.cloudtrail[0].id : var.s3_bucket_name
}

# Default bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  count  = var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.bucket_encryption_mode == "SSE_KMS" ? "aws:kms" : "AES256"
      kms_master_key_id = var.bucket_encryption_mode == "SSE_KMS" ? var.bucket_kms_key_arn : null
    }
    bucket_key_enabled = var.bucket_encryption_mode == "SSE_KMS"
  }
}

# Lifecycle rules (optional)
locals {
  lifecycle_transitions = concat(
    var.lifecycle_days_ia != null ? [{ days = var.lifecycle_days_ia, storage_class = "STANDARD_IA" }] : [],
    var.lifecycle_days_glacier != null ? [{ days = var.lifecycle_days_glacier, storage_class = "GLACIER" }] : []
  )
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  count  = var.create_s3_bucket && (var.lifecycle_days_ia != null || var.lifecycle_days_glacier != null || var.lifecycle_expire_days != null) ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  rule {
    id     = "cloudtrail-lifecycle"
    status = "Enabled"

    filter {}

    dynamic "transition" {
      for_each = local.lifecycle_transitions
      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

    dynamic "expiration" {
      for_each = var.lifecycle_expire_days != null ? [1] : []
      content {
        days = var.lifecycle_expire_days
      }
    }
  }
}

# S3 bucket policy for CloudTrail - basic policy (no cross-account access)
resource "aws_s3_bucket_policy" "cloudtrail" {
  count  = var.create_s3_bucket && length(var.cross_account_source_arns) == 0 ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = local.bucket_arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/${var.name}"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/${var.name}"
          }
        }
      }
      ], var.enforce_tls ? [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [local.bucket_arn, "${local.bucket_arn}/*"]
        Condition = {
          Bool = { "aws:SecureTransport" = false }
        }
      }
    ] : [])
  })
}

# S3 bucket policy for CloudTrail - with cross-account access
resource "aws_s3_bucket_policy" "cloudtrail_cross_account" {
  count  = var.create_s3_bucket && length(var.cross_account_source_arns) > 0 ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = local.bucket_arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/${var.name}"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/${var.name}"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailAclCheckCrossAccount"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = local.bucket_arn
        Condition = {
          StringLike = {
            "AWS:SourceArn" = var.cross_account_source_arns
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWriteCrossAccount"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          },
          StringLike = {
            "AWS:SourceArn" = var.cross_account_source_arns
          }
        }
      }
      ], var.enforce_tls ? [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [local.bucket_arn, "${local.bucket_arn}/*"]
        Condition = {
          Bool = { "aws:SecureTransport" = false }
        }
      }
    ] : [])
  })
}

# CloudWatch Logs group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.name}"
  retention_in_days = 90

  tags = var.tags
}

# IAM role for CloudTrail to write to CloudWatch Logs
resource "aws_iam_role" "cloudtrail_logs" {
  name = "${var.name}-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for CloudTrail to write to CloudWatch Logs
resource "aws_iam_role_policy" "cloudtrail_logs" {
  name = "${var.name}-logs-policy"
  role = aws_iam_role.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}

# CloudTrail
resource "aws_cloudtrail" "trail" {
  name           = var.name
  s3_bucket_name = local.bucket_name
  s3_key_prefix  = var.s3_key_prefix

  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_logging                = var.enable_logging

  # CloudWatch Logs integration
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs.arn

  # KMS encryption (optional)
  kms_key_id = var.kms_key_id

  # Log file validation
  enable_log_file_validation = var.enable_log_file_validation

  # Event selectors
  dynamic "event_selector" {
    for_each = var.event_selector
    content {
      read_write_type                  = event_selector.value.read_write_type
      include_management_events        = event_selector.value.include_management_events
      exclude_management_event_sources = event_selector.value.exclude_management_event_sources

      dynamic "data_resource" {
        for_each = event_selector.value.data_resource
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  # Insight selectors
  dynamic "insight_selector" {
    for_each = var.insight_selector
    content {
      insight_type = insight_selector.value.insight_type
    }
  }

  tags = merge({
    Name = var.name
  }, var.tags)

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_s3_bucket_policy.cloudtrail_cross_account
  ]
}
