# Bastion Host Specific Outputs

# Network details
output "subnet_id" {
  description = "ID of the subnet where the bastion host is deployed"
  value       = element(var.private_subnets, 0)
}

# Instance details
output "instance_id" {
  description = "ID of the bastion host instance"
  value       = module.bastion.id
}

output "instance_arn" {
  description = "ARN of the bastion host instance"
  value       = module.bastion.arn
}

output "instance_private_ip" {
  description = "Private IP address of the bastion host"
  value       = module.bastion.private_ip
}

output "instance_private_dns" {
  description = "Private DNS name of the bastion host"
  value       = module.bastion.private_dns
}

output "instance_state" {
  description = "State of the bastion host instance"
  value       = module.bastion.instance_state
}

# Security group details
output "security_group_id" {
  description = "ID of the security group attached to the bastion host"
  value       = module.ec2_security_group.security_group_id
}

output "security_group_arn" {
  description = "ARN of the security group attached to the bastion host"
  value       = module.ec2_security_group.security_group_arn
}

# SSH key details
output "key_name" {
  description = "Name of the SSH key pair used by the bastion host"
  value       = local.ssh_key_name
}

output "ssh_public_key" {
  description = "Public SSH key content"
  value       = local.should_create_key ? tls_private_key.ec2_ssh[0].public_key_openssh : var.ssh_public_key
  sensitive   = false
}

# IAM details
output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile attached to the bastion host"
  value       = aws_iam_instance_profile.bastion_instance_profile.name
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile attached to the bastion host"
  value       = aws_iam_instance_profile.bastion_instance_profile.arn
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the bastion host"
  value       = aws_iam_role.bastion_host_iam_role.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the bastion host"
  value       = aws_iam_role.bastion_host_iam_role.arn
}

# VPC Endpoints
output "vpc_endpoints_created" {
  description = "Whether VPC endpoints were created"
  value       = var.create_vpc_endpoints
}

output "vpc_endpoint_security_group_id" {
  description = "Security group ID for VPC endpoints"
  value       = var.create_vpc_endpoints ? module.vpc_endpoint_security_group[0].security_group_id : null
}

output "ssm_vpc_endpoint_id" {
  description = "ID of the SSM VPC endpoint"
  value       = var.create_vpc_endpoints ? try(module.ssm_vpc_endpoint[0].endpoints["ssm"]["id"], null) : null
}

output "ec2messages_vpc_endpoint_id" {
  description = "ID of the EC2 Messages VPC endpoint"
  value       = var.create_vpc_endpoints ? try(module.ec2messages_vpc_endpoint[0].endpoints["ec2messages"]["id"], null) : null
}

output "ssmmessages_vpc_endpoint_id" {
  description = "ID of the SSM Messages VPC endpoint"
  value       = var.create_vpc_endpoints ? try(module.ssmmessages_vpc_endpoint[0].endpoints["ssmmessages"]["id"], null) : null
}

# CloudWatch Log Group
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.bastion[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.bastion[0].arn : null
}
