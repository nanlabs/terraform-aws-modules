# AWS Glue Jobs Terraform Module

This Terraform module creates AWS Glue Jobs with associated IAM roles, S3 bucket for scripts, and CloudWatch log groups. It follows AWS best practices and uses official terraform-aws-modules for S3 and IAM resources.

## Features

- ✅ **AWS Glue v5.0** support with configurable versions
- ✅ **Terraform AWS Modules** integration for S3 and IAM
- ✅ **Flexible Job Configuration** using `for_each` pattern
- ✅ **Security Best Practices** with least privilege IAM
- ✅ **CloudWatch Integration** with automatic log groups
- ✅ **S3 Versioning** for script version control
- ✅ **Cost Optimization** with S3 lifecycle rules
- ✅ **Encryption Support** for S3 and CloudWatch Logs

## Architecture

This module implements the separation of infrastructure and ETL code as recommended by AWS best practices:

- **Terraform manages**: Glue Jobs, IAM roles, S3 buckets, CloudWatch logs
- **External CI/CD manages**: ETL script deployment to S3
- **S3 versioning**: Enables rollback without Terraform state changes

## Usage

### Basic Example

```hcl
module "glue_jobs" {
  source = "../../modules/aws/aws-glue-jobs"

  name = "dwh-prod"

  glue_jobs = {
    data_ingestion = {
      description   = "Daily data ingestion from external sources"
      command = {
        script_location = "s3://my-scripts-bucket/jobs/data_ingestion.py"
      }
      worker_type     = "G.2X"
      number_of_workers = 4
      default_arguments = {
        "--source-database" = "external_db"
        "--target-bucket"   = "s3://my-data-lake/"
      }
    }
  }

  tags = {
    Project = "DataPlatform"
    Owner   = "DataTeam"
  }
}
```

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs) by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation in the [MODULE.md](./docs/MODULE.md) file.
  }
}
```

### Advanced Example with Multiple Jobs

```hcl
module "glue_jobs" {
  source = "../../modules/aws/aws-glue-jobs"

  namespace   = "analytics"
  environment = "staging"

  # Use existing S3 bucket for scripts
  create_s3_bucket         = false
  existing_s3_bucket_name  = "analytics-shared-scripts"

  # Grant access to data buckets
  data_bucket_arns = [
    "arn:aws:s3:::raw-data-bucket",
    "arn:aws:s3:::processed-data-bucket"
  ]

  glue_jobs = {
    data_validation = {
      description       = "Validate incoming data quality"
      glue_version     = "5.0"
      worker_type      = "G.1X"
      number_of_workers = 2
      timeout          = 60
      max_retries      = 1

      command = {
        name            = "glueetl"
        script_location = "s3://analytics-shared-scripts/validation/data_quality.py"
        python_version  = "3"
      }

      default_arguments = {
        "--enable-metrics"        = ""
        "--enable-spark-ui"       = ""
        "--data-source"          = "s3://raw-data-bucket/"
        "--validation-rules"     = "s3://analytics-shared-scripts/config/rules.json"
      }
    }

    data_transformation = {
      description         = "Transform and aggregate data"
      glue_version       = "5.0"
      worker_type        = "G.2X"
      number_of_workers  = 6
      max_concurrent_runs = 2

      command = {
        script_location = "s3://analytics-shared-scripts/etl/transform.py"
      }

      connections = ["redshift-connection"]

      default_arguments = {
        "--job-bookmark-option"   = "job-bookmark-enable"
        "--enable-job-insights"   = ""
        "--source-path"          = "s3://raw-data-bucket/validated/"
        "--target-path"          = "s3://processed-data-bucket/aggregated/"
      }
    }

    python_shell_job = {
      description = "Lightweight Python script for metadata extraction"

      command = {
        name            = "pythonshell"
        script_location = "s3://analytics-shared-scripts/metadata/extract.py"
        python_version  = "3.9"
      }

      # Python shell jobs use max_capacity instead of worker_type
      max_capacity = 0.0625
      timeout      = 30
    }
  }

  # Enhanced logging configuration
  log_retention_days    = 30
  cloudwatch_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  tags = {
    Environment = "staging"
    Project     = "Analytics"
    CostCenter  = "data-platform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| glue_execution_role | terraform-aws-modules/iam/aws//modules/iam-assumable-role | n/a |
| glue_scripts_bucket | terraform-aws-modules/s3-bucket/aws | n/a |

## Resources

| Name | Type |
|------|------|
| aws_cloudwatch_log_group.glue_jobs | resource |
| aws_glue_job.this | resource |
| aws_iam_role_policy.glue_cloudwatch_logs | resource |
| aws_iam_role_policy.glue_data_access | resource |
| aws_iam_role_policy.glue_s3_access | resource |
| aws_caller_identity.current | data source |
| aws_region.current | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name (e.g., 'dev', 'staging', 'prod') | `string` | n/a | yes |
| glue_jobs | Map of Glue jobs to create | `map(object)` | `{}` | yes |
| namespace | Namespace for resource naming (e.g., 'dwh', 'analytics') | `string` | n/a | yes |
| cloudwatch_kms_key_id | KMS key ID for CloudWatch Logs encryption | `string` | `null` | no |
| create_s3_bucket | Whether to create a new S3 bucket for Glue scripts | `bool` | `true` | no |
| data_bucket_arns | List of S3 bucket ARNs that Glue jobs need access to for data processing | `list(string)` | `[]` | no |
| existing_s3_bucket_name | Name of existing S3 bucket to use for Glue scripts (when create_s3_bucket is false) | `string` | `null` | no |
| force_destroy | Whether to allow destruction of S3 bucket with objects (use with caution in production) | `bool` | `false` | no |
| log_retention_days | Number of days to retain CloudWatch logs for Glue jobs | `number` | `14` | no |
| max_session_duration | Maximum session duration for the Glue execution role (in seconds) | `number` | `3600` | no |
| s3_bucket_name | Name of the S3 bucket for Glue scripts. If not provided, will be auto-generated | `string` | `null` | no |
| s3_kms_key_id | KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| s3_lifecycle_rules | S3 bucket lifecycle rules for cost optimization | `any` | See variables.tf | no |
| tags | A map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| common_tags | Common tags applied to all resources |
| glue_execution_role_arn | ARN of the Glue execution IAM role |
| glue_execution_role_id | ID of the Glue execution IAM role |
| glue_execution_role_name | Name of the Glue execution IAM role |
| glue_job_arns | ARNs of the created Glue jobs |
| glue_job_ids | IDs of the created Glue jobs |
| glue_job_names | Names of the created Glue jobs |
| glue_jobs_summary | Summary of created Glue jobs with their key configuration |
| log_group_arns | ARNs of the CloudWatch log groups for Glue jobs |
| log_group_names | Names of the CloudWatch log groups for Glue jobs |
| resource_prefix | Resource prefix used for naming |
| scripts_bucket_arn | ARN of the S3 bucket used for Glue scripts |
| scripts_bucket_domain_name | Domain name of the S3 bucket used for Glue scripts |
| scripts_bucket_id | ID of the S3 bucket used for Glue scripts |
| scripts_bucket_name | Name of the S3 bucket used for Glue scripts |
| scripts_bucket_regional_domain_name | Regional domain name of the S3 bucket used for Glue scripts |

## Best Practices

### 1. Separate Infrastructure from Code

This module follows AWS best practices by separating infrastructure provisioning (Terraform) from code deployment (CI/CD):

- Use this module to create Glue Jobs with fixed `script_location` paths
- Deploy your Python/PySpark scripts via separate CI/CD pipeline to S3
- Enable S3 versioning for script rollback without Terraform changes

### 2. Security Configuration

```hcl
# Use KMS encryption for sensitive data
module "glue_jobs" {
  # ... other configuration

  s3_kms_key_id         = aws_kms_key.glue.arn
  cloudwatch_kms_key_id = aws_kms_key.glue.arn
}
```

### 3. Cost Optimization

```hcl
# Configure appropriate worker types and lifecycle rules
glue_jobs = {
  small_job = {
    worker_type       = "G.1X"    # For small datasets
    number_of_workers = 2
  }

  large_job = {
    worker_type       = "G.2X"    # For larger datasets
    number_of_workers = 10
  }
}

# S3 lifecycle rules are included by default
s3_lifecycle_rules = [
  {
    id     = "delete_old_versions"
    status = "Enabled"
    noncurrent_version_expiration = {
      days = 90
    }
  }
]
```

### 4. Monitoring and Observability

```hcl
glue_jobs = {
  monitored_job = {
    default_arguments = {
      "--enable-metrics"                = ""
      "--enable-spark-ui"              = ""
      "--enable-job-insights"          = ""
      "--enable-observability-metrics" = ""
      "--enable-continuous-cloudwatch-log" = "true"
    }

    # Get notified when job completes
    notify_delay_after = 5  # minutes
  }
}
```

## Glue Job Types

### ETL Jobs (glueetl)

For PySpark ETL jobs processing large datasets:

```hcl
etl_job = {
  command = {
    name = "glueetl"  # Default
    script_location = "s3://bucket/etl/transform.py"
  }
  worker_type       = "G.2X"
  number_of_workers = 4
}
```

### Python Shell Jobs (pythonshell)

For lightweight Python scripts:

```hcl
shell_job = {
  command = {
    name = "pythonshell"
    script_location = "s3://bucket/shell/process.py"
    python_version  = "3.9"
  }
  max_capacity = 0.0625  # Use max_capacity instead of workers
}
```

### Streaming Jobs (gluestreaming)

For real-time data processing:

```hcl
streaming_job = {
  command = {
    name = "gluestreaming"
    script_location = "s3://bucket/streaming/process.py"
  }
  worker_type       = "G.1X"
  number_of_workers = 2
}
```

## Integration Examples

### With Data Lake Architecture

```hcl
# S3 buckets for data lake
module "data_lake" {
  source = "terraform-aws-modules/s3-bucket/aws"
  # ... configuration
}

# Glue jobs for data processing
module "glue_jobs" {
  source = "../../modules/aws/aws-glue-jobs"

  data_bucket_arns = [
    module.data_lake.s3_bucket_arn
  ]

  glue_jobs = {
    ingest = {
      script_location = "s3://${module.glue_jobs.scripts_bucket_name}/ingest.py"
      default_arguments = {
        "--target-bucket" = module.data_lake.s3_bucket_id
      }
    }
  }
}
```

### With AWS Glue Catalog

```hcl
# Glue Catalog Database
resource "aws_glue_catalog_database" "this" {
  name = "${local.resource_prefix}-catalog"
}

# Glue jobs with catalog integration
module "glue_jobs" {
  source = "../../modules/aws/aws-glue-jobs"

  glue_jobs = {
    catalog_etl = {
      script_location = "s3://bucket/catalog-etl.py"
      default_arguments = {
        "--enable-glue-datacatalog" = ""
        "--database-name"           = aws_glue_catalog_database.this.name
      }
    }
  }
}
```

## License

This module is licensed under the MIT License. See [LICENSE](LICENSE) for full details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.
