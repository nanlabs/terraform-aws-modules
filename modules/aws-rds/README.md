# AWS RDS Instance Module

Terraform module that provides an opinionated wrapper around the terraform-aws-modules RDS module with integrated secrets management, enhanced monitoring, and production-ready defaults.

## Why This Wrapper Exists

This wrapper adds significant value over using the base terraform-aws-modules RDS directly:

- **🔐 Integrated Secrets Management**: Stores database credentials securely in AWS Systems Manager Parameter Store for easy retrieval by applications
- **📊 Enhanced Monitoring**: Pre-configured Performance Insights, CloudWatch monitoring, and backup settings optimized for production workloads
- **🛡️ Security Hardening**: Encryption at rest enabled by default, proper IAM role configuration for monitoring
- **⚙️ Production-Ready Defaults**: Opinionated settings for backup retention, maintenance windows, and logging
- **🏷️ Consistent Tagging**: Standardized tag structure across all RDS resources
- **🔧 Simplified Interface**: Reduced complexity while maintaining access to all important configuration options

## Usage

```hcl
module "db" {
  source = "../../modules/aws-rds"

  name = "examples-rds-instance"

  vpc_id          = "vpc-1234567890"
  db_subnet_group = "db-subnet-group-1234567890"

  db_name            = "db_name"
  db_master_username = "db_master_username"
  db_port            = 5432

  db_instance_class       = "db.t2.micro"
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
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | 6.1.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.db_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
