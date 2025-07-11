# SSM Parameters for Aurora cluster endpoints and connection details
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"
}

resource "aws_ssm_parameter" "cluster_endpoint" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_endpoint"
  type  = "String"
  value = module.db.cluster_endpoint

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_reader_endpoint" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_reader_endpoint"
  type  = "String"
  value = module.db.cluster_reader_endpoint

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_database_name" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_database_name"
  type  = "String"
  value = module.db.cluster_database_name

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_port" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_port"
  type  = "String"
  value = tostring(module.db.cluster_port)

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_master_username" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_master_username"
  type  = "SecureString"
  value = module.db.cluster_master_username

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_master_user_secret_arn" {
  count = var.create_ssm_parameters && var.manage_master_user_password ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_master_user_secret_arn"
  type  = "String"
  value = module.db.cluster_master_user_secret.arn

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_arn" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_arn"
  type  = "String"
  value = module.db.cluster_arn

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_resource_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_resource_id"
  type  = "String"
  value = module.db.cluster_resource_id

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_engine_version_actual" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_engine_version_actual"
  type  = "String"
  value = module.db.cluster_engine_version_actual

  tags = var.tags
}

resource "aws_ssm_parameter" "security_group_id" {
  count = var.create_ssm_parameters && var.create_security_group ? 1 : 0

  name  = "${local.ssm_prefix}/security_group_id"
  type  = "String"
  value = module.db.security_group_id

  tags = var.tags
}
