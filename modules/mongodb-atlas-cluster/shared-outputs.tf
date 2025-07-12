# ---------------------------------------------------------------------------------------------------------------------
# SHARED OUTPUTS
# Common outputs that might be used by other modules
# ---------------------------------------------------------------------------------------------------------------------

output "project_id" {
  description = "The MongoDB Atlas project ID"
  value       = mongodbatlas_project.project.id
}

output "project_name" {
  description = "The MongoDB Atlas project name"
  value       = mongodbatlas_project.project.name
}

output "cluster_id" {
  description = "The cluster ID"
  value       = mongodbatlas_cluster.cluster.cluster_id
}

output "cluster_name" {
  description = "The cluster name"
  value       = mongodbatlas_cluster.cluster.name
}
