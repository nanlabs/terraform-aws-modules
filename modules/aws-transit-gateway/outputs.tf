# Transit Gateway Outputs

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw.ec2_transit_gateway_id
}

output "transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.tgw.ec2_transit_gateway_arn
}

output "transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.tgw.ec2_transit_gateway_association_default_route_table_id
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.tgw.ec2_transit_gateway_propagation_default_route_table_id
}

output "transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether the Gateway uses its default association route table"
  value       = module.tgw.ec2_transit_gateway_route_table_default_association_route_table
}

output "transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether the Gateway uses its default propagation route table"
  value       = module.tgw.ec2_transit_gateway_route_table_default_propagation_route_table
}

# Custom route table outputs
output "hub_route_table_id" {
  description = "Hub route table identifier"
  value       = var.create_hub_route_table ? aws_ec2_transit_gateway_route_table.hub[0].id : null
}

output "spoke_route_table_id" {
  description = "Spoke route table identifier"
  value       = var.create_spoke_route_table ? aws_ec2_transit_gateway_route_table.spoke[0].id : null
}

output "isolated_route_table_id" {
  description = "Isolated route table identifier"
  value       = var.create_isolated_route_table ? aws_ec2_transit_gateway_route_table.isolated[0].id : null
}

# VPC attachment outputs
output "hub_vpc_attachment_id" {
  description = "Hub VPC attachment identifier"
  value       = var.hub_vpc_id != null ? aws_ec2_transit_gateway_vpc_attachment.hub_vpc[0].id : null
}

# Resource sharing outputs
output "ram_resource_share_id" {
  description = "RAM resource share identifier"
  value       = var.enable_cross_account_sharing ? aws_ram_resource_share.tgw[0].id : null
}

output "ram_resource_share_arn" {
  description = "RAM resource share ARN"
  value       = var.enable_cross_account_sharing ? aws_ram_resource_share.tgw[0].arn : null
}
