# AWS Glue Data Lake Catalog Module

This module creates AWS Glue databases for a data lake medallion architecture with flexible sublayer separation. Instead of having a single database per layer (bronze, silver, gold), this module can create separate databases for each combination of layer and sublayer (source systems, processing stages, etc.), or single databases for layers without sublayers.

## Architecture

The module creates databases following these patterns:

### Multi-sublayer approach (when sublayers are defined):
- `{prefix}_{layer}_{sublayer}` - Separate database for each sublayer within a layer

### Single-layer approach (when no sublayers are defined):
- `{prefix}_{layer}_data` - Single database for the entire layer

### Special databases:
- `{prefix}_shared` - Common tables and reference data
- `{prefix}_export` - Final data outputs and CSV exports

## Example Structure

### With sublayers defined:
```hcl
data_lake_sublayers = {
  raw_zone = ["ingestion"]
  bronze   = ["processing"]  
  silver   = ["analytics"]
  gold     = ["reporting"]
}
```

This creates:
```
Raw Zone Layer:
- dwh-wl-workloads-data-lake-develop_raw_zone_ingestion

Bronze Layer:
- dwh-wl-workloads-data-lake-develop_bronze_processing

Silver Layer:
- dwh-wl-workloads-data-lake-develop_silver_analytics

Gold Layer:
- dwh-wl-workloads-data-lake-develop_gold_reporting
```

### With source systems as sublayers:
```hcl
data_lake_sublayers = {
  bronze = ["klaviyo", "salesforce", "stripe"]
  silver = ["klaviyo", "salesforce", "stripe"]
  gold   = ["klaviyo", "salesforce", "stripe"]
}
```

### Without sublayers (single databases):
```hcl
data_lake_sublayers = {}
```

This creates:
```
- dwh-wl-workloads-data-lake-develop_raw_zone_data
- dwh-wl-workloads-data-lake-develop_bronze_data
- dwh-wl-workloads-data-lake-develop_silver_data
- dwh-wl-workloads-data-lake-develop_gold_data
```

## S3 Storage Mapping

### With sublayers:
- Sublayer databases: `s3://bucket/{layer_path}/{sublayer}/`

### Without sublayers:
- Single databases: `s3://bucket/{layer_path}/`

## Features

- **Flexible Sublayer Support**: Configure sublayers per layer or use single-layer databases
- **Apache Iceberg Support**: Silver and gold databases are configured for Iceberg table format
- **Flexible Configuration**: Configurable layers and sublayers
- **Additional Databases**: Support for custom databases outside the standard data lake layers
- **Backward Compatibility**: Provides legacy outputs for existing code
- **Rich Metadata**: Databases include parameters for layer, sublayer, and table format
- **Comprehensive Outputs**: Multiple output formats for different access patterns

## Usage

### With sublayers (recommended for multi-source environments):
```hcl
module "glue_catalog" {
  source = "../../../../modules/aws/aws-glue-data-lake-catalog"

  database_prefix   = "dwh-wl-workloads-data-lake-develop"
  s3_bucket_uri     = "s3://dwh-wl-workloads-data-lake-develop-storage"

  layers = ["raw_zone", "bronze", "silver", "gold"]
  data_lake_sublayers = {
    raw_zone = ["ingestion"]
    bronze   = ["processing"]  
    silver   = ["analytics"]
    gold     = ["reporting"]
  }

  data_lake_paths = {
    raw_zone = "raw-zone"
    bronze   = "iceberg-warehouse/bronze"
    silver   = "iceberg-warehouse/silver"
    gold     = "iceberg-warehouse/gold"
  }

  create_shared_databases = true
  create_export_database  = true

  tags = local.tags
}
```

### Without sublayers (simpler single-database approach):
```hcl
module "glue_catalog" {
  source = "../../../../modules/aws/aws-glue-data-lake-catalog"

  database_prefix   = "dwh-wl-workloads-data-lake-develop"
  s3_bucket_uri     = "s3://dwh-wl-workloads-data-lake-develop-storage"

  layers              = ["raw_zone", "bronze", "silver", "gold"]
  data_lake_sublayers = {}

  data_lake_paths = {
    raw_zone = "raw-zone"
    bronze   = "iceberg-warehouse/bronze"
    silver   = "iceberg-warehouse/silver"
    gold     = "iceberg-warehouse/gold"
  }

  tags = local.tags
}
```

### With additional custom databases

```hcl
module "glue_catalog" {
  source = "../../../../modules/aws/aws-glue-data-lake-catalog"

  database_prefix   = "dwh-wl-workloads-data-lake-develop"
  s3_bucket_uri     = "s3://dwh-wl-workloads-data-lake-develop-storage"

  layers = ["raw_zone", "bronze", "silver", "gold"]

  # Custom databases for specific use cases
  additional_databases = {
    migrations = {
      description = "Database for storing Iceberg table migration artifacts and history"
      location    = "s3://dwh-wl-workloads-data-lake-develop-storage/migrations/"
      parameters = {
        "classification"   = "migrations"
        "purpose"          = "migration-artifacts"
        "table-format"     = "iceberg"
        "iceberg-enabled"  = "true"
      }
    }
    staging = {
      description = "Temporary staging database for data processing"
      # Uses default location: s3://bucket/staging/
      parameters = {
        "classification" = "staging"
        "purpose"        = "temporary-processing"
      }
    }
  }

  tags = local.tags
}
```

## Migration from Single-Layer Databases

This module replaces the previous approach of having single databases per layer. When migrating:

1. **Update module reference**: Change from `aws-glue-catalog` to `aws-glue-data-lake-catalog`
2. **Update outputs**: Use new outputs like `databases_by_layer` or `databases_by_source_system`
3. **Update ETL jobs**: Point to specific source system databases instead of single layer databases
4. **Backward compatibility**: Legacy outputs are provided for gradual migration

## Benefits

- **Better Organization**: Clear separation of data by source system
- **Improved Security**: Granular access control per source system
- **Easier Maintenance**: Independent schema evolution per source system
- **Better Performance**: Reduced table scanning within databases
- **Clearer Lineage**: Explicit source system tracking
