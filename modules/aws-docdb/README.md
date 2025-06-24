# AWS DocumentDB Module

Terraform module that creates a complete Amazon DocumentDB (MongoDB-compatible) cluster with integrated secrets management, security hardening, and production-ready configurations.

## Key Features

This custom module provides comprehensive DocumentDB cluster management:

- **🔐 Integrated Secrets Management**: Secure credential storage in AWS Systems Manager Parameter Store
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
