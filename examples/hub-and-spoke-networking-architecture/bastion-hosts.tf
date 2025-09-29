# ==============================================================================
# BASTION HOSTS FOR SECURE ACCESS
# One bastion host per environment for secure access
# ==============================================================================

# Shared Services Bastion (Hub VPC)
module "hub_bastion" {
  source = "../../modules/aws-bastion"

  name = "${local.resource_prefix}-hub-bastion"

  vpc_id          = module.hub_vpc.vpc_id
  private_subnets = module.hub_vpc.private_subnets
  public_subnets  = module.hub_vpc.public_subnets

  instance_type    = var.bastion_instance_type
  root_volume_size = 20

  allowed_cidrs = concat(var.bastion_allowed_cidrs, [var.dev_vpc_cidr, var.staging_vpc_cidr, var.prod_vpc_cidr])

  create_vpc_endpoints     = true
  vpc_endpoints_subnet_ids = module.hub_vpc.private_subnets

  tags = merge(local.common_tags, {
    BastionType = "Hub"
    Purpose     = "SharedServicesAccess"
    Environment = "hub"
  })
}

# Development Environment Bastion (Optional - for dedicated dev access)
module "dev_bastion" {
  count  = var.create_environment_bastions ? 1 : 0
  source = "../../modules/aws-bastion"

  name = "${local.resource_prefix}-dev-bastion"

  vpc_id          = module.dev_spoke_vpc.vpc_id
  private_subnets = module.dev_spoke_vpc.private_subnets
  public_subnets  = module.dev_spoke_vpc.public_subnets

  instance_type    = var.bastion_instance_type
  root_volume_size = 20

  allowed_cidrs = concat(var.bastion_allowed_cidrs, [var.hub_vpc_cidr])

  create_vpc_endpoints     = false
  vpc_endpoints_subnet_ids = []

  tags = merge(local.common_tags, {
    BastionType = "Environment"
    Purpose     = "DevelopmentAccess"
    Environment = "dev"
  })
}

# Staging Environment Bastion (Optional)
module "staging_bastion" {
  count  = var.create_environment_bastions ? 1 : 0
  source = "../../modules/aws-bastion"

  name = "${local.resource_prefix}-staging-bastion"

  vpc_id          = module.staging_spoke_vpc.vpc_id
  private_subnets = module.staging_spoke_vpc.private_subnets
  public_subnets  = module.staging_spoke_vpc.public_subnets

  instance_type    = var.bastion_instance_type
  root_volume_size = 20

  allowed_cidrs = concat(var.bastion_allowed_cidrs, [var.hub_vpc_cidr])

  create_vpc_endpoints     = false
  vpc_endpoints_subnet_ids = []

  tags = merge(local.common_tags, {
    BastionType = "Environment"
    Purpose     = "StagingAccess"
    Environment = "staging"
  })
}

# Production Environment Bastion (Highly restricted)
module "prod_bastion" {
  count  = var.create_environment_bastions ? 1 : 0
  source = "../../modules/aws-bastion"

  name = "${local.resource_prefix}-prod-bastion"

  vpc_id          = module.prod_spoke_vpc.vpc_id
  private_subnets = module.prod_spoke_vpc.private_subnets
  public_subnets  = module.prod_spoke_vpc.public_subnets

  instance_type    = "t3.small"
  root_volume_size = 30

  allowed_cidrs = concat(var.bastion_allowed_cidrs, [var.hub_vpc_cidr])

  create_vpc_endpoints     = false
  vpc_endpoints_subnet_ids = []

  tags = merge(local.common_tags, {
    BastionType = "Environment"
    Purpose     = "ProductionAccess"
    Environment = "prod"
    Compliance  = "Required"
  })
}

# ==============================================================================
# SECURITY GROUP RULES FOR BASTION ACCESS
# ==============================================================================

# Additional security group for database access from bastions
resource "aws_security_group" "bastion_database_access" {
  name_prefix = "${local.resource_prefix}-bastion-db-access"
  description = "Allow database access from bastion hosts"
  vpc_id      = module.hub_vpc.vpc_id

  # PostgreSQL access
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.hub_bastion.security_group_id]
    description     = "PostgreSQL access from hub bastion"
  }

  # MySQL access
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.hub_bastion.security_group_id]
    description     = "MySQL access from hub bastion"
  }

  # Allow access from environment bastions if created
  dynamic "ingress" {
    for_each = var.create_environment_bastions ? [1] : []
    content {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = concat(
        var.create_environment_bastions && length(module.dev_bastion) > 0 ? [module.dev_bastion[0].security_group_id] : [],
        var.create_environment_bastions && length(module.staging_bastion) > 0 ? [module.staging_bastion[0].security_group_id] : [],
        var.create_environment_bastions && length(module.prod_bastion) > 0 ? [module.prod_bastion[0].security_group_id] : []
      )
      description = "PostgreSQL access from environment bastions"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name    = "${local.resource_prefix}-bastion-db-access"
    Purpose = "DatabaseAccessFromBastions"
  })
}

