# Outputs are now split into separate files:
# - shared-outputs.tf: Common outputs used across modules
# - bastion-outputs.tf: Bastion-specific outputs

# Legacy outputs file - outputs have been moved to the new structure

# SSM Parameter Outputs
output "ssm_parameter_names" {
  description = "Names of the created SSM parameters for bastion host details"
  value = var.create_ssm_parameters ? {
    instance_id           = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/instance_id"
    instance_private_ip   = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/instance_private_ip"
    security_group_id     = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/security_group_id"
    subnet_id             = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/subnet_id"
    vpc_endpoints_created = "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/vpc_endpoints_created"
    ssh_private_key       = local.should_create_key ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/ssh_private_key" : null
    ssh_public_key        = (local.should_create_key || local.should_use_provided_key) ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/ssh_public_key" : null
    key_name              = local.ssh_key_name != null ? "${var.ssm_parameter_prefix != "" ? var.ssm_parameter_prefix : "/${var.name}"}/key_name" : null
  } : {}
}
