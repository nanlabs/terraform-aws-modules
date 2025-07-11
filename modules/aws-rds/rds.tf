module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  # Control flags
  create_db_instance = var.create_db_instance

  # Identifier
  identifier                     = var.identifier != null ? var.identifier : "${var.name}-rds"
  instance_use_identifier_prefix = var.instance_use_identifier_prefix
  custom_iam_instance_profile    = var.custom_iam_instance_profile

  # Engine Configuration
  engine                   = var.engine
  engine_version           = var.engine_version
  engine_lifecycle_support = var.engine_lifecycle_support
  family                   = var.family
  major_engine_version     = var.major_engine_version
  instance_class           = var.instance_class
  license_model            = var.license_model

  # Storage Configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_throughput    = var.storage_throughput
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  iops                  = var.iops
  dedicated_log_volume  = var.dedicated_log_volume

  # Database Configuration
  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  # Password Management
  manage_master_user_password                           = var.manage_master_user_password
  master_user_secret_kms_key_id                         = var.master_user_secret_kms_key_id
  manage_master_user_password_rotation                  = var.manage_master_user_password_rotation
  master_user_password_rotate_immediately               = var.master_user_password_rotate_immediately
  master_user_password_rotation_automatically_after_days = var.master_user_password_rotation_automatically_after_days
  master_user_password_rotation_duration               = var.master_user_password_rotation_duration
  master_user_password_rotation_schedule_expression    = var.master_user_password_rotation_schedule_expression

  # Network Configuration
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name
  availability_zone       = var.availability_zone
  multi_az                = var.multi_az
  ca_cert_identifier      = var.ca_cert_identifier
  network_type            = var.network_type

  # Backup and Maintenance
  backup_retention_period          = var.backup_retention_period
  backup_window                    = var.backup_window
  maintenance_window               = var.maintenance_window
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  delete_automated_backups         = var.delete_automated_backups

  # Monitoring
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_role_arn
  monitoring_role_name            = var.monitoring_role_name
  monitoring_role_use_name_prefix = var.monitoring_role_use_name_prefix
  monitoring_role_description     = var.monitoring_role_description
  monitoring_role_permissions_boundary = var.monitoring_role_permissions_boundary
  create_monitoring_role          = var.create_monitoring_role
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  database_insights_mode                 = var.database_insights_mode

  # Upgrades and Maintenance
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately

  # Security
  deletion_protection                  = var.deletion_protection
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Active Directory
  domain                 = var.domain
  domain_auth_secret_arn = var.domain_auth_secret_arn
  domain_dns_ips         = var.domain_dns_ips
  domain_fqdn            = var.domain_fqdn
  domain_iam_role_name   = var.domain_iam_role_name
  domain_ou              = var.domain_ou

  # Character Sets (Oracle/SQL Server)
  character_set_name       = var.character_set_name
  nchar_character_set_name = var.nchar_character_set_name
  timezone                 = var.timezone

  # Blue/Green Deployment
  blue_green_update = var.blue_green_update

  # Restore Options
  replicate_source_db       = var.replicate_source_db
  replica_mode              = var.replica_mode
  restore_to_point_in_time  = var.restore_to_point_in_time
  s3_import                 = var.s3_import
  snapshot_identifier       = var.snapshot_identifier
  upgrade_storage_config    = var.upgrade_storage_config

  # Subnet Group
  create_db_subnet_group           = var.create_db_subnet_group
  db_subnet_group_use_name_prefix  = var.db_subnet_group_use_name_prefix
  db_subnet_group_description      = var.db_subnet_group_description
  subnet_ids                       = var.subnet_ids

  # Parameter Group
  create_db_parameter_group       = var.create_db_parameter_group
  parameter_group_name            = var.parameter_group_name
  parameter_group_use_name_prefix = var.parameter_group_use_name_prefix
  parameter_group_description     = var.parameter_group_description
  parameter_group_skip_destroy    = var.parameter_group_skip_destroy
  parameters                      = var.parameters

  # Option Group
  create_db_option_group       = var.create_db_option_group
  option_group_name            = var.option_group_name
  option_group_use_name_prefix = var.option_group_use_name_prefix
  option_group_description     = var.option_group_description
  option_group_skip_destroy    = var.option_group_skip_destroy
  options                      = var.options

  # CloudWatch Log Groups
  create_cloudwatch_log_group                = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days     = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id            = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_skip_destroy          = var.cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_class                 = var.cloudwatch_log_group_class
  cloudwatch_log_group_tags                  = var.cloudwatch_log_group_tags

  # DB Instance Role Associations
  db_instance_role_associations = var.db_instance_role_associations

  # Timeouts
  timeouts              = var.timeouts
  option_group_timeouts = var.option_group_timeouts

  # Tags
  tags                     = var.tags
  db_instance_tags         = var.db_instance_tags
  db_option_group_tags     = var.db_option_group_tags
  db_parameter_group_tags  = var.db_parameter_group_tags
  db_subnet_group_tags     = var.db_subnet_group_tags
}
