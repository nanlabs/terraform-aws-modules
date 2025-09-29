output "ssm_parameter_names" {
  description = "Map of SSM parameter names for cross-account reference"
  value = {
    # Shared Services VPC parameters
    shared_services_vpc_id               = aws_ssm_parameter.shared_services_vpc_id.name
    shared_services_vpc_cidr             = aws_ssm_parameter.shared_services_vpc_cidr.name
    shared_services_public_subnets       = aws_ssm_parameter.shared_services_public_subnets.name
    shared_services_private_subnets      = aws_ssm_parameter.shared_services_private_subnets.name
    shared_services_public_route_tables  = aws_ssm_parameter.shared_services_public_route_table_ids.name
    shared_services_private_route_tables = aws_ssm_parameter.shared_services_private_route_table_ids.name

    # Egress VPC parameters
    egress_vpc_id          = aws_ssm_parameter.egress_vpc_id.name
    egress_vpc_cidr        = aws_ssm_parameter.egress_vpc_cidr.name
    egress_nat_gateway_ids = aws_ssm_parameter.egress_nat_gateway_ids.name

    # Transit Gateway parameters
    transit_gateway_id             = aws_ssm_parameter.transit_gateway_id.name
    transit_gateway_route_table_id = aws_ssm_parameter.transit_gateway_route_table_id.name
  }
}

output "cross_account_role_arns" {
  description = "Map of cross-account IAM role ARNs"
  value = {
    for name, role in aws_iam_role.cross_account_networking :
    name => role.arn
  }
}

output "cross_account_policy_arn" {
  description = "ARN of the cross-account networking policy"
  value       = aws_iam_policy.cross_account_networking.arn
}

# ==============================================================================
# SHARED SERVICES VPC OUTPUTS
# ==============================================================================

output "shared_services_vpc_id" {
  description = "Shared Services VPC ID"
  value       = var.shared_services_vpc_id
}

output "shared_services_vpc_cidr" {
  description = "Shared Services VPC CIDR block"
  value       = var.shared_services_vpc_cidr
}

# ==============================================================================
# EGRESS VPC OUTPUTS
# ==============================================================================

output "egress_vpc_id" {
  description = "Egress VPC ID"
  value       = var.egress_vpc_id
}

output "egress_vpc_cidr" {
  description = "Egress VPC CIDR block"
  value       = var.egress_vpc_cidr
}

output "egress_nat_gateway_ids" {
  description = "List of NAT Gateway IDs in the Egress VPC"
  value       = var.egress_nat_gateway_ids
}

# ==============================================================================
# TRANSIT GATEWAY OUTPUTS
# ==============================================================================

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = var.transit_gateway_id
}

output "transit_gateway_route_table_id" {
  description = "Transit Gateway Route Table ID"
  value       = var.transit_gateway_route_table_id
}

output "shared_networking_prefix" {
  description = "SSM parameter prefix for shared networking resources"
  value       = "/${var.name_prefix}/shared-networking"
}
