locals {
  # v10 moved instance-level settings into the instances map; re-apply our
  # top-level defaults to entries that don't set them explicitly
  aurora_instance_defaults = {
    publicly_accessible     = var.publicly_accessible
    db_parameter_group_name = var.db_parameter_group_name
  }

  instances = {
    for k, v in var.instances : k => merge(v, {
      for attr, default in local.aurora_instance_defaults : attr => default
      if try(v[attr], null) == null && default != null
    })
  }
}

module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "10.4.0"

  # Control flags
  create = var.create

  # Identifier and naming
  name                    = var.name != "" ? "${var.name}-rds-aurora" : "rds-aurora"
  cluster_use_name_prefix = var.cluster_use_name_prefix

  # Engine Configuration
  engine                      = var.engine
  engine_mode                 = var.engine_mode
  engine_version              = var.engine_version
  engine_lifecycle_support    = var.engine_lifecycle_support
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade

  # Instance Configuration (v10: single cluster-wide class + per-instance map)
  cluster_instance_class = var.db_cluster_instance_class != null ? var.db_cluster_instance_class : (
    var.instance_class != "" ? var.instance_class : null
  )
  instances                       = local.instances
  instances_use_identifier_prefix = var.instances_use_identifier_prefix

  # Database Configuration (v10: write-only master password)
  database_name              = var.database_name
  master_username            = var.master_username
  master_password_wo         = var.manage_master_user_password ? null : var.master_password
  master_password_wo_version = var.manage_master_user_password ? null : var.master_password_wo_version
  port                       = var.port

  # Password Management
  manage_master_user_password                            = var.manage_master_user_password
  master_user_secret_kms_key_id                          = var.master_user_secret_kms_key_id
  manage_master_user_password_rotation                   = var.manage_master_user_password_rotation
  master_user_password_rotate_immediately                = var.master_user_password_rotate_immediately
  master_user_password_rotation_automatically_after_days = var.master_user_password_rotation_automatically_after_days
  master_user_password_rotation_duration                 = var.master_user_password_rotation_duration
  master_user_password_rotation_schedule_expression      = var.master_user_password_rotation_schedule_expression

  # Storage Configuration
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  storage_type      = var.storage_type
  allocated_storage = var.allocated_storage
  iops              = var.iops

  # Multi-AZ Configuration
  cluster_members                          = var.cluster_members
  cluster_db_instance_parameter_group_name = var.db_cluster_db_instance_parameter_group_name

  # Network Configuration
  vpc_id                 = var.vpc_id
  subnets                = var.subnets
  db_subnet_group_name   = var.db_subnet_group_name
  create_db_subnet_group = var.create_db_subnet_group
  vpc_security_group_ids = var.vpc_security_group_ids
  network_type           = var.network_type
  availability_zones     = var.availability_zones

  # Security Group Configuration (v10: structured ingress/egress rule maps)
  create_security_group          = var.create_security_group
  security_group_name            = var.security_group_name
  security_group_use_name_prefix = var.security_group_use_name_prefix
  security_group_description     = var.security_group_description
  security_group_ingress_rules = {
    for k, v in var.security_group_rules : k => {
      for attr, val in v : attr => val if attr != "type"
    } if try(v.type, "ingress") == "ingress"
  }
  security_group_egress_rules = {
    for k, v in var.security_group_rules : k => {
      for attr, val in v : attr => val if attr != "type"
    } if try(v.type, "ingress") == "egress"
  }
  security_group_tags = var.security_group_tags

  # Backup and Maintenance
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.final_snapshot_identifier
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  delete_automated_backups     = var.delete_automated_backups
  backtrack_window             = var.backtrack_window

  # Snapshot and Restore
  snapshot_identifier           = var.snapshot_identifier
  replication_source_identifier = var.replication_source_identifier
  source_region                 = var.source_region
  restore_to_point_in_time      = var.restore_to_point_in_time
  s3_import                     = var.s3_import

  # Monitoring and Performance (v10: cluster-level only; per-instance via instances map)
  monitoring_role_arn           = var.monitoring_role_arn
  create_monitoring_role        = var.create_monitoring_role
  iam_role_name                 = var.iam_role_name
  iam_role_use_name_prefix      = var.iam_role_use_name_prefix
  iam_role_description          = var.iam_role_description
  iam_role_path                 = var.iam_role_path
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_max_session_duration = var.iam_role_max_session_duration

  # Cluster-level monitoring (legacy instance-level vars fold in when explicitly set)
  cluster_monitoring_interval = var.monitoring_interval != 0 ? var.monitoring_interval : var.cluster_monitoring_interval

  # Performance Insights
  cluster_performance_insights_enabled          = var.performance_insights_enabled != null ? var.performance_insights_enabled : var.cluster_performance_insights_enabled
  cluster_performance_insights_kms_key_id       = var.performance_insights_kms_key_id != null ? var.performance_insights_kms_key_id : var.cluster_performance_insights_kms_key_id
  cluster_performance_insights_retention_period = var.performance_insights_retention_period != null ? var.performance_insights_retention_period : var.cluster_performance_insights_retention_period
  database_insights_mode                        = var.database_insights_mode

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_skip_destroy      = var.cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_class             = var.cloudwatch_log_group_class
  cloudwatch_log_group_tags              = var.cloudwatch_log_group_tags

  # Security and Authentication
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  deletion_protection                 = var.deletion_protection
  apply_immediately                   = var.apply_immediately

  # Active Directory
  domain               = var.domain
  domain_iam_role_name = var.domain_iam_role_name

  # Certificate (v10: cluster-level only; per-instance via instances map)
  cluster_ca_cert_identifier = var.ca_cert_identifier != null ? var.ca_cert_identifier : var.cluster_ca_cert_identifier

  # Global Cluster
  global_cluster_identifier      = var.global_cluster_identifier
  enable_global_write_forwarding = var.enable_global_write_forwarding
  is_primary_cluster             = var.is_primary_cluster
  enable_local_write_forwarding  = var.enable_local_write_forwarding

  # Serverless Configuration
  scaling_configuration              = var.scaling_configuration
  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  enable_http_endpoint               = var.enable_http_endpoint

  # Autoscaling
  autoscaling_enabled            = var.autoscaling_enabled
  autoscaling_max_capacity       = var.autoscaling_max_capacity
  autoscaling_min_capacity       = var.autoscaling_min_capacity
  autoscaling_policy_name        = var.autoscaling_policy_name
  autoscaling_scale_in_cooldown  = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown = var.autoscaling_scale_out_cooldown
  autoscaling_target_cpu         = var.autoscaling_target_cpu
  autoscaling_target_connections = var.autoscaling_target_connections
  predefined_metric_type         = var.predefined_metric_type

  # Parameter Groups (v10: single object per group, null disables creation)
  cluster_parameter_group_name = var.db_cluster_parameter_group_name
  cluster_parameter_group = var.create_db_cluster_parameter_group ? {
    name            = var.db_cluster_parameter_group_name
    use_name_prefix = var.db_cluster_parameter_group_use_name_prefix
    description     = var.db_cluster_parameter_group_description
    family          = var.db_cluster_parameter_group_family
    parameters      = var.db_cluster_parameter_group_parameters
  } : null

  db_parameter_group = var.create_db_parameter_group ? {
    name            = var.db_parameter_group_name
    use_name_prefix = var.db_parameter_group_use_name_prefix
    description     = var.db_parameter_group_description
    family          = var.db_parameter_group_family
    parameters      = var.db_parameter_group_parameters
  } : null

  # Custom Endpoints
  endpoints = var.endpoints

  # Activity Stream (v10: single object, null disables creation)
  cluster_activity_stream = var.create_db_cluster_activity_stream ? {
    kms_key_id           = var.db_cluster_activity_stream_kms_key_id
    mode                 = var.db_cluster_activity_stream_mode
    include_audit_fields = var.engine_native_audit_fields_included
  } : null

  # IAM Roles (v10 renamed iam_roles to role_associations; same shape)
  role_associations = var.iam_roles

  # Aurora Limitless
  cluster_scalability_type = var.cluster_scalability_type

  # Shard Group - Aurora Limitless (v10: single object, null disables creation)
  shard_group = var.create_shard_group ? {
    identifier         = var.db_shard_group_identifier
    compute_redundancy = var.compute_redundancy
    max_acu            = var.max_acu
    min_acu            = var.min_acu
    tags               = var.shard_group_tags
    timeouts           = length(var.shard_group_timeouts) > 0 ? var.shard_group_timeouts : null
  } : null

  # Timeouts
  cluster_timeouts  = var.cluster_timeouts
  instance_timeouts = var.instance_timeouts

  # Tags
  cluster_tags = var.cluster_tags
  tags         = var.tags
}
