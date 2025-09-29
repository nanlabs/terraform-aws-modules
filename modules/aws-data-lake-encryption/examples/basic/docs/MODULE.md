# basic

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.50 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_data_lake_encryption"></a> [data\_lake\_encryption](#module\_data\_lake\_encryption) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_glue_kms_key_arn"></a> [glue\_kms\_key\_arn](#output\_glue\_kms\_key\_arn) | ARN of the Glue KMS key |
| <a name="output_permission_boundary_arn"></a> [permission\_boundary\_arn](#output\_permission\_boundary\_arn) | ARN of the IAM permission boundary |
| <a name="output_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#output\_s3\_kms\_key\_arn) | ARN of the S3 KMS key |
<!-- END_TF_DOCS -->
