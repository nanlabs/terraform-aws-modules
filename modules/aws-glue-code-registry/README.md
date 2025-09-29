# AWS Glue Code Registry Module

This Terraform module creates and manages AWS Glue Code Registry infrastructure for centralized management of code libraries, JAR files, and dependencies used by Glue jobs.

## Features

- **Centralized Code Storage**: S3 bucket for storing JAR files, Python wheels, and other code dependencies
- **Version Management**: S3 versioning enabled for code artifact management
- **IAM Integration**: Optional IAM role for secure access to code artifacts
- **CloudWatch Monitoring**: Optional CloudWatch logs for registry monitoring
- **S3 Notifications**: Optional notifications for code artifact uploads
- **Cost Optimization**: Configurable S3 lifecycle rules
- **Security**: KMS encryption support for S3 and CloudWatch

## Usage

### Basic Usage

```hcl
module "glue_code_registry" {
  source = "../../modules/aws/aws-glue-code-registry"

  name = "data-platform"

  tags = {
    Environment = "production"
    Project     = "data-warehouse"
  }
}
```

### Advanced Usage

```hcl
module "glue_code_registry" {
  source = "../../modules/aws/aws-glue-code-registry"

  name = "data-platform"

  # S3 Configuration
  s3_bucket_name = "my-glue-code-artifacts"
  s3_kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # Additional S3 buckets for external libraries
  additional_s3_bucket_arns = [
    "arn:aws:s3:::external-libraries-bucket",
    "arn:aws:s3:::third-party-connectors"
  ]

  # CloudWatch Configuration
  enable_cloudwatch_logging = true
  log_retention_days        = 30
  cloudwatch_kms_key_id     = "arn:aws:kms:us-east-1:123456789012:key/87654321-4321-4321-4321-210987654321"

  # S3 Notifications
  enable_s3_notifications = true
  s3_notification_configurations = [
    {
      id            = "jar-upload-notification"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".jar"
    },
    {
      id            = "python-wheel-notification"
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = ".whl"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "data-warehouse"
  }
}
```

### Using Existing S3 Bucket

```hcl
module "glue_code_registry" {
  source = "../../modules/aws/aws-glue-code-registry"

  name = "data-platform"

  # Use existing bucket
  create_s3_bucket        = false
  existing_s3_bucket_name = "existing-code-artifacts-bucket"

  tags = {
    Environment = "production"
    Project     = "data-warehouse"
  }
}
```

## Integration with Glue Jobs

This module is designed to work alongside the `aws-glue-jobs` module:

```hcl
# Code Registry
module "glue_code_registry" {
  source = "../../modules/aws/aws-glue-code-registry"

  name = "data-platform"
  tags = local.tags
}

# Glue Jobs using the code registry
module "glue_jobs" {
  source = "../../modules/aws/aws-glue-jobs"

  name = "data-platform"

  glue_jobs = {
    "data-transformation" = {
      description = "Transform raw data using custom libraries"
      command = {
        script_location = "s3://${module.glue_code_registry.code_artifacts_bucket_name}/scripts/transform.py"
      }
      default_arguments = {
        "--extra-jars" = "s3://${module.glue_code_registry.code_artifacts_bucket_name}/jars/custom-connector.jar"
        "--extra-py-files" = "s3://${module.glue_code_registry.code_artifacts_bucket_name}/wheels/data-utils.whl"
      }
    }
  }

  tags = local.tags
}
```

## Code Artifact Management

### Directory Structure

Organize your code artifacts in the S3 bucket:

```
s3://your-code-artifacts-bucket/
├── jars/
│   ├── custom-connector-v1.0.0.jar
│   ├── database-driver-v2.1.0.jar
│   └── spark-extensions-v3.0.0.jar
├── wheels/
│   ├── data-utils-v1.2.0.whl
│   ├── custom-transformers-v2.0.0.whl
│   └── validation-library-v1.5.0.whl
├── scripts/
│   ├── etl/
│   │   ├── transform.py
│   │   └── validate.py
│   └── utilities/
│       ├── common.py
│       └── helpers.py
└── dependencies/
    ├── requirements.txt
    └── external-libs/
```

### Version Management

The module enables S3 versioning, allowing you to:

- Upload new versions of libraries without breaking existing jobs
- Roll back to previous versions if needed
- Maintain multiple versions for different environments

## Security Considerations

- **Least Privilege**: IAM role includes only necessary permissions
- **Encryption**: Support for KMS encryption on S3 and CloudWatch
- **Access Control**: Bucket policies restrict public access
- **Monitoring**: CloudWatch logs for audit trails

## Cost Optimization

The module includes lifecycle rules to:

- Delete old non-current versions after 90 days
- Clean up incomplete multipart uploads after 7 days
- Customize rules based on your retention requirements

<!-- BEGIN_TF_DOCS -->
## Detailed Documentation

For detailed documentation including all variables, outputs, and examples, see [docs/MODULE.md](./docs/MODULE.md).
<!-- END_TF_DOCS -->

## Contributing

When contributing to this module, please:

1. Follow the established patterns from other modules
2. Update documentation using `terraform-docs`
3. Test changes in a non-production environment
4. Follow the organization's tagging strategy
