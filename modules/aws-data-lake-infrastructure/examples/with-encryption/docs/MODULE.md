# with-encryption

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
| <a name="module_data_lake_infrastructure"></a> [data\_lake\_infrastructure](#module\_data\_lake\_infrastructure) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.data_lake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.data_lake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_lake_bucket_arn"></a> [data\_lake\_bucket\_arn](#output\_data\_lake\_bucket\_arn) | The ARN of the data lake bucket |
| <a name="output_data_lake_bucket_id"></a> [data\_lake\_bucket\_id](#output\_data\_lake\_bucket\_id) | The name of the data lake bucket |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for encryption |
| <a name="output_temp_bucket_id"></a> [temp\_bucket\_id](#output\_temp\_bucket\_id) | The name of the temporary bucket |
<!-- END_TF_DOCS -->
