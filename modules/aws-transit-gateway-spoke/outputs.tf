# Outputs for Transit Gateway Spoke Module

output "vpc_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}

output "vpc_attachment_state" {
  description = "State of the Transit Gateway VPC attachment"
  value       = "pending" # Estado inicial, se actualizará cuando el attachment esté disponible
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = local.transit_gateway_id
}

# Route table outputs are commented out due to AWS RAM limitations
# (route tables are not visible from spoke accounts)
# output "spoke_route_table_id" {
#   description = "ID of the spoke route table"
#   value       = local.spoke_route_table_id
# }

output "spoke_vpc_cidr" {
  description = "CIDR block of the spoke VPC"
  value       = local.spoke_vpc_cidr
}

output "hub_vpc_cidr" {
  description = "CIDR block of the hub VPC"
  value       = local.hub_vpc_cidr
}

output "ssm_parameter_vpc_attachment_id" {
  description = "SSM parameter name for VPC attachment ID"
  value       = aws_ssm_parameter.vpc_attachment_id.name
}

output "ssm_parameter_spoke_vpc_cidr" {
  description = "SSM parameter name for spoke VPC CIDR"
  value       = aws_ssm_parameter.spoke_vpc_info.name
}
