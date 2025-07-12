# Shared Outputs (common to all modules)

output "name" {
  description = "Name of the bastion host"
  value       = var.name
}

output "tags" {
  description = "Tags applied to resources"
  value       = var.tags
}
