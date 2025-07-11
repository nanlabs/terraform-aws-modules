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
  value       = module.vpc.vpc_default_security_group_id
}

# SSM Parameters
output "ssm_parameter_vpc_id" {
  description = "name of the ssm parameter for the vpc id"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.vpc_id[0].name : null
}

output "ssm_parameter_public_subnets" {
  description = "name of the ssm parameter for the public subnets"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.public_subnets[0].name : null
}

output "ssm_parameter_private_subnets" {
  description = "name of the ssm parameter for the private subnets"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.private_subnets[0].name : null
}

output "ssm_parameter_database_subnets" {
  description = "name of the ssm parameter for the database subnets"
  value       = var.create_ssm_parameters && length(module.vpc.database_subnets) > 0 ? aws_ssm_parameter.database_subnets[0].name : null
}

output "ssm_parameter_app_subnets" {
  description = "name of the ssm parameter for the app subnets"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.app_subnets[0].name : null
}

output "ssm_parameter_app_security_group" {
  description = "name of the ssm parameter for the app security group"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.app_security_group[0].name : null
}

# SSM Parameter Names Output
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for VPC details"
  value = var.create_ssm_parameters ? {
    vpc_id                     = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/vpc_id"
    vpc_cidr_block             = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/vpc_cidr_block"
    database_subnets           = length(module.vpc.database_subnets) > 0 ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/database_subnets" : null
    database_subnet_group      = module.vpc.database_subnet_group != null ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/database_subnet_group" : null
    database_subnet_group_name = module.vpc.database_subnet_group_name != null ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/database_subnet_group_name" : null
    public_subnets             = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/public_subnets"
    private_subnets            = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/private_subnets"
    app_subnets                = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/app_subnets"
    app_security_group         = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/app_security_group"
    availability_zones         = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/availability_zones"
    internet_gateway_id        = module.vpc.igw_id != null ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/internet_gateway_id" : null
    nat_gateway_ids            = length(module.vpc.natgw_ids) > 0 ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/nat_gateway_ids" : null
  } : {}
}
