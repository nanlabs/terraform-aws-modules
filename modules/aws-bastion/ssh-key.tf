# SSH Key Management for Bastion Host
locals {
  should_create_key       = var.create_ssh_key && var.key_name == ""
  should_use_provided_key = var.ssh_public_key != "" && var.key_name == ""
}

# Generate a new SSH key pair if requested and no existing key is specified
resource "tls_private_key" "ec2_ssh" {
  count = local.should_create_key ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    prevent_destroy = true
  }
}

# Create AWS key pair from generated key
resource "aws_key_pair" "ec2_ssh" {
  count = local.should_create_key ? 1 : 0

  key_name   = "${var.name}-ec2-ssh-key"
  public_key = tls_private_key.ec2_ssh[0].public_key_openssh

  tags = merge(var.tags, {
    Name = "${var.name}-ssh-key"
  })
}

# Create AWS key pair from provided public key
resource "aws_key_pair" "ec2_ssh_provided" {
  count = local.should_use_provided_key ? 1 : 0

  key_name   = "${var.name}-ec2-ssh-key"
  public_key = var.ssh_public_key

  tags = merge(var.tags, {
    Name = "${var.name}-ssh-key"
  })
}
