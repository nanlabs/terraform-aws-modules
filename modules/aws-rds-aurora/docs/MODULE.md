<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.89.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | 9.15.0 |

## Resources

No resources.

## File Structure

This module is organized with the following structure:

- **variables.tf** - Shared variables (name, tags, etc.)
- **aurora-variables.tf** - All Aurora-specific configuration variables from the underlying module
- **outputs.tf** - Shared outputs
- **aurora-outputs.tf** - All Aurora-specific outputs from the underlying module
- **rds.tf** - Main module implementation

This structure allows for:

- Clear separation between shared and module-specific configurations
- Full exposure of all underlying module capabilities
- Easy maintenance and updates
- Consistent patterns across all wrapper modules

## Inputs

This module exposes all variables from the underlying terraform-aws-modules/rds-aurora/aws module (v9.15.0), providing complete configurability.

### Shared Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the Aurora cluster | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

### Aurora-Specific Variables

All variables from the [terraform-aws-modules/rds-aurora/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest) module are available. Key variables include:

- **engine** - Aurora engine (aurora-mysql, aurora-postgresql)
- **engine_version** - Engine version to use
- **instances** - Map of cluster instances and their configurations
- **vpc_id** - VPC ID where the cluster will be created
- **db_subnet_group_name** - DB subnet group name
- **master_username** - Master username for the cluster
- **database_name** - Name of the database to create
- **serverlessv2_scaling_configuration** - Serverless v2 scaling configuration
- **performance_insights_enabled** - Enable Performance Insights
- **monitoring_interval** - Monitoring interval for enhanced monitoring
- **backup_retention_period** - Backup retention period
- **backup_window** - Backup window
- **maintenance_window** - Maintenance window
- **security_group_rules** - Security group rules to create

For a complete list of all available variables, refer to the [terraform-aws-modules/rds-aurora documentation](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest?tab=inputs).

## Outputs

This module exposes all outputs from the underlying terraform-aws-modules/rds-aurora/aws module (v9.15.0).

### Shared Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Amazon Resource Name (ARN) of cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Writer endpoint for the cluster |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | A read-only endpoint for the cluster |

### Aurora-Specific Outputs

All outputs from the [terraform-aws-modules/rds-aurora/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest) module are available. Key outputs include:

- **cluster_database_name** - Name for an automatically created database
- **cluster_engine_version_actual** - Running version of the cluster
- **cluster_instances** - Cluster instances
- **cluster_master_user_secret** - Generated master user secret when `manage_master_user_password` is set to `true`
- **cluster_master_username** - Master username for the cluster
- **cluster_port** - Port on which the cluster accepts connections
- **cluster_resource_id** - Cluster resource ID
- **cluster_members** - List of instances that are part of this cluster
- **db_cluster_cloudwatch_log_groups** - Map of CloudWatch log groups created and their attributes
- **security_group_id** - ID of the security group created
- **enhanced_monitoring_iam_role_arn** - ARN of the IAM role for enhanced monitoring

For a complete list of all available outputs, refer to the [terraform-aws-modules/rds-aurora documentation](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/latest?tab=outputs).

<!-- END_TF_DOCS -->