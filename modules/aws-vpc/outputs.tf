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
  value       = aws_ssm_parameter.vpc_id.name
}

output "ssm_parameter_public_subnets" {
  description = "name of the ssm parameter for the public subnets"
  value       = aws_ssm_parameter.public_subnets.name
}

output "ssm_parameter_private_subnets" {
  description = "name of the ssm parameter for the private subnets"
  value       = aws_ssm_parameter.private_subnets.name
}

output "ssm_parameter_database_subnets" {
  description = "name of the ssm parameter for the database subnets"
  value       = aws_ssm_parameter.database_subnets.name
}

output "ssm_parameter_app_subnets" {
  description = "name of the ssm parameter for the app subnets"
  value       = aws_ssm_parameter.app_subnets.name
}

output "ssm_parameter_app_security_group" {
  description = "name of the ssm parameter for the app security group"
  value       = aws_ssm_parameter.app_security_group.name
}
