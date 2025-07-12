# ---------------------------------------------------------------------------------------------------------------------
# MONGODB ATLAS SPECIFIC OUTPUTS
# Outputs specific to MongoDB Atlas cluster details
# ---------------------------------------------------------------------------------------------------------------------

output "mongo_db_version" {
  value       = mongodbatlas_cluster.cluster.mongo_db_version
  description = "Version of MongoDB the cluster runs, in major-version.minor-version format"
}

output "mongo_uri" {
  value       = mongodbatlas_cluster.cluster.mongo_uri
  description = "Base connection string for the cluster"
  sensitive   = true
}

output "mongo_uri_updated" {
  value       = mongodbatlas_cluster.cluster.mongo_uri_updated
  description = "Lists when the connection string was last updated"
}

output "mongo_uri_with_options" {
  value       = mongodbatlas_cluster.cluster.mongo_uri_with_options
  description = "connection string for connecting to the Atlas cluster. Includes the replicaSet, ssl, and authSource query parameters in the connection string with values appropriate for the cluster"
  sensitive   = true
}

output "connection_strings" {
  value       = mongodbatlas_cluster.cluster.connection_strings
  description = "Set of connection strings that your applications use to connect to this cluster"
  sensitive   = true
}

output "container_id" {
  value       = mongodbatlas_cluster.cluster.container_id
  description = "The Network Peering Container ID"
}

output "paused" {
  value       = mongodbatlas_cluster.cluster.paused
  description = "Flag that indicates whether the cluster is paused or not"
}

output "srv_address" {
  value       = mongodbatlas_cluster.cluster.srv_address
  description = "Connection string for connecting to the Atlas cluster. The +srv modifier forces the connection to use TLS/SSL"
  sensitive   = true
}

output "state_name" {
  value       = mongodbatlas_cluster.cluster.state_name
  description = "Current state of the cluster"
}

# SSM Parameter outputs
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters"
  value       = var.create_ssm_parameters ? keys(aws_ssm_parameter.mongodb_details) : []
}

# Secret outputs
output "secret_arn" {
  description = "ARN of the created secret"
  value       = var.create_secret ? aws_secretsmanager_secret.mongodb_connection[0].arn : null
}

output "secret_name" {
  description = "Name of the created secret"
  value       = var.create_secret ? aws_secretsmanager_secret.mongodb_connection[0].name : null
}
