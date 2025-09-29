# Examples

This directory contains example configurations for the `aws-data-lake-infrastructure` module.

## Available Examples

### basic/
A basic example that demonstrates the minimum required configuration to create a data lake infrastructure with the standard medallion architecture (bronze, silver, gold, export layers) and Apache Iceberg support.

**Features demonstrated:**
- Standard medallion architecture
- Apache Iceberg configuration
- Basic lifecycle rules
- S3 versioning
- Default S3 encryption

**Usage:**
```bash
cd basic/
terraform init
terraform plan
terraform apply
```

### with-encryption/
An advanced example showing how to use custom KMS encryption and additional data lake layers.

**Features demonstrated:**
- Custom KMS key creation and configuration
- Extended medallion architecture with additional layers
- Enhanced lifecycle rules
- Temporary bucket creation
- Custom retention policies

**Usage:**
```bash
cd with-encryption/
terraform init
terraform plan
terraform apply
```

## General Usage

Each example is a complete Terraform configuration that can be used independently:

1. Navigate to the desired example directory
2. Review and modify the configuration as needed
3. Initialize Terraform: `terraform init`
4. Plan the deployment: `terraform plan`
5. Apply the changes: `terraform apply`

## Customization

All examples can be customized by modifying the variables in `main.tf`. Refer to the module's main documentation for available configuration options.
2. Verify buckets and directory structure in AWS Console
3. Integrate with `aws-glue-catalog` module for database creation
4. Add `aws-data-lake-encryption` module for KMS encryption
