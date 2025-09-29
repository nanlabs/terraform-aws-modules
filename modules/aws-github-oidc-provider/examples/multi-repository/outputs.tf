output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.github_oidc_multi.oidc_provider_arn
}

output "github_actions_roles" {
  description = "Map of GitHub Actions roles for all repositories"
  value       = module.github_oidc_multi.github_actions_roles
}

output "repositories_configuration" {
  description = "Configuration summary for all repositories"
  value       = module.github_oidc_multi.repositories_configuration
}

output "data_jobs_policy_arn" {
  description = "ARN of the custom data jobs policy"
  value       = aws_iam_policy.data_jobs_permissions.arn
}
