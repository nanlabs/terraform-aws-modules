locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Example     = "medium-complexity-infrastructure"
  }

  cluster_name = "${var.project_name}-${var.environment}"
}

# Create VPC for the infrastructure
module "vpc" {
  source = "../../modules/aws-vpc"

  name = local.cluster_name
  tags = local.common_tags

  # VPC Configuration
  cidr     = "10.0.0.0/16"
  azs_count = 3

  # NAT Gateway Configuration (Multi-AZ for production-like setup)
  enable_nat_gateway = true
  single_nat_gateway = false

  # Flow Logs
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

# EKS Cluster
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
  cluster_log_retention_period = 14

  # Security configuration
  endpoint_private_access = true
  endpoint_public_access  = true

  # Encryption
  cluster_encryption_config_enabled = true

  # Node groups configuration
  node_groups = [
    {
      instance_types   = ["t3.medium"]
      min_size         = 1
      max_size         = 3
      desired_size     = 2
      kubernetes_labels = {
        role = "system"
      }
      tags = {
        NodeGroup = "system"
      }
    },
    {
      instance_types   = ["t3.large"]
      min_size         = 1
      max_size         = 5
      desired_size     = 2
      kubernetes_labels = {
        role = "application"
      }
      tags = {
        NodeGroup = "application"
      }
    }
  ]

  tags = local.common_tags
}

# RDS Database
module "rds" {
  source = "../../modules/aws-rds"

  name = "${local.cluster_name}-db"
  tags = local.common_tags

  # Engine Configuration
  engine               = "postgres"
  engine_version       = "15.8"
  family              = "postgres15"
  major_engine_version = "15"
  instance_class      = "db.t3.micro"

  # Database Configuration
  db_name  = "application"
  username = var.db_master_username
  password = var.db_master_password
  port     = "5432"

  # Storage Configuration
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true

  # Network Configuration
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Backup and Maintenance
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  # Additional Configuration
  multi_az            = false  # Set to true for production
  skip_final_snapshot = true   # Set to false for production
  publicly_accessible = false
}

# Security Groups
resource "aws_security_group" "rds" {
  name_prefix = "${local.cluster_name}-rds-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_group_security_group_id]
  }

  # Allow access from bastion if enabled
  dynamic "ingress" {
    for_each = var.enable_bastion ? [1] : []
    content {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.bastion[0].security_group_id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.cluster_name}-rds"
  })
}

# Bastion Host (optional)
module "bastion" {
  count  = var.enable_bastion ? 1 : 0
  source = "../../modules/aws-bastion"

  name = "${local.cluster_name}-bastion"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  instance_type = "t3.nano"

  tags = local.common_tags
}

# IAM Role for applications running in EKS
module "app_iam_role" {
  source = "../../modules/aws-iam-role"

  name             = "${local.cluster_name}-app-role"
  role_description = "IAM role for applications running in ${local.cluster_name} EKS cluster"

  principals = {
    "Federated" = [module.eks.oidc_provider_arn]
  }

  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^.*\\/([^/]+)$/", "$1")}:sub"
      values   = ["system:serviceaccount:default:app-service-account"]
    },
    {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^.*\\/([^/]+)$/", "$1")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  ]

  policy_documents = [
    jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "arn:aws:s3:::${local.cluster_name}-app-bucket/*"
        }
      ]
    })
  ]

  policy_document_count = 1

  tags = local.common_tags
}
