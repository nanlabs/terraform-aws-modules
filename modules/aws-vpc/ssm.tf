# SSM Parameters for VPC details and network configuration
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"
}

resource "aws_ssm_parameter" "vpc_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_ssm_parameter" "vpc_cidr_block" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/vpc_cidr_block"
  type  = "String"
  value = module.vpc.vpc_cidr_block

  tags = var.tags
}

resource "aws_ssm_parameter" "database_subnets" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnets"
  type  = "StringList"
  value = join(",", try(module.vpc.database_subnets, []))

  tags = var.tags
}

resource "aws_ssm_parameter" "database_subnet_group" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnet_group"
  type  = "String"
  value = try(module.vpc.database_subnet_group, "")

  tags = var.tags
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnet_group_name"
  type  = "String"
  value = try(module.vpc.database_subnet_group_name, "")

  tags = var.tags
}

resource "aws_ssm_parameter" "public_subnets" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/public_subnets"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "private_subnets" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/private_subnets"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "app_subnets" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/app_subnets"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "app_security_group" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/app_security_group"
  type  = "String"
  value = module.app_security_group.security_group_id

  tags = var.tags
}

resource "aws_ssm_parameter" "availability_zones" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/availability_zones"
  type  = "StringList"
  value = join(",", module.vpc.azs)

  tags = var.tags
}

resource "aws_ssm_parameter" "internet_gateway_id" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/internet_gateway_id"
  type  = "String"
  value = try(module.vpc.igw_id, "")

  tags = var.tags
}

resource "aws_ssm_parameter" "nat_gateway_ids" {
  count = var.create_ssm_parameters ? 1 : 0

  name  = "${local.ssm_prefix}/nat_gateway_ids"
  type  = "StringList"
  value = join(",", try(module.vpc.natgw_ids, []))

  tags = var.tags
}
