# ==============================================================================
# OUTPUTS - Hub-and-Spoke Networking Architecture
# ==============================================================================

# ==============================================================================
# TRANSIT GATEWAY OUTPUTS
# ==============================================================================

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = module.transit_gateway.transit_gateway_arn
}

# ==============================================================================
# HUB VPC OUTPUTS
# ==============================================================================

output "hub_vpc_id" {
  description = "ID of the hub VPC"
  value       = module.hub_vpc.vpc_id
}

output "hub_vpc_cidr_block" {
  description = "CIDR block of the hub VPC"
  value       = module.hub_vpc.vpc_cidr_block
}

output "hub_private_subnets" {
  description = "List of IDs of hub VPC private subnets"
  value       = module.hub_vpc.private_subnets
}

output "hub_public_subnets" {
  description = "List of IDs of hub VPC public subnets"
  value       = module.hub_vpc.public_subnets
}

output "hub_database_subnets" {
  description = "List of IDs of hub VPC database subnets"
  value       = module.hub_vpc.database_subnets
}

# ==============================================================================
# EGRESS VPC OUTPUTS
# ==============================================================================

output "egress_vpc_id" {
  description = "ID of the egress VPC"
  value       = module.egress_vpc.vpc_id
}

output "egress_vpc_cidr_block" {
  description = "CIDR block of the egress VPC"
  value       = module.egress_vpc.vpc_cidr_block
}

output "egress_nat_gateway_ids" {
  description = "List of IDs of the NAT Gateways in egress VPC"
  value       = module.egress_vpc.natgw_ids
}

# ==============================================================================
# SPOKE VPC OUTPUTS
# ==============================================================================

output "dev_vpc_id" {
  description = "ID of the development spoke VPC"
  value       = module.dev_spoke_vpc.vpc_id
}

output "dev_vpc_cidr_block" {
  description = "CIDR block of the development spoke VPC"
  value       = module.dev_spoke_vpc.vpc_cidr_block
}

output "staging_vpc_id" {
  description = "ID of the staging spoke VPC"
  value       = module.staging_spoke_vpc.vpc_id
}

output "staging_vpc_cidr_block" {
  description = "CIDR block of the staging spoke VPC"
  value       = module.staging_spoke_vpc.vpc_cidr_block
}

output "prod_vpc_id" {
  description = "ID of the production spoke VPC"
  value       = module.prod_spoke_vpc.vpc_id
}

output "prod_vpc_cidr_block" {
  description = "CIDR block of the production spoke VPC"
  value       = module.prod_spoke_vpc.vpc_cidr_block
}

# ==============================================================================
# TRANSIT GATEWAY ATTACHMENT OUTPUTS
# ==============================================================================

output "tgw_attachment_ids" {
  description = "Map of Transit Gateway VPC attachment IDs"
  value = {
    hub     = module.hub_tgw_spoke.vpc_attachment_id
    egress  = module.egress_tgw_spoke.vpc_attachment_id
    dev     = module.dev_tgw_spoke.vpc_attachment_id
    staging = module.staging_tgw_spoke.vpc_attachment_id
    prod    = module.prod_tgw_spoke.vpc_attachment_id
  }
}

# ==============================================================================
# BASTION HOST OUTPUTS
# ==============================================================================

output "hub_bastion_instance_id" {
  description = "Instance ID of the hub bastion host"
  value       = module.hub_bastion.instance_id
}

output "hub_bastion_private_ip" {
  description = "Private IP address of the hub bastion host"
  value       = module.hub_bastion.instance_private_ip
}

output "hub_bastion_security_group_id" {
  description = "Security group ID of the hub bastion host"
  value       = module.hub_bastion.security_group_id
}

# Environment bastion outputs (conditional)
output "dev_bastion_instance_id" {
  description = "Instance ID of the development bastion host"
  value       = var.create_environment_bastions && length(module.dev_bastion) > 0 ? module.dev_bastion[0].instance_id : null
}

output "staging_bastion_instance_id" {
  description = "Instance ID of the staging bastion host"
  value       = var.create_environment_bastions && length(module.staging_bastion) > 0 ? module.staging_bastion[0].instance_id : null
}

output "prod_bastion_instance_id" {
  description = "Instance ID of the production bastion host"
  value       = var.create_environment_bastions && length(module.prod_bastion) > 0 ? module.prod_bastion[0].instance_id : null
}

# ==============================================================================
# CONNECTIVITY INFORMATION
# ==============================================================================

output "network_architecture_summary" {
  description = "Summary of the network architecture"
  value = {
    transit_gateway_id = module.transit_gateway.transit_gateway_id
    vpc_count         = 5
    vpcs = {
      hub = {
        id   = module.hub_vpc.vpc_id
        cidr = module.hub_vpc.vpc_cidr_block
        type = "Hub"
      }
      egress = {
        id   = module.egress_vpc.vpc_id
        cidr = module.egress_vpc.vpc_cidr_block
        type = "Egress"
      }
      dev = {
        id   = module.dev_spoke_vpc.vpc_id
        cidr = module.dev_spoke_vpc.vpc_cidr_block
        type = "Spoke"
      }
      staging = {
        id   = module.staging_spoke_vpc.vpc_id
        cidr = module.staging_spoke_vpc.vpc_cidr_block
        type = "Spoke"
      }
      prod = {
        id   = module.prod_spoke_vpc.vpc_id
        cidr = module.prod_spoke_vpc.vpc_cidr_block
        type = "Spoke"
      }
    }
    bastion_hosts = {
      hub_bastion_private_ip      = module.hub_bastion.instance_private_ip
      environment_bastions_created = var.create_environment_bastions
    }
  }
}

output "connection_endpoints" {
  description = "Connection endpoints for management access"
  value = {
    "hub_bastion_ssh"     = "aws ssm start-session --target ${module.hub_bastion.instance_id}"
    "hub_bastion_ssm"     = "aws ssm start-session --target ${module.hub_bastion.instance_id}"
    "transit_gateway"     = "https://${var.aws_region}.console.aws.amazon.com/vpc/home?region=${var.aws_region}#TransitGateways:transitGatewayId=${module.transit_gateway.transit_gateway_id}"
    "vpc_flow_logs"       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups"
  }
}

