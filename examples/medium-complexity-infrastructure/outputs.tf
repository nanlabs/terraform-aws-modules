output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# EKS Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_oidc_provider_arn" {
  description = "ARN of the OIDC Provider for the EKS cluster"
  value       = module.eks.oidc_provider_arn
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

# Bastion Outputs
output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = var.enable_bastion ? module.bastion[0].instance_id : null
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = var.enable_bastion ? module.bastion[0].security_group_id : null
}

# IAM Outputs
output "app_iam_role_arn" {
  description = "ARN of the application IAM role"
  value       = module.app_iam_role.arn
}

output "app_iam_role_name" {
  description = "Name of the application IAM role"
  value       = module.app_iam_role.name
}

# Kubectl configuration command
output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
