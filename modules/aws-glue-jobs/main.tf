# AWS Glue Jobs Infrastructure Module
# This module creates AWS Glue Jobs with associated IAM roles and S3 bucket for scripts
# Following best practices: separate infrastructure from ETL code

# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


# Local values for consistent naming and configuration
locals {
  resource_prefix = var.name
  common_tags     = var.tags
}

# Discover the AZ of the first provided subnet to satisfy Glue Connection requirements
data "aws_subnet" "selected" {
  count = length(var.subnet_ids) > 0 ? 1 : 0
  id    = var.subnet_ids[0]
}

#------------------------------------------------------------------------------
# AWS Glue Connection for VPC (conditional)
#------------------------------------------------------------------------------

resource "aws_glue_connection" "vpc_connection" {
  name = "${local.resource_prefix}-vpc-connection"

  connection_type = "NETWORK"

  connection_properties = {
    JDBC_ENFORCE_SSL = "false"
  }

  physical_connection_requirements {
    # Specify AZ to satisfy AWS Glue API and avoid update errors
    availability_zone      = length(var.subnet_ids) > 0 ? data.aws_subnet.selected[0].availability_zone : null
    security_group_id_list = var.security_group_ids
    subnet_id              = var.subnet_ids[0] # Use first subnet for connection
  }

  tags = merge(var.tags, {
    Name = "${local.resource_prefix}-vpc-connection"
    Type = "VPC"
  })
}

#------------------------------------------------------------------------------
# S3 Bucket for Glue Scripts (using terraform-aws-modules)
#------------------------------------------------------------------------------

module "glue_scripts_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.2.0"

  count = var.create_s3_bucket ? 1 : 0

  bucket = var.s3_bucket_name != null ? var.s3_bucket_name : "${local.resource_prefix}-glue-scripts"

  # Force destroy for development environments
  force_destroy = var.force_destroy

  # Versioning for script version control
  versioning = {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = var.s3_kms_key_id != null ? "aws:kms" : "AES256"
        kms_master_key_id = var.s3_kms_key_id
      }
      bucket_key_enabled = var.s3_kms_key_id != null ? true : false
    }
  }

  # Lifecycle configuration for cost optimization
  lifecycle_rule = var.s3_lifecycle_rules

  # Public access blocking (security best practice)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Object ownership
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  tags = var.tags
}

#------------------------------------------------------------------------------
# IAM Role for Glue Jobs (using terraform-aws-modules)
#------------------------------------------------------------------------------

module "glue_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.59.0"

  create_role           = true
  trusted_role_services = ["glue.amazonaws.com"]

  role_name            = "${local.resource_prefix}-glue-execution"
  role_description     = "IAM role for AWS Glue Jobs execution"
  role_requires_mfa    = false
  max_session_duration = var.max_session_duration

  # Attach AWS managed policy for Glue service
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
  ]

  tags = var.tags
}

# Custom IAM policy for S3 access to scripts bucket
resource "aws_iam_role_policy" "glue_s3_access" {
  name = "${local.resource_prefix}-glue-s3-access"
  role = module.glue_execution_role.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${local.scripts_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          local.scripts_bucket_arn
        ]
      }
    ]
  })
}

# Additional custom policies for data access
resource "aws_iam_role_policy" "glue_data_access" {
  count = length(var.data_bucket_arns) > 0 ? 1 : 0

  name = "${local.resource_prefix}-glue-data-access"
  role = module.glue_execution_role.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = flatten([
          var.data_bucket_arns,
          [for arn in var.data_bucket_arns : "${arn}/*"]
        ])
      }
      ], var.data_kms_key_arn != null ? [{
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = [var.data_kms_key_arn]
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.${data.aws_region.current.id}.amazonaws.com"
          }
        }
    }] : [])
  })
}

# CloudWatch Logs permissions
resource "aws_iam_role_policy" "glue_cloudwatch_logs" {
  name = "${local.resource_prefix}-glue-cloudwatch-logs"
  role = module.glue_execution_role.iam_role_name

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
        Resource = "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/*"
      }
    ]
  })
}

#------------------------------------------------------------------------------
# CloudWatch Log Groups for Glue Jobs
#------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "glue_jobs" {
  for_each = var.glue_jobs

  name              = "/aws-glue/jobs/${local.resource_prefix}-${each.key}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.cloudwatch_kms_key_id

  tags = merge(var.tags, {
    JobName = each.key
  })
}

#------------------------------------------------------------------------------
# AWS Glue Jobs
#------------------------------------------------------------------------------

resource "aws_glue_job" "this" {
  for_each = var.glue_jobs

  name         = "${local.resource_prefix}-${each.key}"
  description  = each.value.description
  role_arn     = module.glue_execution_role.iam_role_arn
  glue_version = each.value.glue_version
  # For Python Shell jobs AWS Glue does not allow worker_type/number_of_workers.
  # Those jobs must specify max_capacity instead. For Spark (glueetl / gluestreaming)
  # we keep worker_type/number_of_workers and ignore max_capacity to avoid conflicts.
  worker_type               = each.value.command.name == "pythonshell" ? null : each.value.worker_type
  number_of_workers         = each.value.command.name == "pythonshell" ? null : each.value.number_of_workers
  max_capacity              = each.value.command.name == "pythonshell" ? coalesce(each.value.max_capacity, 1) : null
  max_retries               = each.value.max_retries
  timeout                   = each.value.timeout
  security_configuration    = each.value.security_configuration
  non_overridable_arguments = each.value.non_overridable_arguments

  command {
    name            = each.value.command.name
    script_location = each.value.command.script_location
    python_version  = each.value.command.python_version
  }

  # Default arguments with common Glue settings
  # Filter out empty, null, or "-" values to prevent argument parsing issues
  default_arguments = merge(
    {
      for k, v in merge(
        {
          "--enable-metrics"                   = ""
          "--enable-spark-ui"                  = ""
          "--enable-job-insights"              = ""
          "--enable-observability-metrics"     = ""
          "--enable-glue-datacatalog"          = ""
          "--job-language"                     = "python"
          "--TempDir"                          = "s3://${local.scripts_bucket_name}/temp/"
          "--enable-continuous-cloudwatch-log" = "true"
          "--job-bookmark-option"              = each.value.job_bookmark_option
        },
        each.value.default_arguments
      ) : k => v if v != null && v != "" && v != "-"
    }
  )

  # Execution property for concurrent runs
  dynamic "execution_property" {
    for_each = each.value.max_concurrent_runs != null ? [1] : []
    content {
      max_concurrent_runs = each.value.max_concurrent_runs
    }
  }

  # Notification property for job completion alerts
  dynamic "notification_property" {
    for_each = each.value.notify_delay_after != null ? [1] : []
    content {
      notify_delay_after = each.value.notify_delay_after
    }
  }

  # VPC configuration for running Glue jobs in custom VPC
  connections = [aws_glue_connection.vpc_connection.name]

  tags = merge(var.tags, {
    JobName     = each.key
    JobType     = each.value.command.name
    GlueVersion = each.value.glue_version
  })

  depends_on = [
    aws_cloudwatch_log_group.glue_jobs
  ]
}

#------------------------------------------------------------------------------
# Local values for outputs and internal references
#------------------------------------------------------------------------------

locals {
  scripts_bucket_name = var.create_s3_bucket ? module.glue_scripts_bucket[0].s3_bucket_id : var.existing_s3_bucket_name
  scripts_bucket_arn  = var.create_s3_bucket ? module.glue_scripts_bucket[0].s3_bucket_arn : "arn:aws:s3:::${var.existing_s3_bucket_name}"
}
