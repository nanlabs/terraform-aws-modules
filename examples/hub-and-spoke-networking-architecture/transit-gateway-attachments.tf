# ==============================================================================
# TRANSIT GATEWAY VPC ATTACHMENTS
# Connect all VPCs to the central Transit Gateway
# ==============================================================================

# Hub VPC Transit Gateway Spoke
module "hub_tgw_spoke" {
  source = "../../modules/aws-transit-gateway-spoke"

  name           = "${local.resource_prefix}-hub-tgw-spoke"
  vpc_id         = module.hub_vpc.vpc_id
  vpc_cidr       = module.hub_vpc.vpc_cidr_block

  # Transit Gateway configuration
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  subnet_ids              = module.hub_vpc.private_subnets
  private_route_table_ids = module.hub_vpc.private_route_table_ids
  hub_vpc_cidr            = var.hub_vpc_cidr

  tags = merge(local.common_tags, {
    VPCType    = "Hub"
    Attachment = "HubVPC"
  })
}

# Egress VPC Transit Gateway Spoke
module "egress_tgw_spoke" {
  source = "../../modules/aws-transit-gateway-spoke"

  name           = "${local.resource_prefix}-egress-tgw-spoke"
  vpc_id         = module.egress_vpc.vpc_id
  vpc_cidr       = module.egress_vpc.vpc_cidr_block

  # Transit Gateway configuration
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  subnet_ids              = module.egress_vpc.private_subnets
  private_route_table_ids = module.egress_vpc.private_route_table_ids
  hub_vpc_cidr            = var.hub_vpc_cidr

  tags = merge(local.common_tags, {
    VPCType    = "Egress"
    Attachment = "EgressVPC"
  })
}

# Development Spoke VPC Transit Gateway Spoke
module "dev_tgw_spoke" {
  source = "../../modules/aws-transit-gateway-spoke"

  name           = "${local.resource_prefix}-dev-tgw-spoke"
  vpc_id         = module.dev_spoke_vpc.vpc_id
  vpc_cidr       = module.dev_spoke_vpc.vpc_cidr_block

  # Transit Gateway configuration
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  subnet_ids              = module.dev_spoke_vpc.private_subnets
  private_route_table_ids = module.dev_spoke_vpc.private_route_table_ids
  hub_vpc_cidr            = var.hub_vpc_cidr

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Attachment  = "DevSpokeVPC"
    Environment = "dev"
  })
}

# Staging Spoke VPC Transit Gateway Spoke
module "staging_tgw_spoke" {
  source = "../../modules/aws-transit-gateway-spoke"

  name           = "${local.resource_prefix}-staging-tgw-spoke"
  vpc_id         = module.staging_spoke_vpc.vpc_id
  vpc_cidr       = module.staging_spoke_vpc.vpc_cidr_block

  # Transit Gateway configuration
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  subnet_ids              = module.staging_spoke_vpc.private_subnets
  private_route_table_ids = module.staging_spoke_vpc.private_route_table_ids
  hub_vpc_cidr            = var.hub_vpc_cidr

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Attachment  = "StagingSpokeVPC"
    Environment = "staging"
  })
}

# Production Spoke VPC Transit Gateway Spoke
module "prod_tgw_spoke" {
  source = "../../modules/aws-transit-gateway-spoke"

  name           = "${local.resource_prefix}-prod-tgw-spoke"
  vpc_id         = module.prod_spoke_vpc.vpc_id
  vpc_cidr       = module.prod_spoke_vpc.vpc_cidr_block

  # Transit Gateway configuration
  transit_gateway_id = module.transit_gateway.transit_gateway_id

  subnet_ids              = module.prod_spoke_vpc.private_subnets
  private_route_table_ids = module.prod_spoke_vpc.private_route_table_ids
  hub_vpc_cidr            = var.hub_vpc_cidr

  tags = merge(local.common_tags, {
    VPCType     = "Spoke"
    Attachment  = "ProdSpokeVPC"
    Environment = "prod"
  })
}

