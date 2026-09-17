# Security group for the bastion host EC2 instance
module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name        = "${var.name}-ec2"
  description = "Security group for bastion host EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH from specified CIDRs (v6 needs one structured rule per CIDR)
  ingress_rules = {
    for idx, cidr in var.allowed_cidrs : "ssh-${idx}" => {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = cidr
      description = "SSH access from allowed CIDRs"
    }
  }

  # Allow all outbound traffic
  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-ec2"
  })
}
