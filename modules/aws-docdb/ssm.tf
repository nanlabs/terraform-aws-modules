# SSM Parameters for DocumentDB cluster connection details
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"
}

resource "aws_ssm_parameter" "cluster_endpoint" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_endpoint"
  type  = "String"
  value = aws_docdb_cluster.this.endpoint

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_reader_endpoint" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_reader_endpoint"
  type  = "String"
  value = aws_docdb_cluster.this.reader_endpoint

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_identifier" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_identifier"
  type  = "String"
  value = aws_docdb_cluster.this.cluster_identifier

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_arn" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_arn"
  type  = "String"
  value = aws_docdb_cluster.this.arn

  tags = var.tags
}

resource "aws_ssm_parameter" "port" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/port"
  type  = "String"
  value = tostring(var.port)

  tags = var.tags
}

resource "aws_ssm_parameter" "engine" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/engine"
  type  = "String"
  value = var.engine

  tags = var.tags
}

resource "aws_ssm_parameter" "engine_version" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/engine_version"
  type  = "String"
  value = var.engine_version

  tags = var.tags
}

resource "aws_ssm_parameter" "master_username" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/master_username"
  type  = "SecureString"
  value = local.username

  tags = var.tags
}

resource "aws_ssm_parameter" "connection_secret_arn" {
  count = var.create_ssm_parameters && var.create_secret ? 1 : 0

  name  = "${local.ssm_prefix}/connection_secret_arn"
  type  = "String"
  value = aws_secretsmanager_secret.secret[0].arn

  tags = var.tags
}

resource "aws_ssm_parameter" "connection_secret_name" {
  count = var.create_ssm_parameters && var.create_secret ? 1 : 0

  name  = "${local.ssm_prefix}/connection_secret_name"
  type  = "String"
  value = aws_secretsmanager_secret.secret[0].name

  tags = var.tags
}

resource "aws_ssm_parameter" "security_group_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/security_group_id"
  type  = "String"
  value = module.security_group.security_group_id

  tags = var.tags
}

resource "aws_ssm_parameter" "cluster_resource_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/cluster_resource_id"
  type  = "String"
  value = aws_docdb_cluster.this.cluster_resource_id

  tags = var.tags
}
