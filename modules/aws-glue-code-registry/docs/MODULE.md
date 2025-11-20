## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_code_artifacts_bucket"></a> [code\_artifacts\_bucket](#module\_code\_artifacts\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.code_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.code_registry_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.additional_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_code_artifacts_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket_notification.code_artifacts_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_s3_bucket_arns"></a> [additional\_s3\_bucket\_arns](#input\_additional\_s3\_bucket\_arns) | List of additional S3 bucket ARNs that the code registry IAM role needs access to | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#input\_cloudwatch\_kms\_key\_id) | KMS key ID for CloudWatch Logs encryption | `string` | `null` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create IAM role for code registry access | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create a new S3 bucket for code artifacts | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_logging"></a> [enable\_cloudwatch\_logging](#input\_enable\_cloudwatch\_logging) | Whether to enable CloudWatch logging for code registry | `bool` | `true` | no |
| <a name="input_enable_s3_notifications"></a> [enable\_s3\_notifications](#input\_enable\_s3\_notifications) | Whether to enable S3 bucket notifications for code artifact uploads | `bool` | `false` | no |
| <a name="input_existing_s3_bucket_name"></a> [existing\_s3\_bucket\_name](#input\_existing\_s3\_bucket\_name) | Name of existing S3 bucket to use for code artifacts (when create\_s3\_bucket is false) | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow destruction of S3 bucket with objects (use with caution in production) | `bool` | `false` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain CloudWatch logs | `number` | `14` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration for the code registry access role (in seconds) | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used as prefix for all resources created by this module | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for code artifacts. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_s3_kms_key_id"></a> [s3\_kms\_key\_id](#input\_s3\_kms\_key\_id) | KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| <a name="input_s3_lifecycle_rules"></a> [s3\_lifecycle\_rules](#input\_s3\_lifecycle\_rules) | S3 bucket lifecycle rules for cost optimization | `any` | <pre>[<br/>  {<br/>    "abort_incomplete_multipart_upload": {<br/>      "days_after_initiation": 7<br/>    },<br/>    "id": "delete_old_versions",<br/>    "noncurrent_version_expiration": {<br/>      "days": 90<br/>    },<br/>    "status": "Enabled"<br/>  }<br/>]</pre> | no |
| <a name="input_s3_notification_configurations"></a> [s3\_notification\_configurations](#input\_s3\_notification\_configurations) | List of S3 notification configurations for code artifact uploads | <pre>list(object({<br/>    id            = string<br/>    events        = list(string)<br/>    filter_prefix = optional(string)<br/>    filter_suffix = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "events": [<br/>      "s3:ObjectCreated:*"<br/>    ],<br/>    "filter_suffix": ".jar",<br/>    "id": "code-upload-notification"<br/>  },<br/>  {<br/>    "events": [<br/>      "s3:ObjectCreated:*"<br/>    ],<br/>    "filter_suffix": ".whl",<br/>    "id": "wheel-upload-notification"<br/>  }<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_code_artifacts_bucket_arn"></a> [code\_artifacts\_bucket\_arn](#output\_code\_artifacts\_bucket\_arn) | ARN of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_domain_name"></a> [code\_artifacts\_bucket\_domain\_name](#output\_code\_artifacts\_bucket\_domain\_name) | Domain name of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_id"></a> [code\_artifacts\_bucket\_id](#output\_code\_artifacts\_bucket\_id) | ID of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_name"></a> [code\_artifacts\_bucket\_name](#output\_code\_artifacts\_bucket\_name) | Name of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_regional_domain_name"></a> [code\_artifacts\_bucket\_regional\_domain\_name](#output\_code\_artifacts\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket used for code artifacts |
| <a name="output_code_registry_role_arn"></a> [code\_registry\_role\_arn](#output\_code\_registry\_role\_arn) | ARN of the code registry access IAM role |
| <a name="output_code_registry_role_id"></a> [code\_registry\_role\_id](#output\_code\_registry\_role\_id) | ID of the code registry access IAM role |
| <a name="output_code_registry_role_name"></a> [code\_registry\_role\_name](#output\_code\_registry\_role\_name) | Name of the code registry access IAM role |
| <a name="output_code_registry_summary"></a> [code\_registry\_summary](#output\_code\_registry\_summary) | Summary of code registry configuration |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | Common tags applied to all resources |
| <a name="output_log_group_arns"></a> [log\_group\_arns](#output\_log\_group\_arns) | ARNs of the CloudWatch log groups for code registry |
| <a name="output_log_group_names"></a> [log\_group\_names](#output\_log\_group\_names) | Names of the CloudWatch log groups for code registry |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Resource prefix used for naming |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_code_artifacts_bucket"></a> [code\_artifacts\_bucket](#module\_code\_artifacts\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.code_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.code_registry_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.additional_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_code_artifacts_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket_policy.code_artifacts_cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_s3_bucket_arns"></a> [additional\_s3\_bucket\_arns](#input\_additional\_s3\_bucket\_arns) | List of additional S3 bucket ARNs that the code registry IAM role needs access to | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#input\_cloudwatch\_kms\_key\_id) | KMS key ID for CloudWatch Logs encryption | `string` | `null` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create IAM role for code registry access | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create a new S3 bucket for code artifacts | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_logging"></a> [enable\_cloudwatch\_logging](#input\_enable\_cloudwatch\_logging) | Whether to enable CloudWatch logging for code registry | `bool` | `true` | no |
| <a name="input_enable_s3_notifications"></a> [enable\_s3\_notifications](#input\_enable\_s3\_notifications) | Whether to enable S3 bucket notifications for code artifact uploads | `bool` | `false` | no |
| <a name="input_existing_s3_bucket_name"></a> [existing\_s3\_bucket\_name](#input\_existing\_s3\_bucket\_name) | Name of existing S3 bucket to use for code artifacts (when create\_s3\_bucket is false) | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow destruction of S3 bucket with objects (use with caution in production) | `bool` | `false` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain CloudWatch logs | `number` | `14` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration for the code registry access role (in seconds) | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used as prefix for all resources created by this module | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for code artifacts. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_s3_kms_key_id"></a> [s3\_kms\_key\_id](#input\_s3\_kms\_key\_id) | KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| <a name="input_s3_lifecycle_rules"></a> [s3\_lifecycle\_rules](#input\_s3\_lifecycle\_rules) | S3 bucket lifecycle rules for cost optimization | `any` | <pre>[<br/>  {<br/>    "abort_incomplete_multipart_upload": {<br/>      "days_after_initiation": 7<br/>    },<br/>    "id": "delete_old_versions",<br/>    "noncurrent_version_expiration": {<br/>      "days": 90<br/>    },<br/>    "status": "Enabled"<br/>  }<br/>]</pre> | no |
| <a name="input_s3_notification_configurations"></a> [s3\_notification\_configurations](#input\_s3\_notification\_configurations) | List of S3 notification configurations for code artifact uploads | <pre>list(object({<br/>    id            = string<br/>    events        = list(string)<br/>    filter_prefix = optional(string)<br/>    filter_suffix = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "events": [<br/>      "s3:ObjectCreated:*"<br/>    ],<br/>    "filter_suffix": ".jar",<br/>    "id": "code-upload-notification"<br/>  },<br/>  {<br/>    "events": [<br/>      "s3:ObjectCreated:*"<br/>    ],<br/>    "filter_suffix": ".whl",<br/>    "id": "wheel-upload-notification"<br/>  }<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_workload_account_ids"></a> [workload\_account\_ids](#input\_workload\_account\_ids) | List of AWS account IDs that should have cross-account access to the code artifacts bucket | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_code_artifacts_bucket_arn"></a> [code\_artifacts\_bucket\_arn](#output\_code\_artifacts\_bucket\_arn) | ARN of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_domain_name"></a> [code\_artifacts\_bucket\_domain\_name](#output\_code\_artifacts\_bucket\_domain\_name) | Domain name of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_id"></a> [code\_artifacts\_bucket\_id](#output\_code\_artifacts\_bucket\_id) | ID of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_name"></a> [code\_artifacts\_bucket\_name](#output\_code\_artifacts\_bucket\_name) | Name of the S3 bucket used for code artifacts |
| <a name="output_code_artifacts_bucket_regional_domain_name"></a> [code\_artifacts\_bucket\_regional\_domain\_name](#output\_code\_artifacts\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket used for code artifacts |
| <a name="output_code_registry_role_arn"></a> [code\_registry\_role\_arn](#output\_code\_registry\_role\_arn) | ARN of the code registry access IAM role |
| <a name="output_code_registry_role_id"></a> [code\_registry\_role\_id](#output\_code\_registry\_role\_id) | ID of the code registry access IAM role |
| <a name="output_code_registry_role_name"></a> [code\_registry\_role\_name](#output\_code\_registry\_role\_name) | Name of the code registry access IAM role |
| <a name="output_code_registry_summary"></a> [code\_registry\_summary](#output\_code\_registry\_summary) | Summary of code registry configuration |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | Common tags applied to all resources |
| <a name="output_log_group_arns"></a> [log\_group\_arns](#output\_log\_group\_arns) | ARNs of the CloudWatch log groups for code registry |
| <a name="output_log_group_names"></a> [log\_group\_names](#output\_log\_group\_names) | Names of the CloudWatch log groups for code registry |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Resource prefix used for naming |
<!-- END_TF_DOCS -->
