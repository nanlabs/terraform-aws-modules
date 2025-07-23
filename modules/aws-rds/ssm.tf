# SSM Parameters for RDS instance details and connection information
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"

  # Conditions to avoid creating SSM parameters with empty or null values
  create_db_name_ssm = var.create_ssm_parameters && var.db_name != null && var.db_name != ""
}

resource "aws_ssm_parameter" "address" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/address"
  type  = "String"
  value = module.db.db_instance_address

  tags = var.tags
}

resource "aws_ssm_parameter" "endpoint" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/endpoint"
  type  = "String"
  value = module.db.db_instance_endpoint

  tags = var.tags
}

resource "aws_ssm_parameter" "name" {
  count = local.create_db_name_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/db_name"
  type  = "String"
  value = module.db.db_instance_name

  tags = var.tags
}

resource "aws_ssm_parameter" "port" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/port"
  type  = "String"
  value = tostring(module.db.db_instance_port)

  tags = var.tags
}

resource "aws_ssm_parameter" "engine" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/engine"
  type  = "String"
  value = module.db.db_instance_engine

  tags = var.tags
}

resource "aws_ssm_parameter" "engine_version_actual" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/engine_version_actual"
  type  = "String"
  value = module.db.db_instance_engine_version_actual

  tags = var.tags
}

resource "aws_ssm_parameter" "master_username" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/master_username"
  type  = "SecureString"
  value = module.db.db_instance_username

  tags = var.tags
}

resource "aws_ssm_parameter" "master_user_secret_arn" {
  count = var.create_ssm_parameters && var.manage_master_user_password ? 1 : 0

  name  = "${local.ssm_prefix}/master_user_secret_arn"
  type  = "String"
  value = module.db.db_instance_master_user_secret_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "arn" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/arn"
  type  = "String"
  value = module.db.db_instance_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "resource_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/resource_id"
  type  = "String"
  value = module.db.db_instance_resource_id

  tags = var.tags
}

resource "aws_ssm_parameter" "availability_zone" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/availability_zone"
  type  = "String"
  value = module.db.db_instance_availability_zone

  tags = var.tags
}
