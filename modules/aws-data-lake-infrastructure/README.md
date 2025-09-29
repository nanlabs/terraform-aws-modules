# AWS Data Lake Infrastructure Module

This module creates the foundational S3 infrastructure for a data lake following the medallion architecture
with raw zone for source systems and Apache Iceberg support.

## Features

- 🏗️ **Medallion Architecture**: Pre-configured Raw Zone, Bronze, Silver, Gold, and Export layers
- 📥 **Source System Integration**: Dedicated raw zone for source systems (Klaviyo, Salesforce, Stripe, HubSpot)
- ❄️ **Apache Iceberg Support**: Dedicated paths for Iceberg warehouse, artifacts, and migrations
- 🔐 **Security**: KMS encryption, public access blocking, and secure defaults
- 💰 **Cost Optimization**: Intelligent lifecycle rules for different data tiers
- 🏷️ **Consistent Tagging**: Automated tagging for all resources
- 📊 **Spark Integration**: Dedicated paths for Spark event logs
- 🗂️ **Optional Temp Storage**: Separate bucket for temporary/working data

## Architecture

The module creates the following S3 structure:

```
s3://dwh-{env}-{account}-storage/
├── raw-zone/               # Source system raw data
│   ├── klaviyo/           # Klaviyo raw files
│   ├── salesforce/        # Salesforce raw files
│   ├── stripe/            # Stripe raw files
│   └── hubspot/           # HubSpot raw files
├── iceberg-warehouse/      # Apache Iceberg medallion architecture
│   ├── bronze/            # Raw data (Parquet/Iceberg tables)
│   ├── silver/            # Cleaned data (Iceberg tables)
│   └── gold/              # Business-ready data (Iceberg tables)
├── export/                 # CSV exports (30-day retention)
├── iceberg-artifacts/      # Iceberg table artifacts
├── iceberg-migrations/     # Schema migration history
└── spark-event-logs/       # Spark job logs (90-day retention)
```

## Usage

### Basic Usage

```hcl
module "data_lake_infrastructure" {
  source = "../../../../modules/aws/aws-data-lake-infrastructure"

  name = local.resource_prefix  # e.g., "dwh-wl-workloads-data-lake-develop"
  tags = local.tags

  # Optional: Use KMS encryption
  kms_key_arn = module.data_lake_encryption.s3_kms_key_arn
}
```

### Advanced Configuration

```hcl
module "data_lake_infrastructure" {
  source = "../../../../modules/aws/aws-data-lake-infrastructure"

  name = local.resource_prefix
  tags = local.tags

  # Encryption
  kms_key_arn = module.data_lake_encryption.s3_kms_key_arn

  # Custom layer names
  data_lake_layers = {
    raw_zone = "source-data"
    bronze   = "iceberg-warehouse/raw"
    silver   = "iceberg-warehouse/processed"
    gold     = "iceberg-warehouse/curated"
    export   = "outputs"
  }

  # Custom Iceberg paths
  iceberg_warehouse_path  = "iceberg-warehouse"
  iceberg_artifacts_path  = "iceberg-artifacts"
  iceberg_migrations_path = "iceberg-migrations"

  # Retention policies
  export_retention_days      = 60
  spark_logs_retention_days  = 180

  # Additional features
  create_temp_bucket      = true
  enable_lifecycle_rules  = true
  enable_versioning       = true
}
```

## Lifecycle Rules

The module automatically applies intelligent lifecycle rules:

| Layer      | Standard → IA | IA → Glacier | Glacier → Deep Archive | Deletion  |
| ---------- | ------------- | ------------ | ---------------------- | --------- |
| Raw Zone   | 30 days       | 90 days      | 365 days               | -         |
| Bronze     | 60 days       | 180 days     | 730 days               | -         |
| Silver     | 90 days       | 365 days     | -                      | -         |
| Gold       | 180 days      | -            | -                      | -         |
| Export     | -             | -            | -                      | 30 days\* |
| Spark Logs | -             | -            | -                      | 90 days\* |

\*Configurable via variables

## Security Features

- **Public Access Blocked**: All public access is blocked by default
- **Encryption at Rest**: Supports both AES256 and KMS encryption
- **Versioning**: Optional S3 versioning for data protection
- **Bucket Key**: Enabled for KMS encryption to reduce costs

## Cost Optimization

- **Intelligent Tiering**: Automatic transition to cheaper storage classes
- **Lifecycle Management**: Automatic cleanup of temporary and export data
- **Separate Temp Bucket**: Optional isolated bucket for temporary data with 7-day auto-cleanup

## Integration with Other Modules

This module is designed to work with:

- `aws-data-lake-encryption`: For KMS key management
- `aws-glue-catalog`: For Glue database configuration
- `aws-glue-jobs`: For Spark/Glue job definitions

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs)
by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation in the [MODULE.md file](./docs/MODULE.md).
