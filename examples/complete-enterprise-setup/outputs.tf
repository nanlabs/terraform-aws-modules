output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.eks_cluster_endpoint
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = module.aurora.cluster_endpoint
  sensitive   = true
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.aurora.cluster_reader_endpoint
  sensitive   = true
}

output "msk_bootstrap_brokers" {
  description = "MSK bootstrap brokers"
  value       = var.enable_msk ? module.msk[0].bootstrap_brokers : null
  sensitive   = true
}

output "documentdb_endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = var.enable_documentdb ? module.documentdb[0].cluster_endpoint : null
  sensitive   = true
}

output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = module.bastion.instance_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.eks_cluster_id}"
}
