output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora.cluster_arn
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster"
  value       = module.aurora.cluster_reader_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster"
  value       = module.aurora.cluster_engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database"
  value       = module.aurora.cluster_database_name
}

output "cluster_master_username" {
  description = "Master username for the cluster"
  value       = module.aurora.cluster_master_username
  sensitive   = true
}

output "cluster_port" {
  description = "Port on which the cluster accepts connections"
  value       = module.aurora.cluster_port
}

output "cluster_master_user_secret" {
  description = "Generated master user secret when manage_master_user_password is set to true"
  value       = module.aurora.cluster_master_user_secret
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the security group created for Aurora"
  value       = aws_security_group.aurora.id
}

output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for Aurora cluster details"
  value       = module.aurora.ssm_parameter_names
}
