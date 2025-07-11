locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Example     = "complete-enterprise-setup"
  }

  cluster_name = "${var.project_name}-${var.environment}"
}

# Create VPC with enterprise-grade configuration
module "vpc" {
  source = "../../modules/aws-vpc"

  name = local.cluster_name
  tags = local.common_tags

  # VPC Configuration
  cidr     = "10.0.0.0/16"
  azs_count = 3

  # NAT Gateway Configuration (Multi-AZ for high availability)
  enable_nat_gateway = true
  single_nat_gateway = false

  # Security & Monitoring
  enable_flow_log = true

  # Subnet Tags for EKS
  public_subnet_tags = {
    "Type" = "public"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "Type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

# EKS Cluster with production-grade configuration
module "eks" {
  source = "../../modules/aws-eks"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version
  region             = var.aws_region

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  # Enable comprehensive logging
  enabled_cluster_log_types    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_log_retention_period = 30

  # Security configuration
  endpoint_private_access = true
  endpoint_public_access  = true

  # Encryption
  cluster_encryption_config_enabled = true

  # Node groups configuration
  node_groups = concat([
    {
      instance_types   = ["t3.medium"]
      min_size         = 2
      max_size         = 4
      desired_size     = 2
      kubernetes_labels = {
        role = "system"
      }
      tags = {
        NodeGroup = "system"
      }
    },
    {
      instance_types   = ["t3.large", "t3.xlarge"]
      min_size         = 2
      max_size         = 10
      desired_size     = 3
      kubernetes_labels = {
        role = "application"
      }
      tags = {
        NodeGroup = "application"
      }
    }
  ], var.enable_gpu_nodes ? [{
    instance_types   = ["g4dn.xlarge"]
    min_size         = 0
    max_size         = 3
    desired_size     = 1
    kubernetes_labels = {
      role = "gpu"
      "nvidia.com/gpu" = "true"
    }
    tags = {
      NodeGroup = "gpu"
    }
  }] : [])

  tags = local.common_tags
}

# RDS Aurora PostgreSQL Cluster
module "aurora" {
  source = "../../modules/aws-rds-aurora"

  name = "${local.cluster_name}-aurora"

  # Database configuration
  db_engine         = "aurora-postgresql"
  db_engine_version = "15.8"
  db_instance_class = "db.r5.large"

  # Cluster configuration
  db_instances = {
    1 = {}
    2 = {}  # Read replica
  }

  # Database details
  db_name            = "enterprise"
  db_master_username = var.aurora_master_username
  db_master_password = var.aurora_master_password
  db_port            = 5432

  # Network
  vpc_id                 = module.vpc.vpc_id
  db_subnet_group        = module.vpc.database_subnet_group
  vpc_security_group_ids = [aws_security_group.aurora.id]

  # Backup and maintenance
  db_backup_retention_period = 14
  db_backup_window          = "03:00-04:00"
  db_maintenance_window     = "sun:04:00-sun:05:00"

  enable_skip_final_snapshot = false  # Production setting
  enable_public_access      = false

  tags = local.common_tags
}

# MSK Apache Kafka Cluster (optional)
module "msk" {
  count  = var.enable_msk ? 1 : 0
  source = "../../modules/aws-msk"

  name   = "${local.cluster_name}-kafka"
  region = var.aws_region

  # Kafka configuration
  kafka_version        = "2.8.1"
  broker_per_zone      = 1
  broker_instance_type = "kafka.m5.large"
  broker_volume_size   = 100

  # Network
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  zone_id         = var.route53_zone_id

  # Security
  client_sasl_scram_enabled = true
  client_tls_auth_enabled   = true

  # Logging
  cloudwatch_logs_enabled = true
  s3_logs_enabled        = false

  tags = local.common_tags
}

# DocumentDB Cluster (optional)
module "documentdb" {
  count  = var.enable_documentdb ? 1 : 0
  source = "../../modules/aws-docdb"

  name = "${local.cluster_name}-docdb"

  # DocumentDB configuration
  db_name         = "enterprise"
  master_username = var.docdb_master_username
  master_password = var.docdb_master_password

  # Cluster configuration
  instance_class = "db.t3.medium"
  cluster_size   = 2

  # Network
  vpc_id       = module.vpc.vpc_id
  subnet_group = module.vpc.database_subnet_group

  # Security
  storage_encrypted = true
  tls_enabled      = true

  tags = local.common_tags
}

# Bastion Host for secure database access
module "bastion" {
  source = "../../modules/aws-bastion"

  name = "${local.cluster_name}-bastion"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  instance_type = "t3.nano"

  tags = local.common_tags
}

# Security Groups
resource "aws_security_group" "aurora" {
  name_prefix = "${local.cluster_name}-aurora-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_group_security_group_id, module.bastion.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.cluster_name}-aurora"
  })
}
