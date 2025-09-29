# multi-repository

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_oidc_multi"></a> [github\_oidc\_multi](#module\_github\_oidc\_multi) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.data_jobs_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_analytics_repository"></a> [analytics\_repository](#input\_analytics\_repository) | GitHub repository for analytics (owner/repo) | `string` | `"organization/analytics"` | no |
| <a name="input_data_jobs_repository"></a> [data\_jobs\_repository](#input\_data\_jobs\_repository) | GitHub repository for data jobs (owner/repo) | `string` | `"organization/data-jobs"` | no |
| <a name="input_infrastructure_repository"></a> [infrastructure\_repository](#input\_infrastructure\_repository) | GitHub repository for infrastructure (owner/repo) | `string` | `"organization/infrastructure"` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name for resources | `string` | `"github-oidc-multi-example"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "example",<br/>  "Purpose": "multi-repo-oidc"<br/>}</pre> | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | Name of the S3 bucket for Terraform state | `string` | `"my-terraform-state-bucket"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_jobs_policy_arn"></a> [data\_jobs\_policy\_arn](#output\_data\_jobs\_policy\_arn) | ARN of the custom data jobs policy |
| <a name="output_github_actions_roles"></a> [github\_actions\_roles](#output\_github\_actions\_roles) | Map of GitHub Actions roles for all repositories |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of the GitHub OIDC provider |
| <a name="output_repositories_configuration"></a> [repositories\_configuration](#output\_repositories\_configuration) | Configuration summary for all repositories |
<!-- END_TF_DOCS -->
