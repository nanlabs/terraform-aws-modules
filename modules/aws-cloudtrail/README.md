# AWS CloudTrail Terraform Module

This module creates an AWS CloudTrail with S3 bucket and CloudWatch Logs integration.

## Features

- Creates CloudTrail with configurable event selectors and insight selectors
- S3 bucket for log storage with proper bucket policies
- CloudWatch Logs integration for real-time monitoring
- KMS encryption support (optional)
- Multi-region trail support
- Configurable log retention

## Usage

### Basic Usage (Single Account with Local S3 Bucket)

```hcl
module "cloudtrail" {
  source = "./modules/aws/aws-cloudtrail"

  name           = "my-cloudtrail"
  s3_bucket_name = "my-cloudtrail-logs-bucket"
  s3_key_prefix  = "cloudtrail-logs"

  # CloudTrail configuration
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true

  # Optional KMS encryption
  kms_key_id = "alias/cloudtrail-key"

  # Event selectors
  event_selector = [{
    read_write_type                 = "All"
    include_management_events       = true
    exclude_management_event_sources = []
    data_resource = []
  }]

  # Insight selectors
  insight_selector = [{
    insight_type = "ApiCallRateInsight"
  }]

  tags = {
    Environment = "production"
    Team        = "security"
  }
}
```

## Centralized Logging for Multiple Accounts

This module supports organization-wide CloudTrail with centralized logging using cross-account S3 delivery.

### Step 1: Create Centralized Bucket (Log Archive Account)

```hcl
# In your log archive account (e.g., accounts/security/log-archive/)
module "cloudtrail" {
  source = "../../../modules/aws/aws-cloudtrail"

  name                          = "organization-cloudtrail"
  s3_bucket_name                = "org-cloudtrail-logs"
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  # Enable cross-account access from all organization accounts
  cross_account_source_arns = [
    "arn:aws:cloudtrail:*:111111111111:trail/*", # Account A
    "arn:aws:cloudtrail:*:222222222222:trail/*", # Account B
    "arn:aws:cloudtrail:*:333333333333:trail/*", # Account C
    # Add all your organization account IDs here
  ]

  tags = {
    Environment = "production"
    Team        = "security"
    Purpose     = "organization-wide-audit"
  }
}
```

### Step 2: Create Per-Account CloudTrails (All Other Accounts)

```hcl
# In each member account (e.g., accounts/workloads/prod/)
module "cloudtrail" {
  source = "../../../../modules/aws/aws-cloudtrail"

  name                          = "account-cloudtrail"
  create_s3_bucket              = false # Use centralized bucket
  s3_bucket_name                = "org-cloudtrail-logs" # Must match centralized bucket name
  s3_bucket_arn                 = "arn:aws:s3:::org-cloudtrail-logs"
  s3_key_prefix                 = "account-prod" # Unique prefix per account
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  tags = {
    Environment = "production"
    Team        = "security"
    Account     = "workloads-prod"
  }
}
```

### Deployment Order for Centralized Logging

1. **Deploy the centralized bucket first** (log archive account)
2. **Deploy per-account CloudTrails** (all other accounts)

### Resulting S3 Structure

```text
org-cloudtrail-logs/
├── cloudtrail/           # Log archive account's own logs
├── account-prod/         # Production account logs
├── account-staging/      # Staging account logs
├── account-dev/          # Development account logs
├── account-audit/        # Audit account logs
└── account-networking/   # Networking account logs
```

## Security Considerations

- S3 bucket is configured with public access blocked
- Bucket versioning is enabled
- Proper IAM policies are applied for CloudTrail access
- CloudWatch Logs integration for real-time monitoring
- Optional KMS encryption for enhanced security

## Examples

See the `examples/` directory for complete usage examples.

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs)
by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation in the [MODULE.md](./docs/MODULE.md) file.
