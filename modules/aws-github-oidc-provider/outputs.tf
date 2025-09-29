# Outputs for GitHub OIDC Provider module

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "oidc_provider_url" {
  description = "URL of the GitHub OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.github.url
}

# Single repository mode outputs (backward compatibility)
output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions (single repository mode)"
  value       = local.single_mode ? aws_iam_role.github_actions["single"].arn : null
}

output "github_actions_role_name" {
  description = "Name of the IAM role for GitHub Actions (single repository mode)"
  value       = local.single_mode ? aws_iam_role.github_actions["single"].name : null
}

output "github_actions_role_id" {
  description = "ID of the IAM role for GitHub Actions (single repository mode)"
  value       = local.single_mode ? aws_iam_role.github_actions["single"].id : null
}

output "github_actions_role_unique_id" {
  description = "Unique ID of the IAM role for GitHub Actions (single repository mode)"
  value       = local.single_mode ? aws_iam_role.github_actions["single"].unique_id : null
}

# Multi-repository mode outputs
output "github_actions_roles" {
  description = "Map of IAM roles for GitHub Actions (multi-repository mode)"
  value = local.multi_mode ? {
    for k, role in aws_iam_role.github_actions : k => {
      arn       = role.arn
      name      = role.name
      id        = role.id
      unique_id = role.unique_id
    }
  } : {}
}

output "repositories_configuration" {
  description = "Configuration summary for all repositories"
  value = {
    for k, config in local.repositories_normalized : k => {
      github_repository   = config.github_repository
      github_environments = config.github_environments
      github_branches     = config.github_branches
      role_name           = config.role_name
      role_arn            = aws_iam_role.github_actions[k].arn
    }
  }
}
