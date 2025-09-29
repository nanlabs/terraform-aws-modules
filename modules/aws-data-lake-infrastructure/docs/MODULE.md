<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.temp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.temp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.storage_tls_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.temp_tls_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.temp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.temp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.temp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_temp_bucket"></a> [create\_temp\_bucket](#input\_create\_temp\_bucket) | Whether to create a separate temporary bucket for working data | `bool` | `false` | no |
| <a name="input_data_lake_layers"></a> [data\_lake\_layers](#input\_data\_lake\_layers) | Configuration for data lake layers (medallion architecture) | <pre>object({<br>    raw_zone = string<br>    bronze   = string<br>    silver   = string<br>    gold     = string<br>    export   = string<br>  })</pre> | <pre>{<br>  "bronze": "iceberg-warehouse/bronze",<br>  "export": "export",<br>  "gold": "iceberg-warehouse/gold",<br>  "raw_zone": "raw-zone",<br>  "silver": "iceberg-warehouse/silver"<br>}</pre> | no |
| <a name="input_enable_lifecycle_rules"></a> [enable\_lifecycle\_rules](#input\_enable\_lifecycle\_rules) | Whether to enable lifecycle rules for cost optimization | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Whether to enable versioning on the S3 storage bucket | `bool` | `true` | no |
| <a name="input_export_retention_days"></a> [export\_retention\_days](#input\_export\_retention\_days) | Number of days to retain files in the export layer before deletion | `number` | `30` | no |
| <a name="input_iceberg_artifacts_path"></a> [iceberg\_artifacts\_path](#input\_iceberg\_artifacts\_path) | S3 path for Iceberg job dependencies (libs, scripts) | `string` | `"iceberg-artifacts"` | no |
| <a name="input_iceberg_migrations_path"></a> [iceberg\_migrations\_path](#input\_iceberg\_migrations\_path) | S3 path for Iceberg schema changes and migration scripts | `string` | `"iceberg-migrations"` | no |
| <a name="input_iceberg_warehouse_path"></a> [iceberg\_warehouse\_path](#input\_iceberg\_warehouse\_path) | S3 path for Iceberg warehouse metadata (contains bronze, silver, gold) | `string` | `"iceberg-warehouse"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name prefix for resources created by this module. Should be in the format: namespace-short\_domain-account\_name (e.g., dwh-wl-workloads-data-lake-develop) | `string` | n/a | yes |
| <a name="input_quicksight_role_arn"></a> [quicksight\_role\_arn](#input\_quicksight\_role\_arn) | Optional QuickSight service or author role ARN granted read/write (as needed) to temp/storage buckets for Athena validation | `string` | `null` | no |
| <a name="input_spark_event_logs_path"></a> [spark\_event\_logs\_path](#input\_spark\_event\_logs\_path) | S3 path for Spark event logs | `string` | `"spark-event-logs"` | no |
| <a name="input_spark_logs_retention_days"></a> [spark\_logs\_retention\_days](#input\_spark\_logs\_retention\_days) | Number of days to retain Spark event logs before deletion | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_configuration"></a> [bucket\_configuration](#output\_bucket\_configuration) | Complete configuration details for the data lake buckets |
| <a name="output_data_lake_paths"></a> [data\_lake\_paths](#output\_data\_lake\_paths) | S3 paths for each data lake layer |
| <a name="output_iceberg_paths"></a> [iceberg\_paths](#output\_iceberg\_paths) | S3 paths for Apache Iceberg components |
| <a name="output_spark_paths"></a> [spark\_paths](#output\_spark\_paths) | S3 paths for Spark components |
| <a name="output_storage_bucket_arn"></a> [storage\_bucket\_arn](#output\_storage\_bucket\_arn) | The ARN of the main storage bucket |
| <a name="output_storage_bucket_domain_name"></a> [storage\_bucket\_domain\_name](#output\_storage\_bucket\_domain\_name) | The bucket domain name for the main storage bucket |
| <a name="output_storage_bucket_id"></a> [storage\_bucket\_id](#output\_storage\_bucket\_id) | The ID (name) of the main storage bucket |
| <a name="output_storage_bucket_regional_domain_name"></a> [storage\_bucket\_regional\_domain\_name](#output\_storage\_bucket\_regional\_domain\_name) | The bucket regional domain name for the main storage bucket |
| <a name="output_temp_bucket_arn"></a> [temp\_bucket\_arn](#output\_temp\_bucket\_arn) | The ARN of the temporary bucket (if created) |
| <a name="output_temp_bucket_id"></a> [temp\_bucket\_id](#output\_temp\_bucket\_id) | The ID (name) of the temporary bucket (if created) |
<!-- END_TF_DOCS -->