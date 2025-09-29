# Data Processing Pipeline Infrastructure
# This example demonstrates a comprehensive data processing pipeline using AWS managed services

locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "DataProcessing"
  })

  # S3 bucket names (must be globally unique)
  bucket_suffix = random_id.bucket_suffix.hex

  # Glue job configurations
  glue_jobs = {
    raw_data_processor = {
      name        = "${local.name}-raw-data-processor"
      description = "Processes raw data files from S3 and validates schema"
      script_name = "raw_data_processor.py"
      max_capacity = var.glue_max_capacity
    }
    data_transformer = {
      name        = "${local.name}-data-transformer"
      description = "Applies business logic transformations to validated data"
      script_name = "data_transformer.py"
      max_capacity = var.glue_max_capacity
    }
    data_aggregator = {
      name        = "${local.name}-data-aggregator"
      description = "Creates aggregated reports and summary statistics"
      script_name = "data_aggregator.py"
      max_capacity = var.glue_max_capacity
    }
    schema_validator = {
      name        = "${local.name}-schema-validator"
      description = "Validates data schema and quality checks"
      script_name = "schema_validator.py"
      max_capacity = var.glue_max_capacity
    }
  }

  # Kafka topic configurations
  kafka_topics = {
    raw_events       = { partitions = 8, replication_factor = 2 }
    processed_events = { partitions = 4, replication_factor = 2 }
    failed_events    = { partitions = 2, replication_factor = 2 }
    monitoring_events = { partitions = 2, replication_factor = 2 }
  }
}

# Generate random suffix for globally unique S3 bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# VPC for data processing infrastructure
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "${local.name}-vpc"
  tags = local.common_tags

  # Network configuration
  cidr = var.vpc_cidr
  azs  = var.availability_zones

  # Subnets
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  # NAT Gateway for private subnet internet access
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  # VPC endpoints for AWS services
  # (Removed legacy enable_*_endpoint flags; underlying module does not expose endpoint toggles.)

  # Flow logs for monitoring
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# S3 buckets for data pipeline
module "data_lake_bucket" {
  source = "../../modules/aws-data-lake-infrastructure"

  name = "${local.name}-data-lake"
  tags = local.common_tags

  # Align custom layer naming with legacy example semantics
  data_lake_layers = {
    raw_zone = "raw"
    bronze   = "processed/bronze"    # processed intermediate
    silver   = "processed/silver"    # further refined
    gold     = "analytics"           # analytics-ready data
    export   = "export"              # export layer
  }

  # Enable optional temp bucket for Glue scratch / Spark events
  create_temp_bucket = true

  # Retention tuning (reuse existing variables where meaningful)
  export_retention_days      = var.s3_expiration_days
  spark_logs_retention_days  = var.log_retention_days

  # Security / governance
  enable_versioning       = true
  enable_lifecycle_rules  = true
}

# Glue Data Catalog and jobs
module "glue_catalog" {
  source = "../../modules/aws-glue-data-lake-catalog"

  # Required inputs
  database_prefix = replace(local.name, "-", "_")
  s3_bucket_uri   = "s3://${module.data_lake_bucket.storage_bucket_id}"
  tags            = local.common_tags

  # Layers we want managed (bronze/silver/gold). Raw is added via additional_databases.
  layers = ["bronze", "silver", "gold"]

  # Map layer -> relative path (aligning with data_lake_layers used earlier)
  data_lake_paths = {
    bronze = "processed/bronze"
    silver = "processed/silver"
    gold   = "analytics"
  }

  # Add raw layer explicitly so jobs referencing raw_zone have a database
  additional_databases = {
    raw_zone = {
      description = "Raw ingestion layer database"
      # location will default to s3_bucket_uri/raw_zone/
    }
  }
}

# Glue ETL jobs
module "glue_jobs" {
  source = "../../modules/aws-glue-jobs"

  name = "${local.name}-jobs"
  tags = local.common_tags

  # Provide Glue jobs as a map keyed by job identifier
  glue_jobs = {
    for job_key, job_config in local.glue_jobs : job_key => {
      description  = job_config.description
      glue_version = var.glue_version
      # Use max_capacity if specified; otherwise fallback to number_of_workers worker_type model
      max_capacity = job_config.max_capacity
      max_retries  = var.glue_max_retries
      timeout      = var.glue_timeout_minutes

      default_arguments = merge({
        "--TempDir"                 = "s3://${module.data_lake_bucket.storage_bucket_id}/temp/"
        "--enable-metrics"          = "true"
        "--enable-spark-ui"         = "true"
        "--spark-event-logs-path"   = "s3://${module.data_lake_bucket.storage_bucket_id}/spark-event-logs/"
        "--enable-job-insights"     = "true"
        "--job-bookmark-option"     = "job-bookmark-enable"
        "--enable-glue-datacatalog" = "true"
        "--raw_bucket"              = module.data_lake_bucket.storage_bucket_id
        "--processed_bucket"        = module.data_lake_bucket.storage_bucket_id
        "--failed_bucket"           = module.data_lake_bucket.storage_bucket_id
        "--bronze_database"         = module.glue_catalog.bronze_database_name
        "--silver_database"         = module.glue_catalog.silver_database_name
        "--gold_database"           = module.glue_catalog.gold_database_name
        "--raw_database"            = module.glue_catalog.raw_zone_database_name
      }, {})

      command = {
        script_location = "s3://${module.data_lake_bucket.storage_bucket_id}/scripts/${job_config.script_name}"
      }
    }
  }

  # Grant jobs access to storage bucket (and temp if created)
  data_bucket_arns = compact([
    module.data_lake_bucket.storage_bucket_arn,
    module.data_lake_bucket.temp_bucket_arn
  ])
}

# Glue workflow for orchestration
module "glue_workflow" {
  source = "../../modules/aws-glue-workflow"

  name = "${local.name}-workflow"
  tags = local.common_tags

  workflows = {
    data_processing = {
      description = "Data processing workflow for ${var.project_name}"
      triggers = [
        {
          name              = "${local.name}-schedule-trigger"
          type              = "SCHEDULED"
          start_on_creation = var.start_workflow_on_creation
          schedule          = var.glue_job_schedule
          actions = [
            { job_name = local.glue_jobs.raw_data_processor.name }
          ]
        },
        {
          name = "${local.name}-conditional-trigger"
          type = "CONDITIONAL"
          predicate = {
            conditions = [
              { job_name = local.glue_jobs.raw_data_processor.name, state = "SUCCEEDED" }
            ]
          }
          actions = [
            { job_name = local.glue_jobs.data_transformer.name }
          ]
        }
      ]
    }
  }
}

# MSK (Managed Streaming for Kafka) for real-time processing
module "msk_cluster" {
  count = var.enable_streaming ? 1 : 0

  source = "../../modules/aws-msk"

  name    = "${local.name}-kafka"
  region  = var.region
  tags    = local.common_tags
  vpc_id  = module.vpc.vpc_id

  private_subnets      = module.vpc.private_subnets
  kafka_version        = var.kafka_version
  broker_instance_type = var.kafka_instance_type
  broker_per_zone      = 1
  broker_volume_size   = var.kafka_ebs_volume_size

  # Auth & encryption defaults (reuse module defaults) – enable TLS only
  client_broker           = "TLS"
  encryption_in_cluster   = true
  enhanced_monitoring     = "DEFAULT"
  jmx_exporter_enabled    = true
  node_exporter_enabled   = true
  cloudwatch_logs_enabled = true
  cloudwatch_logs_log_group = "/aws/msk/${local.name}"

  properties = {
    "auto.create.topics.enable"  = "true"
    "default.replication.factor" = "2"
    "min.insync.replicas"        = "2"
    "num.partitions"            = "8"
    "log.retention.hours"       = "168"
    "compression.type"          = "gzip"
  }
}

# Bastion host for secure access and administration
module "bastion" {
  source = "../../modules/aws-bastion"

  name = "${local.name}-bastion"
  tags = local.common_tags

  # Network configuration (module expects lists)
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  # Security
  allowed_cidrs = var.bastion_allowed_cidr_blocks

  # Monitoring
  enable_detailed_monitoring = var.enable_detailed_monitoring
}

# IAM role for Lambda functions (if needed for event processing)
resource "aws_iam_role" "lambda_execution_role" {
  count = var.enable_lambda_processing ? 1 : 0

  name = "${local.name}-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# IAM policy for Lambda S3 access
resource "aws_iam_policy" "lambda_s3_policy" {
  count = var.enable_lambda_processing ? 1 : 0

  name        = "${local.name}-lambda-s3-policy"
  description = "IAM policy for Lambda S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.data_lake_bucket.storage_bucket_arn,
          "${module.data_lake_bucket.storage_bucket_arn}/*",
          module.data_lake_bucket.temp_bucket_arn != null ? module.data_lake_bucket.temp_bucket_arn : null,
          module.data_lake_bucket.temp_bucket_arn != null ? "${module.data_lake_bucket.temp_bucket_arn}/*" : null
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })

  tags = local.common_tags
}

# Attach policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  count = var.enable_lambda_processing ? 1 : 0

  role       = aws_iam_role.lambda_execution_role[0].name
  policy_arn = aws_iam_policy.lambda_s3_policy[0].arn
}

# CloudWatch Log Groups for monitoring
resource "aws_cloudwatch_log_group" "glue_logs" {
  name              = "/aws-glue/jobs/${local.name}"
  retention_in_days = var.log_retention_days

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  count = var.enable_lambda_processing ? 1 : 0

  name              = "/aws/lambda/${local.name}"
  retention_in_days = var.log_retention_days

  tags = local.common_tags
}
