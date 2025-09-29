# Examples

This directory contains example configurations for the `aws-data-lake-encryption` module.

## Available Examples

### basic/

A basic example demonstrating KMS keys and IAM permission boundaries without CloudTrail logging.

**Features demonstrated:**
- S3 and Glue KMS keys with aliases
- IAM permission boundary for data lake jobs
- Basic security controls
- Key rotation enabled

**Usage:**
```bash
cd basic/
terraform init
terraform plan
terraform apply
```

### with-cloudtrail/

An advanced example showing full security controls including CloudTrail audit logging.

**Features demonstrated:**
- S3 and Glue KMS keys with full configuration
- IAM permission boundary with extended controls
- CloudTrail logging for KMS key usage
- S3 bucket creation for audit logs
- Production-ready security settings

**Usage:**
```bash
cd with-cloudtrail/
terraform init
terraform plan
terraform apply
```

## General Usage

Each example is a complete Terraform configuration:

1. Navigate to the desired example directory
2. Review and modify the configuration as needed
3. Initialize Terraform: `terraform init`
4. Plan the deployment: `terraform plan`
5. Apply the changes: `terraform apply`

## Integration with Other Modules

This module provides encryption keys that can be used with:
- `aws-data-lake-infrastructure` (for S3 bucket encryption)
- `aws-glue-catalog` (for Glue database encryption)

See the respective module documentation for integration patterns.
- `aws-glue-catalog` (for Glue encryption)

## Next Steps

After creating the encryption resources:
1. Verify KMS keys appear in AWS Console
2. Test key permissions with S3 and Glue services
3. Review CloudTrail logs for key usage
4. Use the keys in other data lake modules
