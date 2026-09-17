data "aws_vpc" "main" {
  id = var.vpc_id
}

# One-time v5 -> v6 state adoption (sg module rewrite): keeps the live SG
# instead of replacing it, so outputs stay known during the migration apply
moved {
  from = module.security_group.aws_security_group.this_name_prefix[0]
  to   = module.security_group.aws_security_group.this[0]
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = "${var.name}-docdb-security-group"
  description = "Security group for ${var.name}-docdb"
  vpc_id      = var.vpc_id

  ingress_rules = {
    docdb = {
      from_port   = var.port
      to_port     = var.port
      ip_protocol = "tcp"
      description = "DocumentDB access from within VPC"
      cidr_ipv4   = data.aws_vpc.main.cidr_block
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # v6 no longer adds an implicit Name tag; preserve v5 behavior explicitly
  tags = merge(var.tags, {
    Name = "${var.name}-docdb-security-group"
  })
}
