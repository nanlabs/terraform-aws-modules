output "cluster_id" {
  description = "MongoDB Atlas cluster ID"
  value       = module.mongodb_atlas_cluster.cluster_id
}

output "project_id" {
  description = "MongoDB Atlas project ID"
  value       = module.mongodb_atlas_cluster.project_id
}

output "mongo_uri" {
  description = "MongoDB connection URI"
  value       = module.mongodb_atlas_cluster.mongo_uri
  sensitive   = true
}

output "srv_address" {
  description = "MongoDB SRV address"
  value       = module.mongodb_atlas_cluster.srv_address
  sensitive   = true
}

output "ssm_parameter_names" {
  description = "Names of created SSM parameters"
  value       = module.mongodb_atlas_cluster.ssm_parameter_names
}

output "secret_arn" {
  description = "ARN of the created secret"
  value       = module.mongodb_atlas_cluster.secret_arn
}

output "secret_name" {
  description = "Name of the created secret"
  value       = module.mongodb_atlas_cluster.secret_name
}
