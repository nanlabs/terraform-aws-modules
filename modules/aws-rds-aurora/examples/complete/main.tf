provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  name = var.name
  tags = var.tags
}

# VPC for the example
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  create_database_subnet_group = true

  tags = local.tags
}

# Security group for Aurora
resource "aws_security_group" "aurora" {
  name_prefix = "${local.name}-aurora-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "PostgreSQL access from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.tags, {
    Name = "${local.name}-aurora-sg"
  })
}

# Aurora PostgreSQL cluster
module "aurora" {
  source = "../../"

  name = local.name

  # Engine configuration
  engine                     = "aurora-postgresql"
  engine_version             = "15.8"
  auto_minor_version_upgrade = true

  # Cluster instances
  instances = {
    writer = {
      instance_class = "db.serverless"
    }
    reader = {
      instance_class = "db.serverless"
    }
  }

  # Serverless v2 scaling
  serverlessv2_scaling_configuration = {
    max_capacity = 2.0
    min_capacity = 0.5
  }

  # Database configuration
  database_name   = var.database_name
  master_username = var.master_username
  port            = 5432

  # Password management
  manage_master_user_password = true

  # Network configuration
  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  # Backup and maintenance
  backup_retention_period      = 7
  preferred_backup_window      = "07:00-09:00"
  preferred_maintenance_window = "sun:05:00-sun:07:00"

  # Monitoring
  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  # Other settings
  skip_final_snapshot = true
  deletion_protection = false
  apply_immediately   = true

  # SSM Parameters (enabled by default)
  create_ssm_parameters = true
  # ssm_parameter_prefix = "/custom/prefix"  # Optional: customize SSM parameter prefix

  tags = local.tags
}
