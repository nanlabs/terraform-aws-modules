# with-cloudtrail

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_data_lake_encryption"></a> [data\_lake\_encryption](#module\_data\_lake\_encryption) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_bucket_name"></a> [cloudtrail\_bucket\_name](#output\_cloudtrail\_bucket\_name) | Name of the CloudTrail S3 bucket |
| <a name="output_cloudtrail_trail_arn"></a> [cloudtrail\_trail\_arn](#output\_cloudtrail\_trail\_arn) | ARN of the CloudTrail trail |
| <a name="output_glue_kms_key_arn"></a> [glue\_kms\_key\_arn](#output\_glue\_kms\_key\_arn) | ARN of the Glue KMS key |
| <a name="output_permission_boundary_arn"></a> [permission\_boundary\_arn](#output\_permission\_boundary\_arn) | ARN of the IAM permission boundary |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | ARN of the S3 KMS key |
<!-- END_TF_DOCS -->
