# AWS Transit Gateway Module
# This module creates a Transit Gateway for hub-and-spoke networking
# Replaces the previous VPC peering approach with a more scalable solution

# Transit Gateway
module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.13.0" # Latest version (January 2025)

  name        = var.name
  description = var.description

  # Network configuration
  amazon_side_asn                        = var.amazon_side_asn
  enable_auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments
  enable_default_route_table_association = var.enable_default_route_table_association
  enable_default_route_table_propagation = var.enable_default_route_table_propagation

  # DNS support
  enable_dns_support = true

  # Share configuration for cross-account access
  share_tgw                     = var.enable_cross_account_sharing
  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals                = var.cross_account_principals

  # Tags
  tags = var.tags
}

# Route table for hub VPCs (inspection, egress, shared services)
resource "aws_ec2_transit_gateway_route_table" "hub" {
  count = var.create_hub_route_table ? 1 : 0

  transit_gateway_id = module.tgw.ec2_transit_gateway_id

  tags = merge(var.tags, {
    Name = "${var.name}-hub-route-table"
    Type = "Hub"
  })
}

# Route table for spoke VPCs (workload accounts)
resource "aws_ec2_transit_gateway_route_table" "spoke" {
  count = var.create_spoke_route_table ? 1 : 0

  transit_gateway_id = module.tgw.ec2_transit_gateway_id

  tags = merge(var.tags, {
    Name = "${var.name}-spoke-route-table"
    Type = "Spoke"
  })
}

# Route table for isolated VPCs (if needed)
resource "aws_ec2_transit_gateway_route_table" "isolated" {
  count = var.create_isolated_route_table ? 1 : 0

  transit_gateway_id = module.tgw.ec2_transit_gateway_id

  tags = merge(var.tags, {
    Name = "${var.name}-isolated-route-table"
    Type = "Isolated"
  })
}

# VPC Attachments for hub infrastructure VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "hub_vpc" {
  count = var.hub_vpc_id != null ? 1 : 0

  subnet_ids         = var.hub_vpc_private_subnet_ids
  transit_gateway_id = module.tgw.ec2_transit_gateway_id
  vpc_id             = var.hub_vpc_id

  # Route table association
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(var.tags, {
    Name = "${var.name}-hub-vpc-attachment"
    Type = "Hub"
    VPC  = var.hub_vpc_id
  })
}

# Associate hub VPC with hub route table
resource "aws_ec2_transit_gateway_route_table_association" "hub_vpc" {
  count = var.hub_vpc_id != null && var.create_hub_route_table ? 1 : 0

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub_vpc[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub[0].id
}

# Resource sharing for cross-account access
resource "aws_ram_resource_share" "tgw" {
  count = var.enable_cross_account_sharing ? 1 : 0

  name                      = "${var.name}-share"
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(var.tags, {
    Name = "${var.name}-share"
    Type = "TransitGatewayShare"
  })
}

resource "aws_ram_resource_association" "tgw" {
  count = var.enable_cross_account_sharing ? 1 : 0

  resource_arn       = module.tgw.ec2_transit_gateway_arn
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}

resource "aws_ram_principal_association" "tgw" {
  for_each = var.enable_cross_account_sharing ? toset(var.cross_account_principals) : []

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}

# Note: Transit Gateway Route Tables cannot be shared via RAM.
# Only the Transit Gateway itself can be shared.
# Spoke accounts can access route tables through the shared Transit Gateway,
# but route table IDs must be communicated via SSM parameters or other means.
