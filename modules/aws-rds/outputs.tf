# Shared/Common outputs
output "name" {
  description = "The name specified as argument to this module"
  value       = var.name
}

# SSM Parameters
output "ssm_parameter_rds_endpoint" {
  description = "Name of the SSM parameter for RDS endpoint"
  value       = aws_ssm_parameter.address.name
}

output "ssm_parameter_rds_port" {
  description = "Name of the SSM parameter for RDS port"
  value       = aws_ssm_parameter.port.name
}

output "ssm_parameter_rds_database_name" {
  description = "Name of the SSM parameter for RDS database name"
  value       = aws_ssm_parameter.name.name
}
