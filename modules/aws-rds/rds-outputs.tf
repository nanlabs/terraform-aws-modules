# RDS Instance
# Legacy compatibility outputs (commonly used)
output "db_instance_endpoint" {
  description = "The RDS instance connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.db.db_instance_identifier
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.db_instance_arn
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.db_instance_name
}

# Additional RDS Instance outputs
output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.db_instance_availability_zone
}

output "db_instance_engine" {
  description = "The database engine"
  value       = module.db.db_instance_engine
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = module.db.db_instance_engine_version_actual
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db.db_instance_hosted_zone_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db.db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db.db_instance_status
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db.db_instance_username
  sensitive   = true
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = module.db.db_instance_ca_cert_identifier
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = module.db.db_instance_domain
}

output "db_instance_domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials"
  value       = module.db.db_instance_domain_auth_secret_arn
}

output "db_instance_domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers"
  value       = module.db.db_instance_domain_dns_ips
}

output "db_instance_domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of the self managed Active Directory domain"
  value       = module.db.db_instance_domain_fqdn
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = module.db.db_instance_domain_iam_role_name
}

output "db_instance_domain_ou" {
  description = "The self managed Active Directory organizational unit for your DB instance to join"
  value       = module.db.db_instance_domain_ou
}

# DB Subnet Group
output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db.db_subnet_group_arn
}

# DB Parameter Group
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db.db_parameter_group_arn
}

# DB Option Group
output "db_option_group_id" {
  description = "The db option group id"
  value       = module.db.db_option_group_id
}

output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.db.db_option_group_arn
}

# Enhanced Monitoring
output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = module.db.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = module.db.enhanced_monitoring_iam_role_arn
}

# Master User Secret
output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db.db_instance_master_user_secret_arn
}

# CloudWatch Log Group
output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db.db_instance_cloudwatch_log_groups
}

# Secrets Manager Secret Rotation
output "db_instance_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.db.db_instance_secretsmanager_secret_rotation_enabled
}

# Listener Endpoint (for SQL Server Always On)
output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = module.db.db_listener_endpoint
}

# Role Associations
output "db_instance_role_associations" {
  description = "A map of DB Instance Identifiers and IAM Role ARNs separated by a comma"
  value       = module.db.db_instance_role_associations
}

# SSM Parameter Outputs
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for RDS instance details"
  value = var.create_ssm_parameters ? {
    address                = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/address"
    endpoint               = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/endpoint"
    db_name                = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/db_name"
    port                   = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/port"
    engine                 = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/engine"
    engine_version_actual  = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/engine_version_actual"
    master_username        = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/master_username"
    master_user_secret_arn = var.manage_master_user_password ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/master_user_secret_arn" : null
    arn                    = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/arn"
    resource_id            = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/resource_id"
    availability_zone      = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/availability_zone"
  } : {}
}
