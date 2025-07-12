<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | terraform-aws-modules/ec2-instance/aws | 6.0.2 |
| <a name="module_ec2_security_group"></a> [ec2\_security\_group](#module\_ec2\_security\_group) | terraform-aws-modules/security-group/aws | 5.3.0 |
| <a name="module_ec2messages_vpc_endpoint"></a> [ec2messages\_vpc\_endpoint](#module\_ec2messages\_vpc\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.21.0 |
| <a name="module_ssm_vpc_endpoint"></a> [ssm\_vpc\_endpoint](#module\_ssm\_vpc\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.21.0 |
| <a name="module_ssmmessages_vpc_endpoint"></a> [ssmmessages\_vpc\_endpoint](#module\_ssmmessages\_vpc\_endpoint) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.21.0 |
| <a name="module_vpc_endpoint_security_group"></a> [vpc\_endpoint\_security\_group](#module\_vpc\_endpoint\_security\_group) | terraform-aws-modules/security-group/aws | 5.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.bastion_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ec2_instance_connect_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.bastion_host_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bastion_host_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.bastion_host_cloudwatch_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_host_instance_connect_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_host_ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.ec2_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_key_pair.ec2_ssh_provided](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_ssm_parameter.instance_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.instance_private_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.key_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ssh_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ssh_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.subnet_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.vpc_endpoints_created](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tls_private_key.ec2_ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | Allow these CIDR blocks to the bastion host | `list(string)` | `[]` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to use for the instance - will default to latest Ubuntu | `string` | `""` | no |
| <a name="input_create_ssh_key"></a> [create\_ssh\_key](#input\_create\_ssh\_key) | Whether to create an SSH key pair and store it in SSM Parameter Store | `bool` | `true` | no |
| <a name="input_create_ssm_parameters"></a> [create\_ssm\_parameters](#input\_create\_ssm\_parameters) | Whether to create SSM parameters for bastion host details | `bool` | `true` | no |
| <a name="input_create_vpc_endpoints"></a> [create\_vpc\_endpoints](#input\_create\_vpc\_endpoints) | Create VPC endpoints for SSM, EC2 Messages, and SSM Messages | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_logs"></a> [enable\_cloudwatch\_logs](#input\_enable\_cloudwatch\_logs) | Enable CloudWatch logs for the bastion host | `bool` | `true` | no |
| <a name="input_enable_detailed_monitoring"></a> [enable\_detailed\_monitoring](#input\_enable\_detailed\_monitoring) | Enable detailed monitoring for the bastion host | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type/size - the default is not part of free tier! | `string` | `"t3.nano"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | SSH key name to use for the instance | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention period in days | `number` | `7` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnets in which the EC2 instance is to be created. | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnets for VPC endpoints (optional). If not provided, private\_subnets will be used. | `list(string)` | `[]` | no |
| <a name="input_root_volume_encrypted"></a> [root\_volume\_encrypted](#input\_root\_volume\_encrypted) | Whether to encrypt the root volume | `bool` | `true` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root volume in GB | `number` | `8` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Type of the root volume | `string` | `"gp3"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key content. If not provided and create\_ssh\_key is true, will generate a new key pair | `string` | `""` | no |
| <a name="input_ssm_parameter_prefix"></a> [ssm\_parameter\_prefix](#input\_ssm\_parameter\_prefix) | Prefix for SSM parameter names. If not provided, will use '/{name}' | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Any extra tags to assign to objects | `map(any)` | `{}` | no |
| <a name="input_vpc_endpoint_policy"></a> [vpc\_endpoint\_policy](#input\_vpc\_endpoint\_policy) | Policy to apply to VPC endpoints | `string` | `null` | no |
| <a name="input_vpc_endpoint_route_table_ids"></a> [vpc\_endpoint\_route\_table\_ids](#input\_vpc\_endpoint\_route\_table\_ids) | Route table IDs for VPC endpoints (for Gateway endpoints) | `list(string)` | `[]` | no |
| <a name="input_vpc_endpoints_subnet_ids"></a> [vpc\_endpoints\_subnet\_ids](#input\_vpc\_endpoints\_subnet\_ids) | Subnet IDs for VPC endpoints. If not specified, will use private\_subnets | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id in which the EC2 instance is to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the CloudWatch log group |
| <a name="output_ec2messages_vpc_endpoint_id"></a> [ec2messages\_vpc\_endpoint\_id](#output\_ec2messages\_vpc\_endpoint\_id) | ID of the EC2 Messages VPC endpoint |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN of the IAM instance profile attached to the bastion host |
| <a name="output_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#output\_iam\_instance\_profile\_name) | Name of the IAM instance profile attached to the bastion host |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role attached to the bastion host |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the IAM role attached to the bastion host |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | ARN of the bastion host instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the bastion host instance |
| <a name="output_instance_private_dns"></a> [instance\_private\_dns](#output\_instance\_private\_dns) | Private DNS name of the bastion host |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | Private IP address of the bastion host |
| <a name="output_instance_state"></a> [instance\_state](#output\_instance\_state) | State of the bastion host instance |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | Name of the SSH key pair used by the bastion host |
| <a name="output_name"></a> [name](#output\_name) | Name of the bastion host |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group attached to the bastion host |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group attached to the bastion host |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | Public SSH key content |
| <a name="output_ssm_parameter_names"></a> [ssm\_parameter\_names](#output\_ssm\_parameter\_names) | Names of the created SSM parameters for bastion host details |
| <a name="output_ssm_vpc_endpoint_id"></a> [ssm\_vpc\_endpoint\_id](#output\_ssm\_vpc\_endpoint\_id) | ID of the SSM VPC endpoint |
| <a name="output_ssmmessages_vpc_endpoint_id"></a> [ssmmessages\_vpc\_endpoint\_id](#output\_ssmmessages\_vpc\_endpoint\_id) | ID of the SSM Messages VPC endpoint |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | ID of the subnet where the bastion host is deployed |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to resources |
| <a name="output_vpc_endpoint_security_group_id"></a> [vpc\_endpoint\_security\_group\_id](#output\_vpc\_endpoint\_security\_group\_id) | Security group ID for VPC endpoints |
| <a name="output_vpc_endpoints_created"></a> [vpc\_endpoints\_created](#output\_vpc\_endpoints\_created) | Whether VPC endpoints were created |
<!-- END_TF_DOCS -->