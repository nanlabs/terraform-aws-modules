# aws-data-lake-encryption

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
| [aws_cloudtrail.kms_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_iam_policy.data_lake_boundary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_alias.glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_kms_policy_statements"></a> [additional\_kms\_policy\_statements](#input\_additional\_kms\_policy\_statements) | Additional policy statements to add to the KMS key policies | `list(any)` | `[]` | no |
| <a name="input_allowed_services"></a> [allowed\_services](#input\_allowed\_services) | List of AWS services that should have access to the KMS keys | `list(string)` | <pre>[<br/>  "s3.amazonaws.com",<br/>  "glue.amazonaws.com"<br/>]</pre> | no |
| <a name="input_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#input\_cloudtrail\_bucket\_name) | The name of the S3 bucket for CloudTrail logs (required if enable\_kms\_logging is true) | `string` | `null` | no |
| <a name="input_create_permission_boundary"></a> [create\_permission\_boundary](#input\_create\_permission\_boundary) | Whether to create an IAM permission boundary for data lake jobs | `bool` | `true` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Whether to enable automatic rotation of the KMS keys | `bool` | `true` | no |
| <a name="input_enable_kms_logging"></a> [enable\_kms\_logging](#input\_enable\_kms\_logging) | Whether to enable CloudTrail logging for KMS key usage | `bool` | `true` | no |
| <a name="input_kms_deletion_window"></a> [kms\_deletion\_window](#input\_kms\_deletion\_window) | The waiting period, specified in number of days, after which the KMS key is deleted | `number` | `7` | no |
| <a name="input_name"></a> [name](#input\_name) | The name prefix for resources created by this module. Should be in the format: namespace-short\_domain-account\_name (e.g., dwh-wl-workloads-data-lake-develop) | `string` | n/a | yes |
| <a name="input_quicksight_role_arn"></a> [quicksight\_role\_arn](#input\_quicksight\_role\_arn) | (Optional) QuickSight IAM role ARN to permit kms:Decrypt/GenerateDataKey via S3 for Athena result access | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_encryption_configuration"></a> [encryption\_configuration](#output\_encryption\_configuration) | Complete encryption configuration for the data lake |
| <a name="output_glue_kms_key_alias"></a> [glue\_kms\_key\_alias](#output\_glue\_kms\_key\_alias) | The alias of the Glue KMS key |
| <a name="output_glue_kms_key_arn"></a> [glue\_kms\_key\_arn](#output\_glue\_kms\_key\_arn) | The ARN of the Glue KMS key |
| <a name="output_glue_kms_key_id"></a> [glue\_kms\_key\_id](#output\_glue\_kms\_key\_id) | The ID of the Glue KMS key |
| <a name="output_kms_logging_trail_arn"></a> [kms\_logging\_trail\_arn](#output\_kms\_logging\_trail\_arn) | The ARN of the CloudTrail for KMS logging (if created) |
| <a name="output_permission_boundary_arn"></a> [permission\_boundary\_arn](#output\_permission\_boundary\_arn) | The ARN of the IAM permission boundary policy (if created) |
| <a name="output_permission_boundary_name"></a> [permission\_boundary\_name](#output\_permission\_boundary\_name) | The name of the IAM permission boundary policy (if created) |
| <a name="output_s3_kms_key_alias"></a> [s3\_kms\_key\_alias](#output\_s3\_kms\_key\_alias) | The alias of the S3 KMS key |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | The ARN of the S3 KMS key |
| <a name="output_s3_kms_key_id"></a> [s3\_kms\_key\_id](#output\_s3\_kms\_key\_id) | The ID of the S3 KMS key |
| <a name="output_service_kms_keys"></a> [service\_kms\_keys](#output\_service\_kms\_keys) | Mapping of services to their respective KMS keys |
<!-- END_TF_DOCS -->
