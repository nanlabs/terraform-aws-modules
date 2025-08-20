# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = local.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}

# Legacy aliases for backwards compatibility
output "app_subnets" {
  description = "Legacy alias for private_subnets"
  value       = module.vpc.private_subnets
}

output "default_security_group_id" {
  description = "Legacy alias for vpc_default_security_group_id"
  value       = module.vpc.default_security_group_id
}

# SSM Parameters (referenciando locals y variables en vez de recursos)
output "ssm_parameter_vpc_id" {
  description = "name of the ssm parameter for the vpc id"
  value       = var.create_ssm_parameters ? "${local.ssm_prefix}/vpc_id" : null
}

output "ssm_parameter_public_subnets" {
  description = "name of the ssm parameter for the public subnets"
  value       = local.create_public_subnets_ssm ? "${local.ssm_prefix}/public_subnets" : null
}

output "ssm_parameter_private_subnets" {
  description = "name of the ssm parameter for the private subnets"
  value       = local.create_private_subnets_ssm ? "${local.ssm_prefix}/private_subnets" : null
}

output "ssm_parameter_database_subnets" {
  description = "name of the ssm parameter for the database subnets"
  value       = local.create_database_subnets_ssm ? "${local.ssm_prefix}/database_subnets" : null
}

output "ssm_parameter_app_subnets" {
  description = "name of the ssm parameter for the app subnets"
  value       = var.create_ssm_parameters ? "${local.ssm_prefix}/app_subnets" : null
}

output "ssm_parameter_app_security_group" {
  description = "name of the ssm parameter for the app security group"
  value       = var.create_ssm_parameters ? "${local.ssm_prefix}/app_security_group" : null
}

# SSM Parameter Names Output (usando locals y variables)
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for VPC details"
  value = var.create_ssm_parameters ? {
    vpc_id                     = "${local.ssm_prefix}/vpc_id"
    vpc_cidr_block             = "${local.ssm_prefix}/vpc_cidr_block"
    database_subnets           = local.create_database_subnets_ssm ? "${local.ssm_prefix}/database_subnets" : null
    database_subnet_group      = local.create_database_subnet_group_ssm ? "${local.ssm_prefix}/database_subnet_group" : null
    database_subnet_group_name = local.create_database_subnet_group_name_ssm ? "${local.ssm_prefix}/database_subnet_group_name" : null
    public_subnets             = local.create_public_subnets_ssm ? "${local.ssm_prefix}/public_subnets" : null
    private_subnets            = local.create_private_subnets_ssm ? "${local.ssm_prefix}/private_subnets" : null
    app_subnets                = "${local.ssm_prefix}/app_subnets"
    app_security_group         = "${local.ssm_prefix}/app_security_group"
    availability_zones         = "${local.ssm_prefix}/availability_zones"
    internet_gateway_id        = local.create_internet_gateway_ssm ? "${local.ssm_prefix}/internet_gateway_id" : null
    nat_gateway_ids            = local.create_nat_gateway_ssm ? "${local.ssm_prefix}/nat_gateway_ids" : null
  } : {}
}
