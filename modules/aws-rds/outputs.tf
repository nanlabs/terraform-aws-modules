# Shared/Common outputs
output "name" {
  description = "The name specified as argument to this module"
  value       = var.name
}

# SSM Parameters
output "ssm_parameter_rds_endpoint" {
  description = "Name of the SSM parameter for RDS endpoint"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.address[0].name : null
}

output "ssm_parameter_rds_port" {
  description = "Name of the SSM parameter for RDS port"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.port[0].name : null
}

output "ssm_parameter_rds_database_name" {
  description = "Name of the SSM parameter for RDS database name"
  value       = var.create_ssm_parameters ? aws_ssm_parameter.name[0].name : null
}
