# AWS Data Lake Encryption Module

This module creates KMS keys and IAM policies for data lake encryption and service isolation, implementing the security requirements for Ticket 2.

## Features

- 🔐 **Service-Specific KMS Keys**: Separate keys for S3 and Glue services
- 🔄 **Automatic Key Rotation**: Enabled by default for enhanced security
- 🛡️ **IAM Permission Boundaries**: Restrict permissions for data lake jobs
- 📊 **KMS Usage Logging**: CloudTrail logging for audit and compliance
- 🔗 **Cross-Service Integration**: Proper service permissions for Glue accessing S3
- 🏷️ **Consistent Tagging**: Automated tagging for all security resources

## Architecture

```text
Data Lake Encryption:
├── S3 KMS Key
│   ├── Allows S3 service access
│   ├── Allows Glue service access (for S3 via Glue)
│   └── alias/{prefix}-s3
├── Glue KMS Key
│   ├── Allows Glue service access
│   └── alias/{prefix}-glue
├── IAM Permission Boundary
│   ├── Data lake specific permissions
│   ├── KMS access restrictions
│   └── Service isolation controls
└── CloudTrail KMS Logging
    └── Audit trail for key usage
```

## Usage

### Basic Usage

```hcl
module "data_lake_encryption" {
  source = "../../../../modules/aws/aws-data-lake-encryption"

  name = local.resource_prefix  # e.g., "dwh-wl-workloads-data-lake-develop"
  tags = local.tags

  # Use centralized logging bucket
  cloudtrail_bucket_name = "dwh-sec-log-archive-cloudtrail-logs"
}
```

### Advanced Configuration

```hcl
module "data_lake_encryption" {
  source = "../../../../modules/aws/aws-data-lake-encryption"

  name = local.resource_prefix
  tags = local.tags

  # KMS Configuration
  kms_deletion_window = 30           # Extended deletion window for production
  enable_key_rotation = true

  # Security Controls
  create_permission_boundary = true
  enable_kms_logging         = true
  cloudtrail_bucket_name     = "dwh-sec-log-archive-cloudtrail-logs"

  # Custom allowed services
  allowed_services = [
    "s3.amazonaws.com",
    "glue.amazonaws.com",
    "athena.amazonaws.com"
  ]
}
```

## Security Features

### KMS Key Policies

**S3 KMS Key**:

- Root account full access
- S3 service encryption/decryption access
- Glue service access for S3 operations
- Restricted to same region

**Glue KMS Key**:

- Root account full access
- Glue service encryption/decryption access
- Restricted to same region

### IAM Permission Boundary

The permission boundary enforces:

**Allowed Actions**:

- S3 operations on data lake buckets only
- KMS operations on data lake keys only
- Glue Catalog operations on data lake databases only
- CloudWatch Logs for monitoring

**Denied Actions**:

- IAM role/policy modifications
- KMS key creation/deletion
- S3 bucket policy modifications
- Cross-account access

### CloudTrail Logging

Tracks all KMS operations for:

- Key usage patterns
- Access attempts
- Compliance auditing
- Security monitoring

## Integration with Other Modules

### With aws-data-lake-infrastructure

```hcl
module "data_lake_encryption" {
  source = "../../../../modules/aws/aws-data-lake-encryption"
  name   = local.resource_prefix
  tags   = local.tags
}

module "data_lake_infrastructure" {
  source = "../../../../modules/aws/aws-data-lake-infrastructure"

  name        = local.resource_prefix
  tags        = local.tags
  kms_key_arn = module.data_lake_encryption.s3_kms_key_arn
}
```

### With aws-glue-catalog

```hcl
module "glue_catalog" {
  source = "../../../../modules/aws/aws-glue-data-lake-catalog"

  database_prefix   = local.resource_prefix
  tags             = local.tags
  enable_encryption = true
  kms_key_arn      = module.data_lake_encryption.glue_kms_key_arn
}
```

## Compliance & Security

### Encryption at Rest

✅ **S3 Buckets**: Encrypted with dedicated KMS key
✅ **Glue Catalog**: Encrypted with dedicated KMS key
✅ **Key Rotation**: Automatic rotation enabled
✅ **Cross-Service**: Proper service permissions

### Access Control

✅ **Permission Boundaries**: IAM restrictions enforced
✅ **Service Isolation**: Keys scoped to specific services
✅ **Least Privilege**: Minimal required permissions
✅ **Audit Trail**: All key usage logged

### Documentation Requirements

✅ **Key Policies**: Documented in module
✅ **Permission Boundaries**: Documented in module
✅ **Service Access**: Cross-service integration documented
✅ **Audit Logging**: CloudTrail configuration documented

## Cost Optimization

- **KMS Keys**: Only 2 keys created (S3 + Glue)
- **Key Rotation**: Included in KMS pricing
- **CloudTrail**: Uses existing centralized bucket
- **Permission Boundaries**: No additional cost

## Best Practices

1. **Use Centralized Logging**: Point to log-archive account bucket
2. **Enable Rotation**: Keep automatic rotation enabled
3. **Apply Boundaries**: Use permission boundaries for all data lake roles
4. **Monitor Usage**: Review CloudTrail logs regularly
5. **Test Access**: Validate cross-service access works correctly

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs)
by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation [here](./docs/MODULE.md).

## Inputs

| Name                             | Description                          | Type           | Default          | Required |
| -------------------------------- | ------------------------------------ | -------------- | ---------------- | :------: |
| name                             | The name prefix for resources        | `string`       | n/a              |   yes    |
| tags                             | A map of tags to assign to resources | `map(string)`  | `{}`             |    no    |
| kms_deletion_window              | KMS key deletion window in days      | `number`       | `7`              |    no    |
| enable_key_rotation              | Enable automatic KMS key rotation    | `bool`         | `true`           |    no    |
| create_permission_boundary       | Create IAM permission boundary       | `bool`         | `true`           |    no    |
| enable_kms_logging               | Enable CloudTrail KMS logging        | `bool`         | `true`           |    no    |
| cloudtrail_bucket_name           | S3 bucket for CloudTrail logs        | `string`       | `null`           |    no    |
| allowed_services                 | AWS services allowed KMS access      | `list(string)` | See variables.tf |    no    |
| additional_kms_policy_statements | Additional KMS policy statements     | `list(any)`    | `[]`             |    no    |

## Outputs

| Name                     | Description                        |
| ------------------------ | ---------------------------------- |
| s3_kms_key_arn           | ARN of the S3 KMS key              |
| glue_kms_key_arn         | ARN of the Glue KMS key            |
| permission_boundary_arn  | ARN of the IAM permission boundary |
| encryption_configuration | Complete encryption configuration  |
| service_kms_keys         | Service-to-KMS key mapping         |

## Compliance & Security

### Encryption at Rest

✅ **S3 Buckets**: Encrypted with dedicated KMS key
✅ **Glue Catalog**: Encrypted with dedicated KMS key
✅ **Key Rotation**: Automatic rotation enabled
✅ **Cross-Service**: Proper service permissions

### Access Control

✅ **Permission Boundaries**: IAM restrictions enforced
✅ **Service Isolation**: Keys scoped to specific services
✅ **Least Privilege**: Minimal required permissions
✅ **Audit Trail**: All key usage logged

### Documentation Requirements

✅ **Key Policies**: Documented in module
✅ **Permission Boundaries**: Documented in module
✅ **Service Access**: Cross-service integration documented
✅ **Audit Logging**: CloudTrail configuration documented

## Cost Optimization

- **KMS Keys**: Only 2 keys created (S3 + Glue)
- **Key Rotation**: Included in KMS pricing
- **CloudTrail**: Uses existing centralized bucket
- **Permission Boundaries**: No additional cost

## Best Practices

1. **Use Centralized Logging**: Point to log-archive account bucket
2. **Enable Rotation**: Keep automatic rotation enabled
3. **Apply Boundaries**: Use permission boundaries for all data lake roles
4. **Monitor Usage**: Review CloudTrail logs regularly
5. **Test Access**: Validate cross-service access works correctly

## Requirements

- Terraform >= 1.0
- AWS Provider >= 6.0
- Appropriate AWS permissions for KMS and IAM management
- Existing CloudTrail S3 bucket (for KMS logging)
