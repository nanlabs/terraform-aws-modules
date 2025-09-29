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
| <a name="module_glue_execution_role"></a> [glue\_execution\_role](#module\_glue\_execution\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.59.0 |
| <a name="module_glue_scripts_bucket"></a> [glue\_scripts\_bucket](#module\_glue\_scripts\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.glue_jobs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_job.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |
| [aws_iam_role_policy.glue_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.glue_data_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.glue_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#input\_cloudwatch\_kms\_key\_id) | KMS key ID for CloudWatch Logs encryption | `string` | `null` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create a new S3 bucket for Glue scripts | `bool` | `true` | no |
| <a name="input_data_bucket_arns"></a> [data\_bucket\_arns](#input\_data\_bucket\_arns) | List of S3 bucket ARNs that Glue jobs need access to for data processing | `list(string)` | `[]` | no |
| <a name="input_existing_s3_bucket_name"></a> [existing\_s3\_bucket\_name](#input\_existing\_s3\_bucket\_name) | Name of existing S3 bucket to use for Glue scripts (when create\_s3\_bucket is false) | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow destruction of S3 bucket with objects (use with caution in production) | `bool` | `false` | no |
| <a name="input_glue_jobs"></a> [glue\_jobs](#input\_glue\_jobs) | Map of Glue jobs to create | <pre>map(object({<br/>    description               = string<br/>    glue_version              = optional(string, "5.0")<br/>    worker_type               = optional(string, "G.1X")<br/>    number_of_workers         = optional(number, 2)<br/>    max_capacity              = optional(number, null)<br/>    max_retries               = optional(number, 0)<br/>    timeout                   = optional(number, 2880)<br/>    security_configuration    = optional(string, null)<br/>    connections               = optional(list(string), [])<br/>    max_concurrent_runs       = optional(number, null)<br/>    notify_delay_after        = optional(number, null)<br/>    job_bookmark_option       = optional(string, "job-bookmark-enable")<br/>    non_overridable_arguments = optional(map(string), {})<br/>    default_arguments         = optional(map(string), {})<br/><br/>    command = object({<br/>      name            = optional(string, "glueetl")<br/>      script_location = string<br/>      python_version  = optional(string, "3")<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain CloudWatch logs for Glue jobs | `number` | `14` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration for the Glue execution role (in seconds) | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used as prefix for all resources created by this module | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for Glue scripts. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_s3_kms_key_id"></a> [s3\_kms\_key\_id](#input\_s3\_kms\_key\_id) | KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| <a name="input_s3_lifecycle_rules"></a> [s3\_lifecycle\_rules](#input\_s3\_lifecycle\_rules) | S3 bucket lifecycle rules for cost optimization | `any` | <pre>[<br/>  {<br/>    "abort_incomplete_multipart_upload": {<br/>      "days_after_initiation": 7<br/>    },<br/>    "id": "delete_old_versions",<br/>    "noncurrent_version_expiration": {<br/>      "days": 90<br/>    },<br/>    "status": "Enabled"<br/>  }<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | Common tags applied to all resources |
| <a name="output_glue_execution_role_arn"></a> [glue\_execution\_role\_arn](#output\_glue\_execution\_role\_arn) | ARN of the Glue execution IAM role |
| <a name="output_glue_execution_role_id"></a> [glue\_execution\_role\_id](#output\_glue\_execution\_role\_id) | ID of the Glue execution IAM role |
| <a name="output_glue_execution_role_name"></a> [glue\_execution\_role\_name](#output\_glue\_execution\_role\_name) | Name of the Glue execution IAM role |
| <a name="output_glue_job_arns"></a> [glue\_job\_arns](#output\_glue\_job\_arns) | ARNs of the created Glue jobs |
| <a name="output_glue_job_ids"></a> [glue\_job\_ids](#output\_glue\_job\_ids) | IDs of the created Glue jobs |
| <a name="output_glue_job_names"></a> [glue\_job\_names](#output\_glue\_job\_names) | Names of the created Glue jobs |
| <a name="output_glue_jobs_summary"></a> [glue\_jobs\_summary](#output\_glue\_jobs\_summary) | Summary of created Glue jobs with their key configuration |
| <a name="output_log_group_arns"></a> [log\_group\_arns](#output\_log\_group\_arns) | ARNs of the CloudWatch log groups for Glue jobs |
| <a name="output_log_group_names"></a> [log\_group\_names](#output\_log\_group\_names) | Names of the CloudWatch log groups for Glue jobs |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Resource prefix used for naming |
| <a name="output_scripts_bucket_arn"></a> [scripts\_bucket\_arn](#output\_scripts\_bucket\_arn) | ARN of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_domain_name"></a> [scripts\_bucket\_domain\_name](#output\_scripts\_bucket\_domain\_name) | Domain name of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_id"></a> [scripts\_bucket\_id](#output\_scripts\_bucket\_id) | ID of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_name"></a> [scripts\_bucket\_name](#output\_scripts\_bucket\_name) | Name of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_regional_domain_name"></a> [scripts\_bucket\_regional\_domain\_name](#output\_scripts\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket used for Glue scripts |

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
| <a name="module_glue_execution_role"></a> [glue\_execution\_role](#module\_glue\_execution\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.59.0 |
| <a name="module_glue_scripts_bucket"></a> [glue\_scripts\_bucket](#module\_glue\_scripts\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.glue_jobs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_connection.vpc_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection) | resource |
| [aws_glue_job.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |
| [aws_iam_role_policy.glue_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.glue_data_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.glue_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_kms_key_id"></a> [cloudwatch\_kms\_key\_id](#input\_cloudwatch\_kms\_key\_id) | KMS key ID for CloudWatch Logs encryption | `string` | `null` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create a new S3 bucket for Glue scripts | `bool` | `true` | no |
| <a name="input_data_bucket_arns"></a> [data\_bucket\_arns](#input\_data\_bucket\_arns) | List of S3 bucket ARNs that Glue jobs need access to for data processing | `list(string)` | `[]` | no |
| <a name="input_data_kms_key_arn"></a> [data\_kms\_key\_arn](#input\_data\_kms\_key\_arn) | KMS key ARN for data encryption/decryption in S3 data buckets. If not provided, no KMS permissions will be granted | `string` | `null` | no |
| <a name="input_existing_s3_bucket_name"></a> [existing\_s3\_bucket\_name](#input\_existing\_s3\_bucket\_name) | Name of existing S3 bucket to use for Glue scripts (when create\_s3\_bucket is false) | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to allow destruction of S3 bucket with objects (use with caution in production) | `bool` | `false` | no |
| <a name="input_glue_jobs"></a> [glue\_jobs](#input\_glue\_jobs) | Map of Glue jobs to create | <pre>map(object({<br/>    description               = string<br/>    glue_version              = optional(string, "5.0")<br/>    worker_type               = optional(string, "G.1X")<br/>    number_of_workers         = optional(number, 2)<br/>    max_capacity              = optional(number, null)<br/>    max_retries               = optional(number, 0)<br/>    timeout                   = optional(number, 2880)<br/>    security_configuration    = optional(string, null)<br/>    connections               = optional(list(string), [])<br/>    max_concurrent_runs       = optional(number, null)<br/>    notify_delay_after        = optional(number, null)<br/>    job_bookmark_option       = optional(string, "job-bookmark-enable")<br/>    non_overridable_arguments = optional(map(string), {})<br/>    default_arguments         = optional(map(string), {})<br/><br/>    command = object({<br/>      name            = optional(string, "glueetl")<br/>      script_location = string<br/>      python_version  = optional(string, "3")<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain CloudWatch logs for Glue jobs | `number` | `14` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration for the Glue execution role (in seconds) | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used as prefix for all resources created by this module | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket for Glue scripts. If not provided, will be auto-generated | `string` | `null` | no |
| <a name="input_s3_kms_key_id"></a> [s3\_kms\_key\_id](#input\_s3\_kms\_key\_id) | KMS key ID for S3 bucket encryption. If not provided, AES256 encryption will be used | `string` | `null` | no |
| <a name="input_s3_lifecycle_rules"></a> [s3\_lifecycle\_rules](#input\_s3\_lifecycle\_rules) | S3 bucket lifecycle rules for cost optimization | `any` | <pre>[<br/>  {<br/>    "abort_incomplete_multipart_upload": {<br/>      "days_after_initiation": 7<br/>    },<br/>    "id": "delete_old_versions",<br/>    "noncurrent_version_expiration": {<br/>      "days": 90<br/>    },<br/>    "status": "Enabled"<br/>  }<br/>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for Glue jobs. Required when vpc\_id is provided | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where Glue jobs will run. Required when vpc\_id is provided | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where Glue jobs will run. If not provided, jobs will run in AWS-managed VPC | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | Common tags applied to all resources |
| <a name="output_glue_execution_role_arn"></a> [glue\_execution\_role\_arn](#output\_glue\_execution\_role\_arn) | ARN of the Glue execution IAM role |
| <a name="output_glue_execution_role_id"></a> [glue\_execution\_role\_id](#output\_glue\_execution\_role\_id) | ID of the Glue execution IAM role |
| <a name="output_glue_execution_role_name"></a> [glue\_execution\_role\_name](#output\_glue\_execution\_role\_name) | Name of the Glue execution IAM role |
| <a name="output_glue_job_arns"></a> [glue\_job\_arns](#output\_glue\_job\_arns) | ARNs of the created Glue jobs |
| <a name="output_glue_job_ids"></a> [glue\_job\_ids](#output\_glue\_job\_ids) | IDs of the created Glue jobs |
| <a name="output_glue_job_names"></a> [glue\_job\_names](#output\_glue\_job\_names) | Names of the created Glue jobs |
| <a name="output_glue_jobs_summary"></a> [glue\_jobs\_summary](#output\_glue\_jobs\_summary) | Summary of created Glue jobs with their key configuration |
| <a name="output_log_group_arns"></a> [log\_group\_arns](#output\_log\_group\_arns) | ARNs of the CloudWatch log groups for Glue jobs |
| <a name="output_log_group_names"></a> [log\_group\_names](#output\_log\_group\_names) | Names of the CloudWatch log groups for Glue jobs |
| <a name="output_resource_prefix"></a> [resource\_prefix](#output\_resource\_prefix) | Resource prefix used for naming |
| <a name="output_scripts_bucket_arn"></a> [scripts\_bucket\_arn](#output\_scripts\_bucket\_arn) | ARN of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_domain_name"></a> [scripts\_bucket\_domain\_name](#output\_scripts\_bucket\_domain\_name) | Domain name of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_id"></a> [scripts\_bucket\_id](#output\_scripts\_bucket\_id) | ID of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_name"></a> [scripts\_bucket\_name](#output\_scripts\_bucket\_name) | Name of the S3 bucket used for Glue scripts |
| <a name="output_scripts_bucket_regional_domain_name"></a> [scripts\_bucket\_regional\_domain\_name](#output\_scripts\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket used for Glue scripts |
| <a name="output_vpc_connection_arn"></a> [vpc\_connection\_arn](#output\_vpc\_connection\_arn) | ARN of the Glue VPC connection |
| <a name="output_vpc_connection_name"></a> [vpc\_connection\_name](#output\_vpc\_connection\_name) | Name of the Glue VPC connection |
<!-- END_TF_DOCS -->
