# One-time v5 -> v6 state adoption (sg module rewrite): keeps the live SG
# instead of replacing it, so outputs stay known during the migration apply
moved {
  from = module.app_security_group.aws_security_group.this_name_prefix[0]
  to   = module.app_security_group.aws_security_group.this[0]
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = "${var.name}-app-security-group"
  description = "Security group to be used for application servers"
  vpc_id      = module.vpc.vpc_id

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # v6 no longer adds an implicit Name tag; preserve v5 behavior explicitly
  tags = merge(var.tags, {
    Name = "${var.name}-app-security-group"
  })
}
