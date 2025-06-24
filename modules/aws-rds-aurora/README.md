# AWS RDS Aurora Module

Terraform module that provides an opinionated wrapper around the terraform-aws-modules RDS Aurora module with Serverless v2 optimization, enhanced monitoring, and production-ready clustering.

## Why This Wrapper Exists

This wrapper adds significant value over using the base terraform-aws-modules RDS Aurora directly:

- **⚡ Serverless v2 Optimization**: Pre-configured Serverless v2 scaling with intelligent capacity management for cost efficiency
- **📊 Enhanced Monitoring**: Built-in Performance Insights, CloudWatch monitoring, and backup configurations optimized for Aurora workloads
- **🛡️ Security Hardening**: Encryption at rest, proper IAM role configuration, and secure parameter management
- **🔧 Production-Ready Clustering**: Opinionated cluster configuration with proper backup retention and maintenance windows
- **💰 Cost Optimization**: Intelligent scaling configuration that balances performance and cost for variable workloads
- **🏷️ Consistent Tagging**: Standardized tag structure across all Aurora cluster resources

## Usage

```hcl
module "db" {
  source = "../../modules/aws-rds-aurora"

  name = "examples-rds-aurora"

  vpc_id          = "vpc-1234567890"
  db_subnet_group = "db-subnet-group-1234567890"

  db_name            = "db_name"
  db_master_username = "db_master_username"
  db_port            = 5432

  db_instance_class       = "db.serverless"
  instances = {
    one = {}
    two = {}
  }
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
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds-aurora/aws | 8.3.1 |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
