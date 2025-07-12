# VPC Endpoints for SSM Session Manager
locals {
  vpc_endpoints_subnet_ids = length(var.vpc_endpoints_subnet_ids) > 0 ? var.vpc_endpoints_subnet_ids : var.private_subnets
}

# Security group for VPC endpoints
module "vpc_endpoint_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  count = var.create_vpc_endpoints ? 1 : 0

  name        = "${var.name}-vpc-endpoints"
  description = "Security group for VPC endpoints used by bastion host"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.ec2_security_group.security_group_id
      description              = "HTTPS from bastion host"
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.name}-vpc-endpoints"
  })
}

# SSM VPC Endpoint
module "ssm_vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.21.0"

  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id = var.vpc_id

  endpoints = {
    ssm = {
      service             = "ssm"
      service_type        = "Interface"
      subnet_ids          = local.vpc_endpoints_subnet_ids
      security_group_ids  = [module.vpc_endpoint_security_group[0].security_group_id]
      private_dns_enabled = true
      policy              = var.vpc_endpoint_policy

      tags = merge(var.tags, {
        Name = "${var.name}-ssm-endpoint"
      })
    }
  }

  tags = var.tags
}

# EC2 Messages VPC Endpoint
module "ec2messages_vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.21.0"

  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id = var.vpc_id

  endpoints = {
    ec2messages = {
      service             = "ec2messages"
      service_type        = "Interface"
      subnet_ids          = local.vpc_endpoints_subnet_ids
      security_group_ids  = [module.vpc_endpoint_security_group[0].security_group_id]
      private_dns_enabled = true
      policy              = var.vpc_endpoint_policy

      tags = merge(var.tags, {
        Name = "${var.name}-ec2messages-endpoint"
      })
    }
  }

  tags = var.tags
}

# SSM Messages VPC Endpoint
module "ssmmessages_vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.21.0"

  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id = var.vpc_id

  endpoints = {
    ssmmessages = {
      service             = "ssmmessages"
      service_type        = "Interface"
      subnet_ids          = local.vpc_endpoints_subnet_ids
      security_group_ids  = [module.vpc_endpoint_security_group[0].security_group_id]
      private_dns_enabled = true
      policy              = var.vpc_endpoint_policy

      tags = merge(var.tags, {
        Name = "${var.name}-ssmmessages-endpoint"
      })
    }
  }

  tags = var.tags
}
