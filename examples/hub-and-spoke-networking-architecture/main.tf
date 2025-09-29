# ==============================================================================
# HUB-AND-SPOKE NETWORKING ARCHITECTURE
# Multi-VPC networking with centralized services and egress
# ==============================================================================

locals {
  # Environment-specific configuration
  resource_prefix = "${var.project_name}-${var.environment}"

  # Common tags
  common_tags = merge(var.additional_tags, {
    Project      = var.project_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Pattern      = "HubAndSpokeNetworking"
    Architecture = "MultiVPC"
  })

  # VPC configurations
  vpc_configs = {
    hub = {
      name = "${local.resource_prefix}-hub"
      cidr = var.hub_vpc_cidr
      type = "Hub"
    }
    egress = {
      name = "${local.resource_prefix}-egress"
      cidr = var.egress_vpc_cidr
      type = "Egress"
    }
    dev = {
      name = "${local.resource_prefix}-dev-spoke"
      cidr = var.dev_vpc_cidr
      type = "Spoke"
    }
    staging = {
      name = "${local.resource_prefix}-staging-spoke"
      cidr = var.staging_vpc_cidr
      type = "Spoke"
    }
    prod = {
      name = "${local.resource_prefix}-prod-spoke"
      cidr = var.prod_vpc_cidr
      type = "Spoke"
    }
  }
}

# ==============================================================================
# TRANSIT GATEWAY - CENTRAL NETWORKING HUB
# ==============================================================================

# Central Transit Gateway for hub-and-spoke architecture
module "transit_gateway" {
  source = "../../modules/aws-transit-gateway"

  name        = "${local.resource_prefix}-tgw"
  description = "Central Transit Gateway for hub-and-spoke networking"
  enable_auto_accept_shared_attachments   = true
  enable_default_route_table_association  = true
  enable_default_route_table_propagation  = true
  enable_cross_account_sharing            = false

  tags = local.common_tags
}

# ==============================================================================
# HUB VPC - SHARED SERVICES
# ==============================================================================

# Hub VPC for shared services and management
module "hub_vpc" {
  source = "../../modules/aws-vpc"

  name = local.vpc_configs.hub.name
  cidr = local.vpc_configs.hub.cidr

  # Multi-AZ configuration
  azs_count = 3

  # Subnet configuration
  public_subnets = [
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 1),   # 10.0.1.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 2),   # 10.0.2.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 3)    # 10.0.3.0/24
  ]

  private_subnets = [
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 101), # 10.0.101.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 102), # 10.0.102.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 103)  # 10.0.103.0/24
  ]

  database_subnets = [
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 201), # 10.0.201.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 202), # 10.0.202.0/24
    cidrsubnet(local.vpc_configs.hub.cidr, 8, 203)  # 10.0.203.0/24
  ]

  # NAT Gateway configuration - single NAT for hub VPC
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_destination_type            = "cloud-watch-logs"

  # Enhanced subnet tagging
  public_subnet_tags = {
    Type    = "Public"
    Tier    = "Web"
    Purpose = "SharedServices-LB"
  }

  private_subnet_tags = {
    Type    = "Private"
    Tier    = "Application"
    Purpose = "SharedServices-Apps"
  }

  database_subnet_tags = {
    Type    = "Database"
    Tier    = "Data"
    Purpose = "SharedServices-DB"
  }

  # SSM Parameters
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/networking/hub"

  tags = merge(local.common_tags, {
    VPCType = "Hub"
    Purpose = "SharedServices"
  })
}

# ==============================================================================
# EGRESS VPC - CENTRALIZED INTERNET ACCESS
# ==============================================================================

# Egress VPC for centralized internet access
module "egress_vpc" {
  source = "../../modules/aws-vpc"

  name = local.vpc_configs.egress.name
  cidr = local.vpc_configs.egress.cidr

  # Multi-AZ configuration
  azs_count = 3

  # Subnet configuration - optimized for egress
  public_subnets = [
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 1),   # 10.1.1.0/24
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 2),   # 10.1.2.0/24
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 3)    # 10.1.3.0/24
  ]

  # No private subnets needed for egress-only VPC
  private_subnets = [
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 101), # 10.1.101.0/24 - Transit Gateway subnets
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 102), # 10.1.102.0/24
    cidrsubnet(local.vpc_configs.egress.cidr, 8, 103)  # 10.1.103.0/24
  ]

  # No database subnets for egress VPC
  database_subnets = []

  # NAT Gateways in each AZ for high availability
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_destination_type            = "cloud-watch-logs"

  # Enhanced subnet tagging
  public_subnet_tags = {
    Type    = "Public"
    Tier    = "Egress"
    Purpose = "NAT-Gateways"
  }

  private_subnet_tags = {
    Type    = "Private"
    Tier    = "Transit"
    Purpose = "TransitGateway-Attachment"
  }

  # SSM Parameters
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/networking/egress"

  tags = merge(local.common_tags, {
    VPCType = "Egress"
    Purpose = "CentralizedInternetAccess"
  })
}

# ==============================================================================
# SPOKE VPCs - WORKLOAD ENVIRONMENTS
# ==============================================================================

# Development Spoke VPC
module "dev_spoke_vpc" {
  source = "../../modules/aws-vpc"

  name = local.vpc_configs.dev.name
  cidr = local.vpc_configs.dev.cidr

  # Multi-AZ configuration
  azs_count = 3

  # Subnet configuration
  public_subnets = [
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 1),   # 10.10.1.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 2),   # 10.10.2.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 3)    # 10.10.3.0/24
  ]

  private_subnets = [
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 101), # 10.10.101.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 102), # 10.10.102.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 103)  # 10.10.103.0/24
  ]

  database_subnets = [
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 201), # 10.10.201.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 202), # 10.10.202.0/24
    cidrsubnet(local.vpc_configs.dev.cidr, 8, 203)  # 10.10.203.0/24
  ]

  # No NAT Gateway - internet access via Transit Gateway to Egress VPC
  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_destination_type            = "cloud-watch-logs"

  # Enhanced subnet tagging
  public_subnet_tags = {
    Type        = "Public"
    Tier        = "Web"
    Purpose     = "Development-LB"
    Environment = "dev"
  }

  private_subnet_tags = {
    Type        = "Private"
    Tier        = "Application"
    Purpose     = "Development-Apps"
    Environment = "dev"
  }

  database_subnet_tags = {
    Type        = "Database"
    Tier        = "Data"
    Purpose     = "Development-DB"
    Environment = "dev"
  }

  # SSM Parameters
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/networking/dev-spoke"

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Purpose     = "DevelopmentWorkloads"
    Environment = "dev"
  })
}

# Staging Spoke VPC
module "staging_spoke_vpc" {
  source = "../../modules/aws-vpc"

  name = local.vpc_configs.staging.name
  cidr = local.vpc_configs.staging.cidr

  # Multi-AZ configuration
  azs_count = 3

  # Subnet configuration
  public_subnets = [
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 1),   # 10.20.1.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 2),   # 10.20.2.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 3)    # 10.20.3.0/24
  ]

  private_subnets = [
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 101), # 10.20.101.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 102), # 10.20.102.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 103)  # 10.20.103.0/24
  ]

  database_subnets = [
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 201), # 10.20.201.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 202), # 10.20.202.0/24
    cidrsubnet(local.vpc_configs.staging.cidr, 8, 203)  # 10.20.203.0/24
  ]

  # No NAT Gateway - internet access via Transit Gateway
  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_destination_type            = "cloud-watch-logs"

  # Enhanced subnet tagging
  public_subnet_tags = {
    Type        = "Public"
    Tier        = "Web"
    Purpose     = "Staging-LB"
    Environment = "staging"
  }

  private_subnet_tags = {
    Type        = "Private"
    Tier        = "Application"
    Purpose     = "Staging-Apps"
    Environment = "staging"
  }

  database_subnet_tags = {
    Type        = "Database"
    Tier        = "Data"
    Purpose     = "Staging-DB"
    Environment = "staging"
  }

  # SSM Parameters
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/networking/staging-spoke"

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Purpose     = "StagingWorkloads"
    Environment = "staging"
  })
}

# Production Spoke VPC
module "prod_spoke_vpc" {
  source = "../../modules/aws-vpc"

  name = local.vpc_configs.prod.name
  cidr = local.vpc_configs.prod.cidr

  # Multi-AZ configuration
  azs_count = 3

  # Subnet configuration
  public_subnets = [
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 1),   # 10.30.1.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 2),   # 10.30.2.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 3)    # 10.30.3.0/24
  ]

  private_subnets = [
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 101), # 10.30.101.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 102), # 10.30.102.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 103)  # 10.30.103.0/24
  ]

  database_subnets = [
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 201), # 10.30.201.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 202), # 10.30.202.0/24
    cidrsubnet(local.vpc_configs.prod.cidr, 8, 203)  # 10.30.203.0/24
  ]

  # No NAT Gateway - internet access via Transit Gateway
  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_destination_type            = "cloud-watch-logs"

  # Enhanced subnet tagging
  public_subnet_tags = {
    Type        = "Public"
    Tier        = "Web"
    Purpose     = "Production-LB"
    Environment = "prod"
  }

  private_subnet_tags = {
    Type        = "Private"
    Tier        = "Application"
    Purpose     = "Production-Apps"
    Environment = "prod"
  }

  database_subnet_tags = {
    Type        = "Database"
    Tier        = "Data"
    Purpose     = "Production-DB"
    Environment = "prod"
  }

  # SSM Parameters
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/networking/prod-spoke"

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Purpose     = "ProductionWorkloads"
    Environment = "prod"
  })
}

