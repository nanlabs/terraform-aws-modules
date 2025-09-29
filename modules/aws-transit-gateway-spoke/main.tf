# Transit Gateway Spoke Module
# This module creates a Transit Gateway attachment for spoke VPCs and configures routing

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Note: SSM parameter data sources are commented out because cross-account SSM access
# requires additional IAM permissions. Instead, we rely on variables passed from shared-config.
# These data sources are kept for reference but should not be used in production.

# data "aws_ssm_parameter" "transit_gateway_id" {
#   count = var.transit_gateway_id == null ? 1 : 0
#   name  = "/networking/transit-gateway/id"
# }

# data "aws_ssm_parameter" "spoke_route_table_id" {
#   count = var.spoke_route_table_id == null ? 1 : 0
#   name  = "/networking/transit-gateway/spoke-route-table-id"
# }

# data "aws_ssm_parameter" "hub_route_table_id" {
#   count = var.hub_route_table_id == null ? 1 : 0
#   name  = "/networking/transit-gateway/hub-route-table-id"
# }

# data "aws_ssm_parameter" "hub_vpc_cidr" {
#   count = var.hub_vpc_cidr == null ? 1 : 0
#   name  = "/networking/hub-vpc/cidr"
# }

# Local values - only transit_gateway_id is required for VPC attachment
locals {
  # Validate that transit_gateway_id is provided
  transit_gateway_id = var.transit_gateway_id != null ? var.transit_gateway_id : (
    error("transit_gateway_id variable is required and cannot be null. Please provide the value via shared-config.")
  )

  # Route table IDs are not needed in spoke accounts (commented out due to RAM limitations)
  # spoke_route_table_id = var.spoke_route_table_id != null ? var.spoke_route_table_id : (
  #   error("spoke_route_table_id variable is required and cannot be null. Please provide the value via shared-config.")
  # )
  # hub_route_table_id   = var.hub_route_table_id != null ? var.hub_route_table_id : (
  #   error("hub_route_table_id variable is required and cannot be null. Please provide the value via shared-config.")
  # )

  hub_vpc_cidr = var.hub_vpc_cidr != null ? var.hub_vpc_cidr : (
    error("hub_vpc_cidr variable is required and cannot be null. Please provide the value via shared-config.")
  )

  spoke_vpc_cidr = var.vpc_cidr

  # Tags for all resources
  tags = merge(var.tags, {
    Module           = "aws-transit-gateway-spoke"
    TransitGatewayId = local.transit_gateway_id
    NetworkTier      = "Spoke"
    HubConnectivity  = "TransitGateway"
  })
}

# VPC Attachment to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  subnet_ids                                      = var.subnet_ids
  transit_gateway_id                              = local.transit_gateway_id
  vpc_id                                          = var.vpc_id
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(local.tags, {
    Name = "${var.name}-tgw-attachment"
  })

  # NOTE ABOUT DEFAULT ROUTE TABLE FLAGS
  # ---------------------------------------------------------------------------
  # The attributes `transit_gateway_default_route_table_association` and
  # `transit_gateway_default_route_table_propagation` are effectively owned by
  # the Transit Gateway (hub / networking) account. While the AWS API allows
  # specifying these flags at creation time from the spoke (VPC owner) account,
  # subsequent modify operations to flip them from the spoke side are ignored.
  #
  # Outcome observed:
  # - Networking (hub) account accepter resource successfully enforces both to
  #   `false` (desired architecture: explicit route table association only).
  # - Spoke account provider continues to read them as `true`, causing a
  #   perpetual in-place plan drift (true -> false) on every `terraform plan`.
  #
  # Rationale:
  # The TGW owner controls default RT association/propagation behavior. The
  # VPC attachment view from the spoke account does not reflect (or cannot
  # mutate) the hub-side enforced setting, so Terraform cannot converge.
  #
  # Resolution:
  # We ignore further drift for these two attributes in the spoke account and
  # manage them authoritatively in the networking account via the accepter
  # (`aws_ec2_transit_gateway_vpc_attachment_accepter`). This removes noisy
  # non-actionable plan output while preserving intended architecture.
  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation,
    ]
  }
}

# NOTE: Route table association and propagation are commented out because:
# - Transit Gateway route tables cannot be shared via AWS RAM
# - Only the hub account (networking) has visibility to these route tables
# - These operations must be performed from the hub account

# Associate the VPC attachment with spoke route table
# resource "aws_ec2_transit_gateway_route_table_association" "spoke" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
#   transit_gateway_route_table_id = local.spoke_route_table_id
# }

# Propagate spoke routes to hub route table (if enabled)
# resource "aws_ec2_transit_gateway_route_table_propagation" "spoke_to_hub" {
#   count = var.enable_propagation_to_hub ? 1 : 0

#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke.id
#   transit_gateway_route_table_id = local.hub_route_table_id
# }

# Route to hub VPC through Transit Gateway
resource "aws_route" "spoke_to_hub" {
  count = length(var.private_route_table_ids)

  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = local.hub_vpc_cidr
  transit_gateway_id     = local.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.spoke]
}

# Route to other spoke VPCs through Transit Gateway (if specified)
resource "aws_route" "spoke_to_spoke" {
  for_each = var.enable_spoke_to_spoke_routing ? toset(var.other_spoke_cidrs) : toset([])

  route_table_id         = var.private_route_table_ids[0] # Use first route table as representative
  destination_cidr_block = each.value
  transit_gateway_id     = local.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.spoke]
}

# Default route to hub (for internet access) if enabled
resource "aws_route" "spoke_default_via_hub" {
  count = var.enable_internet_via_hub ? length(var.private_route_table_ids) : 0

  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = local.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.spoke]
}

# Store VPC attachment information in SSM for reference
resource "aws_ssm_parameter" "vpc_attachment_id" {
  name  = "/${var.name}/transit-gateway/vpc-attachment-id"
  type  = "String"
  value = aws_ec2_transit_gateway_vpc_attachment.spoke.id

  description = "Transit Gateway VPC attachment ID for ${var.name}"

  tags = merge(local.tags, {
    Name    = "${var.name}-tgw-attachment-id"
    Purpose = "transit-gateway-reference"
  })
}

# Store spoke VPC information in SSM for hub account reference
resource "aws_ssm_parameter" "spoke_vpc_info" {
  name  = "/${var.name}/transit-gateway/spoke-vpc-cidr"
  type  = "String"
  value = local.spoke_vpc_cidr

  description = "Spoke VPC CIDR for ${var.name} - used by hub for routing"

  tags = merge(local.tags, {
    Name    = "${var.name}-spoke-vpc-cidr"
    Purpose = "hub-routing-reference"
  })
}
