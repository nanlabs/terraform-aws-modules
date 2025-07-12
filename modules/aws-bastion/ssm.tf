# SSM Parameters for bastion host details
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"
}

# Store the private SSH key in SSM Parameter Store (only if we generated it)
resource "aws_ssm_parameter" "ssh_private_key" {
  count = var.create_ssm_parameters && local.should_create_key ? 1 : 0

  name        = "${local.ssm_prefix}/ssh_private_key"
  type        = "SecureString"
  value       = tls_private_key.ec2_ssh[0].private_key_pem
  description = "Private SSH key for bastion host ${var.name}"

  tags = var.tags
}

# Store the public SSH key in SSM Parameter Store
resource "aws_ssm_parameter" "ssh_public_key" {
  count = var.create_ssm_parameters && (local.should_create_key || local.should_use_provided_key) ? 1 : 0

  name        = "${local.ssm_prefix}/ssh_public_key"
  type        = "String"
  value       = local.should_create_key ? tls_private_key.ec2_ssh[0].public_key_openssh : var.ssh_public_key
  description = "Public SSH key for bastion host ${var.name}"

  tags = var.tags
}

# Store bastion host instance details
resource "aws_ssm_parameter" "instance_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name        = "${local.ssm_prefix}/instance_id"
  type        = "String"
  value       = module.bastion.id
  description = "Instance ID of bastion host ${var.name}"

  tags = var.tags
}

resource "aws_ssm_parameter" "instance_private_ip" {
  count = var.create_ssm_parameters ? 1 : 0

  name        = "${local.ssm_prefix}/instance_private_ip"
  type        = "String"
  value       = module.bastion.private_ip
  description = "Private IP address of bastion host ${var.name}"

  tags = var.tags
}

resource "aws_ssm_parameter" "security_group_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name        = "${local.ssm_prefix}/security_group_id"
  type        = "String"
  value       = module.ec2_security_group.security_group_id
  description = "Security group ID of bastion host ${var.name}"

  tags = var.tags
}

resource "aws_ssm_parameter" "subnet_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name        = "${local.ssm_prefix}/subnet_id"
  type        = "String"
  value       = element(var.private_subnets, 0)
  description = "Subnet ID where bastion host ${var.name} is deployed"

  tags = var.tags
}

resource "aws_ssm_parameter" "key_name" {
  count = var.create_ssm_parameters && local.ssh_key_name != null ? 1 : 0

  name        = "${local.ssm_prefix}/key_name"
  type        = "String"
  value       = local.ssh_key_name
  description = "SSH key pair name for bastion host ${var.name}"

  tags = var.tags
}

# Store VPC endpoint information if created
resource "aws_ssm_parameter" "vpc_endpoints_created" {
  count = var.create_ssm_parameters ? 1 : 0

  name        = "${local.ssm_prefix}/vpc_endpoints_created"
  type        = "String"
  value       = tostring(var.create_vpc_endpoints)
  description = "Whether VPC endpoints were created for bastion host ${var.name}"

  tags = var.tags
}
