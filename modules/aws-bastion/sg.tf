# Security group for the bastion host EC2 instance
module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${var.name}-ec2"
  description = "Security group for bastion host EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH from specified CIDR blocks (if any)
  ingress_with_cidr_blocks = length(var.allowed_cidrs) > 0 ? [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = join(",", var.allowed_cidrs)
      description = "SSH access from allowed CIDRs"
    }
  ] : []

  # Allow all outbound traffic
  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.name}-ec2"
  })
}
