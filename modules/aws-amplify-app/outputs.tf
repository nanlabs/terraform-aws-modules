output "name" {
  description = "Amplify App name"
  value       = module.amplify_app.name
}

output "arn" {
  description = "Amplify App ARN"
  value       = module.amplify_app.arn
}

output "default_domain" {
  description = "Amplify App domain (non-custom)"
  value       = module.amplify_app.default_domain
}

output "backend_environments" {
  description = "Created backend environments"
  value       = module.amplify_app.backend_environments
}

output "branch_names" {
  description = "The names of the created Amplify branches"
  value       = module.amplify_app.branch_names
}

output "webhooks" {
  description = "Created webhooks"
  value       = module.amplify_app.webhooks
}

output "domain_associations" {
  description = "Created domain associations"
  value       = module.amplify_app.domain_associations
}

output "app_id" {
  description = "Amplify App ID"
  value       = module.amplify_app.id
}

output "github_pat_parameter_name" {
  description = "SSM Parameter name for GitHub PAT"
  value       = var.github_personal_access_token_secret_path
  sensitive   = true
}

output "app_url" {
  description = "Default Amplify app URL"
  value       = "https://${module.amplify_app.default_domain}"
}

output "environments" {
  description = "Deployed environments with their URLs"
  value = {
    for env_name, env_config in var.environments : env_name => {
      branch_name = env_config.branch_name
      stage       = env_config.stage
      url         = "https://${env_config.branch_name}.${module.amplify_app.default_domain}"
    }
  }
}
