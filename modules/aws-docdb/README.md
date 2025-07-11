# AWS DocumentDB Module

Terraform module that creates a complete Amazon DocumentDB (MongoDB-compatible) cluster with integrated secrets management, security hardening, and production-ready configurations.

## Key Features

This custom module provides comprehensive DocumentDB cluster management:

- **🔐 Integrated Secrets Management**: Secure credential storage in AWS Secrets Manager
- **📋 SSM Parameter Integration**: Automatic creation of SSM parameters for cluster connection details
- **🛡️ Security Hardening**: Encryption at rest, TLS configuration, and security group management
- **📊 Enhanced Monitoring**: CloudWatch logging integration and cluster parameter optimization
- **⚙️ Production-Ready Defaults**: Opinionated backup, maintenance, and performance configurations
- **🏷️ Consistent Tagging**: Standardized tag structure across all cluster resources
- **🔧 Flexible Scaling**: Easy cluster instance scaling with configurable instance classes

## Usage

```hcl
module "db" {
  source = "../../modules/aws-docdb"

  name = "examples-docdb-cluster"

  vpc_id       = module.vpc.vpc_id
  subnet_group = module.vpc.database_subnet_group

  db_name            = "db_name"
  db_master_username = "db_master_username"

  instance_class = "db.t3.medium"
  cluster_size   = 2

  # SSM Parameters (enabled by default)
  create_ssm_parameters = true
}
```

## AWS Secrets Manager Integration

The module automatically creates an AWS Secrets Manager secret containing DocumentDB credentials. This feature can be controlled with the `create_secret` variable (enabled by default).

### Created Secret

When `create_secret = true`, a secret is created containing:

- `username` - Master username for the DocumentDB cluster
- `password` - Master password for the DocumentDB cluster

The secret name follows the pattern: `{secret_prefix}-credentials`

### Custom Secret Prefix

You can customize the secret name using the `secret_prefix` variable:

```hcl
module "docdb" {
  source = "../../modules/aws-docdb"

  name = "my-docdb-cluster"
  secret_prefix = "myapp/production/docdb"
  
  # ... other configuration
}
```

If not specified, the secret prefix defaults to `{name}/docdb`.

## SSM Parameters

The module automatically creates SSM parameters for easy retrieval of DocumentDB cluster connection details. This feature can be controlled with the `create_ssm_parameters` variable (enabled by default).

### Created Parameters

When `create_ssm_parameters = true`, the following SSM parameters are created:

- `/{name}/cluster_endpoint` - Writer endpoint for the cluster
- `/{name}/cluster_reader_endpoint` - Read-only endpoint for the cluster
- `/{name}/cluster_identifier` - DocumentDB cluster identifier
- `/{name}/cluster_arn` - Amazon Resource Name (ARN) of the cluster
- `/{name}/port` - Port on which the cluster accepts connections (27017)
- `/{name}/engine` - Database engine (docdb)
- `/{name}/engine_version` - Engine version
- `/{name}/master_username` - Master username (SecureString)
- `/{name}/security_group_id` - ID of the security group
- `/{name}/cluster_resource_id` - DocumentDB cluster resource ID

When both `create_ssm_parameters = true` and `create_secret = true`, additional parameters are created:

- `/{name}/connection_secret_arn` - ARN of the connection secret in Secrets Manager
- `/{name}/connection_secret_name` - Name of the connection secret in Secrets Manager

### Custom SSM Prefix

You can customize the SSM parameter prefix using the `ssm_parameter_prefix` variable:

```hcl
module "docdb" {
  source = "../../modules/aws-docdb"

  name = "my-docdb-cluster"
  ssm_parameter_prefix = "/myapp/production/docdb"
  
  # ... other configuration
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

## Resources

| Name | Type |
|------|------|
| [aws_docdb_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster) | resource |
| [aws_docdb_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance) | resource |
| [aws_docdb_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
