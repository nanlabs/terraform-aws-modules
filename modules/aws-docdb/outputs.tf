output "master_username" {
  value       = local.username
  description = "Username for the master DB user."
}

output "master_password" {
  value       = local.password
  description = "password for the master DB user."
  sensitive   = true
}

output "cluster_name" {
  value       = aws_docdb_cluster.this.*.cluster_identifier
  description = "Cluster Identifier."
}

output "arn" {
  value       = aws_docdb_cluster.this.*.arn
  description = "Amazon Resource Name (ARN) of the cluster."
}

output "writer_endpoint" {
  value       = aws_docdb_cluster.this.*.endpoint
  description = "Endpoint of the DocumentDB cluster."
}

output "reader_endpoint" {
  value       = aws_docdb_cluster.this.*.reader_endpoint
  description = "A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas."
}

output "connection_secret_name" {
  description = "The name of the AWS Secrets Manager secret created"
  value       = var.create_secret ? aws_secretsmanager_secret.secret[0].name : null
}

output "connection_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret created"
  value       = var.create_secret ? aws_secretsmanager_secret.secret[0].arn : null
}

# SSM Parameter Outputs
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for DocumentDB cluster details"
  value = var.create_ssm_parameters ? merge({
    cluster_endpoint        = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_endpoint"
    cluster_reader_endpoint = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_reader_endpoint"
    cluster_identifier      = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_identifier"
    cluster_arn             = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_arn"
    port                    = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/port"
    engine                  = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/engine"
    engine_version          = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/engine_version"
    master_username         = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/master_username"
    security_group_id       = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/security_group_id"
    cluster_resource_id     = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/cluster_resource_id"
    }, var.create_secret ? {
    connection_secret_arn  = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/connection_secret_arn"
    connection_secret_name = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/connection_secret_name"
  } : {}) : {}
}

# Direct security group output for easier access
output "security_group_id" {
  description = "ID of the security group associated with the DocumentDB cluster"
  value       = module.security_group.security_group_id
}

# Direct port output for easier access
output "port" {
  description = "DocumentDB port"
  value       = 27017
}
