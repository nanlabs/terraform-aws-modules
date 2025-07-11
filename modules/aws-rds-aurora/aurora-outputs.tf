# Aurora Cluster Outputs
# Legacy compatibility outputs (commonly used)
output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.db.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.db.cluster_reader_endpoint
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.db.cluster_id
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.db.cluster_arn
}

output "cluster_port" {
  description = "The database port"
  value       = module.db.cluster_port
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.db.cluster_database_name
}

output "cluster_master_username" {
  description = "The database master username"
  value       = module.db.cluster_master_username
  sensitive   = true
}

# Additional Cluster Information
output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.db.cluster_resource_id
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = module.db.cluster_hosted_zone_id
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.db.cluster_engine_version_actual
}

output "cluster_ca_certificate_identifier" {
  description = "CA identifier of the CA certificate used for the DB instance's server certificate"
  value       = module.db.cluster_ca_certificate_identifier
}

output "cluster_ca_certificate_valid_till" {
  description = "Expiration date of the DB instance's server certificate"
  value       = module.db.cluster_ca_certificate_valid_till
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = module.db.cluster_members
}

# Cluster Instances
output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.db.cluster_instances
}

# Custom Endpoints
output "additional_cluster_endpoints" {
  description = "A map of additional cluster endpoints and their attributes"
  value       = module.db.additional_cluster_endpoints
}

# Security
output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.db.security_group_id
}

# Subnet Group
output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = module.db.db_subnet_group_name
}

# Parameter Groups
output "db_cluster_parameter_group_arn" {
  description = "The ARN of the DB cluster parameter group created"
  value       = module.db.db_cluster_parameter_group_arn
}

output "db_cluster_parameter_group_id" {
  description = "The ID of the DB cluster parameter group created"
  value       = module.db.db_cluster_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the DB parameter group created"
  value       = module.db.db_parameter_group_arn
}

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group created"
  value       = module.db.db_parameter_group_id
}

# Enhanced Monitoring
output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the enhanced monitoring role"
  value       = module.db.enhanced_monitoring_iam_role_arn
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the enhanced monitoring role"
  value       = module.db.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_unique_id" {
  description = "Stable and unique string identifying the enhanced monitoring role"
  value       = module.db.enhanced_monitoring_iam_role_unique_id
}

# CloudWatch Log Groups
output "db_cluster_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db.db_cluster_cloudwatch_log_groups
}

# Master User Secret
output "cluster_master_user_secret" {
  description = "The generated database master user secret when manage_master_user_password is set to true"
  value       = module.db.cluster_master_user_secret
  sensitive   = true
}

output "cluster_master_password" {
  description = "The database master password"
  value       = module.db.cluster_master_password
  sensitive   = true
}

output "db_cluster_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.db.db_cluster_secretsmanager_secret_rotation_enabled
}

# Activity Stream
output "db_cluster_activity_stream_kinesis_stream_name" {
  description = "The name of the Amazon Kinesis data stream to be used for the database activity stream"
  value       = module.db.db_cluster_activity_stream_kinesis_stream_name
}

# IAM Role Associations
output "cluster_role_associations" {
  description = "A map of IAM roles associated with the cluster and their attributes"
  value       = module.db.cluster_role_associations
}

# Aurora Limitless (Shard Group)
output "db_shard_group_arn" {
  description = "ARN of the shard group"
  value       = module.db.db_shard_group_arn
}

output "db_shard_group_endpoint" {
  description = "The connection endpoint for the DB shard group"
  value       = module.db.db_shard_group_endpoint
}

output "db_shard_group_resource_id" {
  description = "The AWS Region-unique, immutable identifier for the DB shard group"
  value       = module.db.db_shard_group_resource_id
}

# SSM Parameter Outputs
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for Aurora cluster details"
  value = var.create_ssm_parameters ? {
    cluster_endpoint               = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_endpoint"
    cluster_reader_endpoint        = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_reader_endpoint"
    cluster_database_name          = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_database_name"
    cluster_port                   = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_port"
    cluster_master_username        = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_master_username"
    cluster_master_user_secret_arn = var.manage_master_user_password ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_master_user_secret_arn" : null
    cluster_arn                    = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_arn"
    cluster_resource_id            = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_resource_id"
    cluster_engine_version_actual  = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_engine_version_actual"
    security_group_id              = var.create_security_group ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/security_group_id" : null
  } : {}
}
