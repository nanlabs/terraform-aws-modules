output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "amplify_app_id" {
  description = "Amplify App ID"
  value       = module.amplify_app.app_id
}

output "amplify_app_name" {
  description = "Amplify App name"
  value       = module.amplify_app.name
}

output "amplify_default_domain" {
  description = "Amplify default domain"
  value       = module.amplify_app.default_domain
}

output "amplify_app_url" {
  description = "Amplify application URL"
  value       = module.amplify_app.app_url
}

output "amplify_environments" {
  description = "Amplify environments and their URLs"
  value       = module.amplify_app.environments
}
