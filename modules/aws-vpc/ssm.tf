# SSM Parameters for VPC details and network configuration
locals {
  ssm_prefix = var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"

  # Conditions based on module variables to avoid creating SSM parameters with empty values
  create_database_subnets_ssm           = var.create_ssm_parameters && length(var.database_subnets) > 0
  create_database_subnet_group_ssm      = var.create_ssm_parameters && var.create_database_subnet_group && length(var.database_subnets) > 0
  create_database_subnet_group_name_ssm = var.create_ssm_parameters && var.create_database_subnet_group && length(var.database_subnets) > 0 && var.database_subnet_group_name != null
  create_public_subnets_ssm             = var.create_ssm_parameters && length(var.public_subnets) > 0
  create_private_subnets_ssm            = var.create_ssm_parameters && length(var.private_subnets) > 0
  create_internet_gateway_ssm           = var.create_ssm_parameters && var.create_igw
  create_nat_gateway_ssm                = var.create_ssm_parameters && var.enable_nat_gateway && length(var.private_subnets) > 0 && length(var.public_subnets) > 0
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
  count = local.create_database_subnets_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnets"
  type  = "StringList"
  value = join(",", module.vpc.database_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "database_subnet_group" {
  count = local.create_database_subnet_group_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnet_group"
  type  = "String"
  value = module.vpc.database_subnet_group

  tags = var.tags
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  count = local.create_database_subnet_group_name_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/database_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name

  tags = var.tags
}

resource "aws_ssm_parameter" "public_subnets" {
  count = local.create_public_subnets_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/public_subnets"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "private_subnets" {
  count = local.create_private_subnets_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/private_subnets"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)

  tags = var.tags
}

resource "aws_ssm_parameter" "app_subnets" {
  count = local.create_private_subnets_ssm ? 1 : 0

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
  count = local.create_internet_gateway_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/internet_gateway_id"
  type  = "String"
  value = module.vpc.igw_id

  tags = var.tags
}

resource "aws_ssm_parameter" "nat_gateway_ids" {
  count = local.create_nat_gateway_ssm ? 1 : 0

  name  = "${local.ssm_prefix}/nat_gateway_ids"
  type  = "StringList"
  value = join(",", module.vpc.natgw_ids)

  tags = var.tags
}
