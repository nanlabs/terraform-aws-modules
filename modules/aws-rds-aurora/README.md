# AWS RDS Aurora Module

Terraform module that provides a fully customizable wrapper around the terraform-aws-modules RDS Aurora module, exposing all available configuration options while providing sensible defaults.

## Features

- **🎛️ Full Customization**: Exposes all variables from the underlying module, making it completely configurable
- **⚡ Serverless v2 Support**: Support for Aurora Serverless v2 with configurable scaling parameters
- **📊 Monitoring & Logging**: Performance Insights, CloudWatch monitoring, and comprehensive logging options
- **🛡️ Security**: Configurable encryption, IAM roles, and security group management
- **🔧 Production-Ready**: Backup configurations, maintenance windows, and cluster management options
- **📋 SSM Integration**: Automatic creation of SSM parameters for cluster connection details
- **🏷️ Flexible Tagging**: Support for global and cluster-specific tagging strategies

## File Structure

This module follows a standardized structure for better organization:

- `variables.tf` - Shared variables (tags, naming, SSM parameters, etc.)
- `aurora-variables.tf` - All Aurora-specific configuration variables
- `outputs.tf` - Shared outputs
- `aurora-outputs.tf` - All Aurora-specific outputs from the underlying module
- `ssm.tf` - SSM parameter resources for cluster connection details

## Usage

```hcl
module "aurora_cluster" {
  source = "../../modules/aws-rds-aurora"

  # Shared variables
  name = "my-aurora-cluster"
  tags = {
    Environment = "dev"
    Team        = "platform"
  }

  # Aurora-specific configuration
  engine          = "aurora-postgresql"
  engine_version  = "15.4"
  
  vpc_id             = "vpc-1234567890"
  db_subnet_group_name = "my-db-subnet-group"
  
  master_username = "postgres"
  database_name   = "myapp"
  
  instances = {
    one = {
      instance_class = "db.serverless"
    }
    two = {
      instance_class = "db.serverless"
    }
  }
  
  serverlessv2_scaling_configuration = {
    max_capacity = 2.0
    min_capacity = 0.5
  }
  
  # SSM Parameters (enabled by default)
  create_ssm_parameters = true
}
```

## SSM Parameters

The module automatically creates SSM parameters for easy retrieval of Aurora cluster connection details. This feature can be controlled with the `create_ssm_parameters` variable (enabled by default).

### Created Parameters

When `create_ssm_parameters = true`, the following SSM parameters are created:

- `/{name}/cluster_endpoint` - Writer endpoint for the cluster
- `/{name}/cluster_reader_endpoint` - Read-only endpoint for the cluster  
- `/{name}/cluster_database_name` - Name of the created database
- `/{name}/cluster_port` - Port on which the cluster accepts connections
- `/{name}/cluster_master_username` - Master username (SecureString)
- `/{name}/cluster_master_user_secret_arn` - ARN of the master user secret (if `manage_master_user_password = true`)
- `/{name}/cluster_arn` - Amazon Resource Name (ARN) of the cluster
- `/{name}/cluster_resource_id` - Cluster resource ID
- `/{name}/cluster_engine_version_actual` - Running version of the cluster
- `/{name}/security_group_id` - ID of the security group (if `create_security_group = true`)

### Custom SSM Prefix

You can customize the SSM parameter prefix using the `ssm_parameter_prefix` variable:

```hcl
module "aurora_cluster" {
  source = "../../modules/aws-rds-aurora"

  name = "my-aurora-cluster"
  ssm_parameter_prefix = "/myapp/production/aurora"
  
  # ... other configuration
}
```

### Retrieving SSM Parameters

You can retrieve these parameters in other parts of your infrastructure:

```hcl
data "aws_ssm_parameter" "aurora_endpoint" {
  name = "/my-aurora-cluster/cluster_endpoint"
}

resource "aws_instance" "app" {
  # Use the Aurora endpoint in your application
  user_data = <<-EOF
    #!/bin/bash
    echo "AURORA_ENDPOINT=${data.aws_ssm_parameter.aurora_endpoint.value}" >> /etc/environment
  EOF
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | 9.15.0 |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
