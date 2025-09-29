# aws-glue-data-lake-catalog

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.databases](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | Map of additional databases to create outside of the standard data lake layers | <pre>map(object({<br/>    description = string<br/>    location    = optional(string, null)<br/>    parameters  = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_catalog_id"></a> [catalog\_id](#input\_catalog\_id) | The ID of the Glue Catalog. If not provided, the AWS account ID will be used | `string` | `null` | no |
| <a name="input_create_export_database"></a> [create\_export\_database](#input\_create\_export\_database) | Whether to create an export database for final outputs | `bool` | `true` | no |
| <a name="input_create_shared_databases"></a> [create\_shared\_databases](#input\_create\_shared\_databases) | Whether to create shared databases (shared, export) | `bool` | `true` | no |
| <a name="input_data_lake_paths"></a> [data\_lake\_paths](#input\_data\_lake\_paths) | Map of layer names to their S3 path prefixes | `map(string)` | <pre>{<br/>  "bronze": "iceberg-warehouse/bronze",<br/>  "gold": "iceberg-warehouse/gold",<br/>  "silver": "iceberg-warehouse/silver"<br/>}</pre> | no |
| <a name="input_data_lake_sublayers"></a> [data\_lake\_sublayers](#input\_data\_lake\_sublayers) | Configuration for sublayers within each data lake layer. Each layer can have multiple sublayers (e.g., source systems, processing stages) | `map(list(string))` | `{}` | no |
| <a name="input_database_prefix"></a> [database\_prefix](#input\_database\_prefix) | Prefix for all Glue database names. Should follow the pattern: namespace-short\_domain-account\_name (e.g., dwh-wl-workloads-data-lake-develop) | `string` | n/a | yes |
| <a name="input_layers"></a> [layers](#input\_layers) | List of data lake layers to create databases for | `list(string)` | <pre>[<br/>  "bronze",<br/>  "silver",<br/>  "gold"<br/>]</pre> | no |
| <a name="input_s3_bucket_uri"></a> [s3\_bucket\_uri](#input\_s3\_bucket\_uri) | The S3 bucket URI where data lake data is stored (e.g., s3://bucket-name) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bronze_database_name"></a> [bronze\_database\_name](#output\_bronze\_database\_name) | Name of the first bronze database (for backward compatibility) |
| <a name="output_database_arns"></a> [database\_arns](#output\_database\_arns) | Map of database names to ARNs |
| <a name="output_databases"></a> [databases](#output\_databases) | Map of all created Glue databases with their details |
| <a name="output_databases_by_layer"></a> [databases\_by\_layer](#output\_databases\_by\_layer) | Map of databases organized by layer |
| <a name="output_databases_by_sublayer"></a> [databases\_by\_sublayer](#output\_databases\_by\_sublayer) | Map of databases organized by sublayer |
| <a name="output_export_database"></a> [export\_database](#output\_export\_database) | Export database details |
| <a name="output_gold_database_name"></a> [gold\_database\_name](#output\_gold\_database\_name) | Name of the first gold database (for backward compatibility) |
| <a name="output_raw_zone_database_name"></a> [raw\_zone\_database\_name](#output\_raw\_zone\_database\_name) | Name of the first raw\_zone database (for backward compatibility) |
| <a name="output_shared_database"></a> [shared\_database](#output\_shared\_database) | Shared database details |
| <a name="output_silver_database_name"></a> [silver\_database\_name](#output\_silver\_database\_name) | Name of the first silver database (for backward compatibility) |
<!-- END_TF_DOCS -->
