# Secure Multi-Environment Data Platform
# This example demonstrates a comprehensive, secure, multi-environment data platform

locals {
  # Common configuration
  base_name = "${var.project_name}-${var.organization}"

  # Environment configurations
  environments = {
    for env_name, env_config in var.environments : env_name => merge(
      env_config,
      {
        name = "${local.base_name}-${env_name}"
        full_name = "${var.project_name}-${var.organization}-${env_name}"
      }
    )
  }

  # Common tags for all resources
  common_tags = merge(var.tags, {
    Project      = var.project_name
    Organization = var.organization
    ManagedBy    = "Terraform"
    Platform     = "SecureDataPlatform"
  })

  # Security configuration
  kms_key_rotation_enabled = true
  enable_cross_region_backup = var.enable_cross_region_backup

  # Generate unique suffix for S3 buckets
  bucket_suffix = random_id.bucket_suffix.hex
}

# Generate random suffix for globally unique S3 bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# Shared Services VPC for monitoring, security, and logging
module "shared_services_vpc" {
  source = "../../modules/aws-vpc"

  name = "${local.base_name}-shared"
  tags = merge(local.common_tags, {
    Environment = "shared"
    Purpose     = "SharedServices"
  })

  # Network configuration
  cidr = var.shared_services_vpc_cidr
  azs  = var.availability_zones

  # Only private subnets for shared services
  private_subnets = var.shared_services_private_subnets
  public_subnets  = var.shared_services_public_subnets

  # Enable NAT Gateway for outbound connectivity
  enable_nat_gateway = true
  single_nat_gateway = var.shared_services_single_nat_gateway

  # VPC endpoints removed (example simplified for current module interface)

  # Flow logs for security monitoring
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Environment-specific infrastructure
# Development Environment
module "dev_environment" {
  source = "../../modules/aws-vpc"

  name = "${local.base_name}-dev"
  tags = merge(local.common_tags, { Environment = "dev" })

  cidr = local.environments.dev.vpc_cidr
  azs  = var.availability_zones

  private_subnets  = local.environments.dev.private_subnets
  public_subnets   = local.environments.dev.public_subnets
  database_subnets = local.environments.dev.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = local.environments.dev.single_nat_gateway

  # VPC endpoints removed (simplified example)

  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Staging Environment
module "staging_environment" {
  source = "../../modules/aws-vpc"

  name = "${local.base_name}-staging"
  tags = merge(local.common_tags, { Environment = "staging" })

  cidr = local.environments.staging.vpc_cidr
  azs  = var.availability_zones

  private_subnets  = local.environments.staging.private_subnets
  public_subnets   = local.environments.staging.public_subnets
  database_subnets = local.environments.staging.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = local.environments.staging.single_nat_gateway

  # VPC endpoints removed (simplified example)

  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Production Environment
module "prod_environment" {
  source = "../../modules/aws-vpc"

  name = "${local.base_name}-prod"
  tags = merge(local.common_tags, { Environment = "prod" })

  cidr = local.environments.prod.vpc_cidr
  azs  = var.availability_zones

  private_subnets  = local.environments.prod.private_subnets
  public_subnets   = local.environments.prod.public_subnets
  database_subnets = local.environments.prod.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = local.environments.prod.single_nat_gateway

  # VPC endpoints removed (simplified example)

  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Shared KMS keys for cross-environment encryption
resource "aws_kms_key" "shared_key" {
  description             = "Shared encryption key for ${var.project_name}"
  deletion_window_in_days = var.kms_deletion_window_days
  enable_key_rotation     = local.kms_key_rotation_enabled

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name        = "${local.base_name}-shared-key"
    Environment = "shared"
    Purpose     = "SharedEncryption"
  })
}

resource "aws_kms_alias" "shared_key_alias" {
  name          = "alias/${local.base_name}-shared"
  target_key_id = aws_kms_key.shared_key.key_id
}

# Centralized CloudTrail for all environments
resource "aws_cloudtrail" "main" {
  name           = "${local.base_name}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.bucket

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  # Advanced event selectors for data events
  advanced_event_selector {
    name = "Log all S3 data events"
    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }
    field_selector {
      field  = "resources.type"
      equals = ["AWS::S3::Object"]
    }
  }

  advanced_event_selector {
    name = "Log all Lambda data events"
    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }
    field_selector {
      field  = "resources.type"
      equals = ["AWS::Lambda::Function"]
    }
  }

  # Encrypt CloudTrail logs
  kms_key_id = aws_kms_key.shared_key.arn

  tags = merge(local.common_tags, {
    Name        = "${local.base_name}-cloudtrail"
    Environment = "shared"
    Purpose     = "AuditLogging"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail_logs_policy]
}

# S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "${local.base_name}-cloudtrail-logs-${local.bucket_suffix}"
  force_destroy = false

  tags = merge(local.common_tags, {
    Name        = "${local.base_name}-cloudtrail-logs"
    Environment = "shared"
    Purpose     = "AuditLogs"
  })
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs_encryption" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.shared_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_logs_pab" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    id     = "cloudtrail_logs_lifecycle"
    status = "Enabled"
    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = var.cloudtrail_log_retention_days
    }
  }
}

# CloudTrail S3 bucket policy
resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${local.base_name}-cloudtrail"
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
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${local.base_name}-cloudtrail"
          }
        }
      }
    ]
  })
}

# Security Hub for centralized security monitoring
resource "aws_securityhub_account" "main" {
  enable_default_standards = true
}

# Config for compliance monitoring
resource "aws_config_configuration_recorder" "main" {
  name     = "${local.base_name}-config-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [aws_config_delivery_channel.main]
}

resource "aws_config_delivery_channel" "main" {
  name           = "${local.base_name}-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_logs.bucket

  s3_key_prefix                = "config"
  snapshot_delivery_properties {
  delivery_frequency = "TwentyFour_Hours"
  }
}

# S3 bucket for Config logs
resource "aws_s3_bucket" "config_logs" {
  bucket        = "${local.base_name}-config-logs-${local.bucket_suffix}"
  force_destroy = false

  tags = merge(local.common_tags, {
    Name        = "${local.base_name}-config-logs"
    Environment = "shared"
    Purpose     = "ComplianceLogs"
  })
}

resource "aws_s3_bucket_versioning" "config_logs_versioning" {
  bucket = aws_s3_bucket.config_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_logs_encryption" {
  bucket = aws_s3_bucket.config_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.shared_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config_logs_pab" {
  bucket = aws_s3_bucket.config_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM role for Config
resource "aws_iam_role" "config_role" {
  name = "${local.base_name}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "config_role_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/ConfigRole"
}

resource "aws_iam_role_policy" "config_s3_policy" {
  name = "${local.base_name}-config-s3-policy"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.config_logs.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.config_logs.arn}/*"
      }
    ]
  })
}

# CloudWatch Log Groups for centralized logging
resource "aws_cloudwatch_log_group" "platform_logs" {
  name              = "/aws/platform/${local.base_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.shared_key.arn

  tags = merge(local.common_tags, {
    Name        = "${local.base_name}-platform-logs"
    Environment = "shared"
    Purpose     = "PlatformLogs"
  })
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
