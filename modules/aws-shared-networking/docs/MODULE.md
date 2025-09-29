<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cross_account_networking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cross_account_networking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cross_account_networking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_parameter.cross_account_role_arns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.egress_nat_gateway_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.egress_vpc_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.egress_vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_private_route_table_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_public_route_table_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_vpc_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_services_vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.transit_gateway_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.transit_gateway_route_table_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for DHCP options | `string` | `""` | no |
| <a name="input_egress_nat_gateway_ids"></a> [egress\_nat\_gateway\_ids](#input\_egress\_nat\_gateway\_ids) | List of NAT Gateway IDs in the Egress VPC | `list(string)` | n/a | yes |
| <a name="input_egress_vpc_cidr"></a> [egress\_vpc\_cidr](#input\_egress\_vpc\_cidr) | CIDR block of the Egress VPC | `string` | n/a | yes |
| <a name="input_egress_vpc_id"></a> [egress\_vpc\_id](#input\_egress\_vpc\_id) | ID of the Egress VPC (centralized internet egress) | `string` | n/a | yes |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Enable DHCP options for the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Enable VPC Flow Logs | `bool` | `true` | no |
| <a name="input_flow_logs_s3_bucket"></a> [flow\_logs\_s3\_bucket](#input\_flow\_logs\_s3\_bucket) | S3 bucket name for VPC Flow Logs | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_shared_accounts"></a> [shared\_accounts](#input\_shared\_accounts) | Map of accounts that can access shared networking resources | <pre>map(object({<br>    account_id = string<br>    role_name  = string<br>  }))</pre> | `{}` | no |
| <a name="input_shared_services_private_route_table_ids"></a> [shared\_services\_private\_route\_table\_ids](#input\_shared\_services\_private\_route\_table\_ids) | List of private route table IDs in the Shared Services VPC | `list(string)` | n/a | yes |
| <a name="input_shared_services_private_subnets"></a> [shared\_services\_private\_subnets](#input\_shared\_services\_private\_subnets) | List of private subnet IDs in the Shared Services VPC | `list(string)` | n/a | yes |
| <a name="input_shared_services_public_route_table_ids"></a> [shared\_services\_public\_route\_table\_ids](#input\_shared\_services\_public\_route\_table\_ids) | List of public route table IDs in the Shared Services VPC | `list(string)` | n/a | yes |
| <a name="input_shared_services_public_subnets"></a> [shared\_services\_public\_subnets](#input\_shared\_services\_public\_subnets) | List of public subnet IDs in the Shared Services VPC | `list(string)` | n/a | yes |
| <a name="input_shared_services_vpc_cidr"></a> [shared\_services\_vpc\_cidr](#input\_shared\_services\_vpc\_cidr) | CIDR block of the Shared Services VPC | `string` | n/a | yes |
| <a name="input_shared_services_vpc_id"></a> [shared\_services\_vpc\_id](#input\_shared\_services\_vpc\_id) | ID of the Shared Services VPC (hub for shared services) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | ID of the Transit Gateway | `string` | n/a | yes |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | ID of the Transit Gateway Route Table | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_policy_arn"></a> [cross\_account\_policy\_arn](#output\_cross\_account\_policy\_arn) | ARN of the cross-account networking policy |
| <a name="output_cross_account_role_arns"></a> [cross\_account\_role\_arns](#output\_cross\_account\_role\_arns) | Map of cross-account IAM role ARNs |
| <a name="output_egress_nat_gateway_ids"></a> [egress\_nat\_gateway\_ids](#output\_egress\_nat\_gateway\_ids) | List of NAT Gateway IDs in the Egress VPC |
| <a name="output_egress_vpc_cidr"></a> [egress\_vpc\_cidr](#output\_egress\_vpc\_cidr) | Egress VPC CIDR block |
| <a name="output_egress_vpc_id"></a> [egress\_vpc\_id](#output\_egress\_vpc\_id) | Egress VPC ID |
| <a name="output_shared_networking_prefix"></a> [shared\_networking\_prefix](#output\_shared\_networking\_prefix) | SSM parameter prefix for shared networking resources |
| <a name="output_shared_services_vpc_cidr"></a> [shared\_services\_vpc\_cidr](#output\_shared\_services\_vpc\_cidr) | Shared Services VPC CIDR block |
| <a name="output_shared_services_vpc_id"></a> [shared\_services\_vpc\_id](#output\_shared\_services\_vpc\_id) | Shared Services VPC ID |
| <a name="output_ssm_parameter_names"></a> [ssm\_parameter\_names](#output\_ssm\_parameter\_names) | Map of SSM parameter names for cross-account reference |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | Transit Gateway ID |
| <a name="output_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#output\_transit\_gateway\_route\_table\_id) | Transit Gateway Route Table ID |
<!-- END_TF_DOCS -->