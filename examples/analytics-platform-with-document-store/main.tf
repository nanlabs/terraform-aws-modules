# Analytics Platform with Document Store Infrastructure
# Combines data lake capabilities with DocumentDB for flexible analytics

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  name = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Platform    = "AnalyticsPlatform"
  })

  # S3 bucket names (must be globally unique)
  bucket_suffix = random_id.bucket_suffix.hex
}

# Generate random suffix for globally unique S3 bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Generate random password for DocumentDB
resource "random_password" "docdb_password" {
  length  = 16
  special = true
}

# KMS key for encryption
resource "aws_kms_key" "analytics" {
  description             = "KMS key for analytics platform encryption"
  deletion_window_in_days = 7

  tags = local.common_tags
}

resource "aws_kms_alias" "analytics" {
  name          = "alias/${local.name}-analytics"
  target_key_id = aws_kms_key.analytics.key_id
}

# VPC for the analytics platform
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

  # Internet Gateway
  create_igw = true

  # Flow logs for monitoring
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # SSM Parameters
  create_ssm_parameters = true
}

# Data lake infrastructure with S3 buckets
module "data_lake" {
  source = "../../modules/aws-data-lake-infrastructure"

  name = "${local.name}-data-lake"
  tags = local.common_tags

  # KMS encryption
  kms_key_arn = aws_kms_key.analytics.arn

  # S3 configuration
  enable_versioning      = true
  enable_lifecycle_rules = true
  create_temp_bucket     = true

  # Data lake layers (medallion architecture)
  data_lake_layers = {
    raw_zone = "raw-zone"
    bronze   = "iceberg-warehouse/bronze"
    silver   = "iceberg-warehouse/silver"
    gold     = "iceberg-warehouse/gold"
    export   = "export"
  }

  # Apache Iceberg configuration
  iceberg_warehouse_path  = "iceberg-warehouse"
  iceberg_artifacts_path  = "iceberg-artifacts"
  iceberg_migrations_path = "iceberg-migrations"

  # Spark configuration
  spark_event_logs_path = "spark-event-logs"

  # Retention policies
  export_retention_days     = 30
  spark_logs_retention_days = 90
}

# DocumentDB cluster for document analytics
module "docdb" {
  source = "../../modules/aws-docdb"

  name = "${local.name}-docdb"
  tags = local.common_tags

  # Required parameters
  vpc_id  = module.vpc.vpc_id
  db_name = "analytics"

  # Authentication
  master_username = "docdbadmin"
  master_password = random_password.docdb_password.result

  # Instance configuration
  instance_class = var.docdb_instance_class
  cluster_size   = var.docdb_cluster_size

  # Engine configuration
  engine         = "docdb"
  engine_version = var.docdb_engine_version
  cluster_family = "docdb5.0"

  # Security
  storage_encrypted = true
  kms_key_id        = aws_kms_key.analytics.arn
  tls_enabled       = true

  # Backup configuration
  retention_period        = "7"
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = "false"
  apply_immediately       = true

  # Monitoring
  enabled_cloudwatch_logs_exports = ["audit"]

  # SSM Parameters and Secrets
  create_ssm_parameters = true
  create_secret         = true
}

# MSK (Kafka) cluster for streaming data
module "msk" {
  source = "../../modules/aws-msk"

  name   = "${local.name}-msk"
  region = data.aws_region.current.id
  tags   = local.common_tags

  # Network configuration
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  # Cluster configuration
  kafka_version        = var.kafka_version
  broker_instance_type = var.kafka_broker_instance_type
  broker_per_zone      = var.kafka_broker_per_zone
  broker_volume_size   = var.kafka_broker_volume_size

  # Security configuration
  client_allow_unauthenticated = false
  client_sasl_iam_enabled      = true

  # Encryption
  client_broker                  = "TLS"
  encryption_in_cluster          = true
  encryption_at_rest_kms_key_arn = aws_kms_key.analytics.arn

  # Monitoring
  enhanced_monitoring     = "PER_TOPIC_PER_BROKER"
  jmx_exporter_enabled    = true
  node_exporter_enabled   = true
  cloudwatch_logs_enabled = true

  # Auto-scaling
  autoscaling_enabled              = true
  storage_autoscaling_target_value = var.kafka_storage_autoscaling_target
}

# Glue jobs for data processing
module "glue_jobs" {
  source = "../../modules/aws-glue-jobs"

  name = "${local.name}-glue"
  tags = local.common_tags

  # S3 bucket for Glue scripts
  create_s3_bucket = true
  force_destroy    = true
  s3_kms_key_id    = aws_kms_key.analytics.id

  # KMS key for data access
  data_kms_key_arn = aws_kms_key.analytics.arn

  # Data bucket access
  data_bucket_arns = [
    module.data_lake.storage_bucket_arn,
    "${module.data_lake.storage_bucket_arn}/*"
  ]

  # VPC configuration for secure processing
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.glue_jobs.id]

  # CloudWatch logs configuration
  log_retention_days    = 14
  cloudwatch_kms_key_id = aws_kms_key.analytics.id

  # Glue jobs definition
  glue_jobs = {
    # Document ingestion job
    document_ingestion = {
      description       = "Ingest documents from S3 to DocumentDB"
      glue_version      = "4.0"
      worker_type       = "G.2X"
      number_of_workers = 3
      timeout           = 60
      max_retries       = 2

      command = {
        name            = "glueetl"
        script_location = "s3://PLACEHOLDER/scripts/document-ingestion.py"
        python_version  = "3"
      }

      default_arguments = {
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-spark-ui"                  = "true"
        "--additional-python-modules"        = "pymongo==4.3.3,boto3"
      }
    }

    # Real-time analytics processor
    realtime_analytics = {
      description       = "Process streaming data from Kafka for real-time analytics"
      glue_version      = "4.0"
      worker_type       = "G.2X"
      number_of_workers = 5
      timeout           = 120
      max_retries       = 3

      command = {
        name            = "gluestreaming"
        script_location = "s3://PLACEHOLDER/scripts/realtime-analytics.py"
        python_version  = "3"
      }

      default_arguments = {
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-spark-ui"                  = "true"
        "--additional-python-modules"        = "pymongo==4.3.3,kafka-python==2.0.2"
      }
    }

    # Document similarity analyzer
    document_similarity = {
      description       = "Analyze document similarities using ML techniques"
      glue_version      = "4.0"
      worker_type       = "G.4X"
      number_of_workers = 4
      timeout           = 180
      max_retries       = 2

      command = {
        name            = "glueetl"
        script_location = "s3://PLACEHOLDER/scripts/document-similarity.py"
        python_version  = "3"
      }

      default_arguments = {
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-spark-ui"                  = "true"
        "--additional-python-modules"        = "scikit-learn==1.2.2,numpy==1.24.3,pandas==2.0.3"
      }
    }

    # Data quality checker
    data_quality_check = {
      description       = "Validate data quality across data lake layers"
      glue_version      = "4.0"
      worker_type       = "G.1X"
      number_of_workers = 2
      timeout           = 90
      max_retries       = 3

      command = {
        name            = "glueetl"
        script_location = "s3://PLACEHOLDER/scripts/data-quality-check.py"
        python_version  = "3"
      }

      default_arguments = {
        "--enable-continuous-cloudwatch-log" = "true"
        "--additional-python-modules"        = "great-expectations==0.17.23,pandas==2.0.3"
      }
    }
  }
}

# Security group for Glue jobs
resource "aws_security_group" "glue_jobs" {
  name_prefix = "${local.name}-glue-jobs-"
  vpc_id      = module.vpc.vpc_id

  # Allow HTTPS outbound for AWS services
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outbound for AWS services"
  }

  # Allow DocumentDB access
  egress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [module.docdb.security_group_id]
    description     = "DocumentDB access"
  }

  # Allow Kafka access
  egress {
    from_port       = 9098
    to_port         = 9098
    protocol        = "tcp"
    security_groups = [module.msk.security_group_id]
    description     = "MSK Kafka access"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name}-glue-jobs-sg"
  })
}

# Bastion host for secure access to analytics platform
module "bastion" {
  source = "../../modules/aws-bastion"

  name = "${local.name}-bastion"
  tags = local.common_tags

  # Network configuration
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  # Instance configuration
  instance_type = var.bastion_instance_type

  # SSH access configuration
  create_ssh_key = true

  # Security configuration - allowing access from specific CIDRs
  allowed_cidrs = var.bastion_allowed_cidr_blocks

  # VPC Endpoints for secure AWS service access
  create_vpc_endpoints = true

  # Monitoring
  enable_detailed_monitoring = false
  enable_cloudwatch_logs     = true
  log_retention_days         = 7
}

# CloudWatch Log Group for analytics platform logs
resource "aws_cloudwatch_log_group" "analytics_platform_logs" {
  name              = "/aws/analytics-platform/${local.name}"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.analytics.arn

  tags = local.common_tags
}
