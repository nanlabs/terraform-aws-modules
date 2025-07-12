# Local variables for the bastion host configuration
locals {
  ssh_key_name = var.key_name != "" ? var.key_name : (var.create_ssh_key ? (
    local.should_create_key ? aws_key_pair.ec2_ssh[0].key_name : (
      local.should_use_provided_key ? aws_key_pair.ec2_ssh_provided[0].key_name : null
    )
  ) : null)

  # User data for bastion host configuration
  user_data = base64encode(file("${path.module}/templates/cloud-init.yml.tpl"))
}

# CloudWatch Log Group for bastion host logs
resource "aws_cloudwatch_log_group" "bastion" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  name              = "/aws/ec2/bastion/${var.name}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name}-logs"
  })
}

# EC2 instance for the bastion host
module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = var.name

  ami                  = var.ami != "" ? var.ami : data.aws_ami.ubuntu.image_id
  instance_type        = var.instance_type
  key_name             = local.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.id
  user_data_base64     = local.user_data

  subnet_id              = element(var.private_subnets, 0)
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]

  root_block_device = {
    delete_on_termination = true
    encrypted             = var.root_volume_encrypted
    type                  = var.root_volume_type
    size                  = var.root_volume_size
  }

  tags = var.tags
}
