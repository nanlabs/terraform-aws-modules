# AWS RDS Module

Complete Terraform wrapper around the official `terraform-aws-modules/rds/aws` module with opinionated defaults and enhanced functionality.

## Why This Wrapper Exists

This wrapper adds significant value over using the base terraform-aws-modules RDS directly:

- **🔧 Complete Wrapper**: Exposes ALL variables from the underlying module with sensible defaults
- **🛡️ Security Defaults**: Encryption enabled, secure passwords, proper monitoring
- **📊 Enhanced Monitoring**: Performance Insights, CloudWatch logs, enhanced monitoring
- **💾 Parameter Store Integration**: Stores RDS connection info in AWS Systems Manager
- **🏷️ Consistent Tagging**: Standardized tag structure across all RDS resources
- **🔧 Simplified Usage**: Simple configuration for common use cases

## Usage

### Simple Usage (Recommended)

```hcl
module "rds" {
  source = "../../modules/aws-rds"
  
  name = "my-app-db"
  tags = {
    Environment = "production"
    Team        = "backend"
  }
  
  # Basic required configuration
  engine          = "postgres"
  engine_version  = "16.3"
  instance_class  = "db.t4g.micro"
  
  # Network
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group
}
```

### Advanced Usage (Full Customization)

```hcl
module "rds" {
  source = "../../modules/aws-rds"
  
  # Shared variables
  name = "my-production-db"
  tags = { Environment = "production" }
  
  # Engine Configuration
  engine               = "postgres"
  engine_version       = "16.3"
  family              = "postgres16"
  major_engine_version = "16"
  instance_class      = "db.r6g.large"
  
  # Storage Configuration
  allocated_storage     = 100
  max_allocated_storage = 1000
  storage_encrypted     = true
  storage_type         = "gp3"
  
  # Database Configuration
  db_name  = "myapp"
  username = "dbadmin"
  manage_master_user_password = true
  
  # Network Configuration
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group
  multi_az              = true
  
  # Backup Configuration
  backup_retention_period = 14
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # Monitoring
  performance_insights_enabled = true
  monitoring_interval          = 60
  create_monitoring_role       = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  
  # Custom parameters
  parameters = [
    {
      name  = "shared_preload_libraries"
      value = "pg_stat_statements"
    }
  ]
}
```

## Module Structure

This module follows our standardized pattern:

- `variables.tf` - Shared variables (name, tags)
- `rds-variables.tf` - All RDS-specific variables (complete wrapper)
- `rds.tf` - RDS module implementation
- `outputs.tf` - Shared outputs (name, common endpoints, SSM parameters)
- `rds-outputs.tf` - All RDS-specific outputs (complete wrapper)

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
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | 6.11.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.rds_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_database_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

See `rds-variables.tf` for the complete list of variables. Key variables include:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine | `string` | `null` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | `null` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | `null` | no |

## Outputs

See `rds-outputs.tf` for the complete list of outputs. Key outputs include:

| Name | Description |
|------|-------------|
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The RDS instance connection endpoint |
| <a name="output_db_instance_identifier"></a> [db\_instance\_identifier](#output\_db\_instance\_identifier) | The RDS instance identifier |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | The ARN of the RDS instance |

## Common Use Cases

### PostgreSQL Database

```hcl
module "postgres_db" {
  source = "../../modules/aws-rds"
  
  name = "my-postgres"
  
  engine               = "postgres"
  engine_version       = "16.3"
  family              = "postgres16"
  major_engine_version = "16"
  instance_class      = "db.t4g.micro"
  
  allocated_storage = 20
  storage_encrypted = true
  
  db_name  = "myapp"
  username = "postgres"
  manage_master_user_password = true
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group
}
```

### MySQL Database

```hcl
module "mysql_db" {
  source = "../../modules/aws-rds"
  
  name = "my-mysql"
  
  engine               = "mysql"
  engine_version       = "8.0.39"
  family              = "mysql8.0"
  major_engine_version = "8.0"
  instance_class      = "db.t4g.micro"
  
  allocated_storage = 20
  storage_encrypted = true
  
  db_name  = "myapp"
  username = "admin"
  manage_master_user_password = true
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group
}
