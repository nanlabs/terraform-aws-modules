## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.additional_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.power_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_additional_permissions"></a> [attach\_additional\_permissions](#input\_attach\_additional\_permissions) | Whether to attach additional permissions for Terraform state access and organizational read access | `bool` | `true` | no |
| <a name="input_attach_iam_full_access_policy"></a> [attach\_iam\_full\_access\_policy](#input\_attach\_iam\_full\_access\_policy) | Whether to attach the IAMFullAccess managed policy to the role | `bool` | `true` | no |
| <a name="input_attach_power_user_policy"></a> [attach\_power\_user\_policy](#input\_attach\_power\_user\_policy) | Whether to attach the PowerUserAccess managed policy to the role | `bool` | `true` | no |
| <a name="input_custom_policy_arns"></a> [custom\_policy\_arns](#input\_custom\_policy\_arns) | List of custom policy ARNs to attach to the GitHub Actions role | `list(string)` | `[]` | no |
| <a name="input_github_branches"></a> [github\_branches](#input\_github\_branches) | List of GitHub branches that are allowed to assume the role | `list(string)` | <pre>[<br/>  "main"<br/>]</pre> | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | List of GitHub environments that are allowed to assume the role. If set, this takes precedence over branches | `list(string)` | `null` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository in the format 'owner/repo' that will be allowed to assume the role | `string` | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds for the IAM role | `number` | `3600` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role to create for GitHub Actions | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_terraform_state_account_id"></a> [terraform\_state\_account\_id](#input\_terraform\_state\_account\_id) | AWS Account ID where the Terraform state bucket is located | `string` | `""` | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | Name of the S3 bucket used for Terraform state storage | `string` | `""` | no |
| <a name="input_terraform_state_region"></a> [terraform\_state\_region](#input\_terraform\_state\_region) | AWS region where the Terraform state bucket is located | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_role_arn"></a> [github\_actions\_role\_arn](#output\_github\_actions\_role\_arn) | ARN of the IAM role for GitHub Actions |
| <a name="output_github_actions_role_id"></a> [github\_actions\_role\_id](#output\_github\_actions\_role\_id) | ID of the IAM role for GitHub Actions |
| <a name="output_github_actions_role_name"></a> [github\_actions\_role\_name](#output\_github\_actions\_role\_name) | Name of the IAM role for GitHub Actions |
| <a name="output_github_actions_role_unique_id"></a> [github\_actions\_role\_unique\_id](#output\_github\_actions\_role\_unique\_id) | Unique ID of the IAM role for GitHub Actions |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the GitHub OIDC Identity Provider |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | URL of the GitHub OIDC Identity Provider |

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
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.additional_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.power_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_additional_permissions"></a> [attach\_additional\_permissions](#input\_attach\_additional\_permissions) | Whether to attach additional permissions for Terraform state access and organizational read access (single repository mode) | `bool` | `true` | no |
| <a name="input_attach_iam_full_access_policy"></a> [attach\_iam\_full\_access\_policy](#input\_attach\_iam\_full\_access\_policy) | Whether to attach the IAMFullAccess managed policy to the role (single repository mode) | `bool` | `true` | no |
| <a name="input_attach_power_user_policy"></a> [attach\_power\_user\_policy](#input\_attach\_power\_user\_policy) | Whether to attach the PowerUserAccess managed policy to the role (single repository mode) | `bool` | `true` | no |
| <a name="input_custom_policy_arns"></a> [custom\_policy\_arns](#input\_custom\_policy\_arns) | List of custom policy ARNs to attach to the GitHub Actions role (single repository mode) | `list(string)` | `[]` | no |
| <a name="input_github_branches"></a> [github\_branches](#input\_github\_branches) | List of GitHub branches that are allowed to assume the role (single repository mode) | `list(string)` | <pre>[<br/>  "main"<br/>]</pre> | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | List of GitHub environments that are allowed to assume the role. If set, this takes precedence over branches (single repository mode) | `list(string)` | `null` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository in the format 'owner/repo' that will be allowed to assume the role. Use this for single repository mode. | `string` | `null` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds for the IAM role (single repository mode) | `number` | `3600` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of repositories with their configurations. Use this for multi-repository mode. | <pre>map(object({<br/>    github_repository             = string<br/>    github_branches               = optional(list(string), ["main"])<br/>    github_environments           = optional(list(string), null)<br/>    role_name                     = string<br/>    max_session_duration          = optional(number, 3600)<br/>    attach_power_user_policy      = optional(bool, false)<br/>    attach_iam_full_access_policy = optional(bool, false)<br/>    attach_additional_permissions = optional(bool, false)<br/>    terraform_state_bucket        = optional(string, "")<br/>    terraform_state_account_id    = optional(string, "")<br/>    terraform_state_region        = optional(string, "")<br/>    custom_policy_arns            = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role to create for GitHub Actions (single repository mode) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_terraform_state_account_id"></a> [terraform\_state\_account\_id](#input\_terraform\_state\_account\_id) | AWS Account ID where the Terraform state bucket is located (single repository mode) | `string` | `""` | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | Name of the S3 bucket used for Terraform state storage (single repository mode) | `string` | `""` | no |
| <a name="input_terraform_state_region"></a> [terraform\_state\_region](#input\_terraform\_state\_region) | AWS region where the Terraform state bucket is located (single repository mode) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_role_arn"></a> [github\_actions\_role\_arn](#output\_github\_actions\_role\_arn) | ARN of the IAM role for GitHub Actions (single repository mode) |
| <a name="output_github_actions_role_id"></a> [github\_actions\_role\_id](#output\_github\_actions\_role\_id) | ID of the IAM role for GitHub Actions (single repository mode) |
| <a name="output_github_actions_role_name"></a> [github\_actions\_role\_name](#output\_github\_actions\_role\_name) | Name of the IAM role for GitHub Actions (single repository mode) |
| <a name="output_github_actions_role_unique_id"></a> [github\_actions\_role\_unique\_id](#output\_github\_actions\_role\_unique\_id) | Unique ID of the IAM role for GitHub Actions (single repository mode) |
| <a name="output_github_actions_roles"></a> [github\_actions\_roles](#output\_github\_actions\_roles) | Map of IAM roles for GitHub Actions (multi-repository mode) |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the GitHub OIDC Identity Provider |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | URL of the GitHub OIDC Identity Provider |
| <a name="output_repositories_configuration"></a> [repositories\_configuration](#output\_repositories\_configuration) | Configuration summary for all repositories |
<!-- END_TF_DOCS -->
