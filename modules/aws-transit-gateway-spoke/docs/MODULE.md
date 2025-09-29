# aws-transit-gateway-spoke

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.spoke_default_via_hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.spoke_to_spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_ssm_parameter.spoke_vpc_info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.vpc_attachment_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_internet_via_hub"></a> [enable\_internet\_via\_hub](#input\_enable\_internet\_via\_hub) | Whether to route internet traffic through hub VPC | `bool` | `true` | no |
| <a name="input_enable_propagation_to_hub"></a> [enable\_propagation\_to\_hub](#input\_enable\_propagation\_to\_hub) | Whether to propagate spoke routes to hub route table | `bool` | `true` | no |
| <a name="input_enable_spoke_to_spoke_routing"></a> [enable\_spoke\_to\_spoke\_routing](#input\_enable\_spoke\_to\_spoke\_routing) | Whether to enable routing between spoke VPCs | `bool` | `false` | no |
| <a name="input_hub_route_table_id"></a> [hub\_route\_table\_id](#input\_hub\_route\_table\_id) | Hub route table ID (if provided, will override SSM parameter lookup) | `string` | `null` | no |
| <a name="input_hub_vpc_cidr"></a> [hub\_vpc\_cidr](#input\_hub\_vpc\_cidr) | CIDR block of the hub VPC (if not provided, will be retrieved from SSM) | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for resources | `string` | n/a | yes |
| <a name="input_other_spoke_cidrs"></a> [other\_spoke\_cidrs](#input\_other\_spoke\_cidrs) | List of other spoke VPC CIDR blocks for inter-spoke routing | `list(string)` | `[]` | no |
| <a name="input_private_route_table_ids"></a> [private\_route\_table\_ids](#input\_private\_route\_table\_ids) | List of private route table IDs to add routes to | `list(string)` | n/a | yes |
| <a name="input_spoke_route_table_id"></a> [spoke\_route\_table\_id](#input\_spoke\_route\_table\_id) | Spoke route table ID (if provided, will override SSM parameter lookup) | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to use for Transit Gateway attachment | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit Gateway ID (if provided, will override SSM parameter lookup) | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block of the spoke VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to attach to Transit Gateway | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hub_vpc_cidr"></a> [hub\_vpc\_cidr](#output\_hub\_vpc\_cidr) | CIDR block of the hub VPC |
| <a name="output_spoke_vpc_cidr"></a> [spoke\_vpc\_cidr](#output\_spoke\_vpc\_cidr) | CIDR block of the spoke VPC |
| <a name="output_ssm_parameter_spoke_vpc_cidr"></a> [ssm\_parameter\_spoke\_vpc\_cidr](#output\_ssm\_parameter\_spoke\_vpc\_cidr) | SSM parameter name for spoke VPC CIDR |
| <a name="output_ssm_parameter_vpc_attachment_id"></a> [ssm\_parameter\_vpc\_attachment\_id](#output\_ssm\_parameter\_vpc\_attachment\_id) | SSM parameter name for VPC attachment ID |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | ID of the Transit Gateway |
| <a name="output_vpc_attachment_id"></a> [vpc\_attachment\_id](#output\_vpc\_attachment\_id) | ID of the Transit Gateway VPC attachment |
| <a name="output_vpc_attachment_state"></a> [vpc\_attachment\_state](#output\_vpc\_attachment\_state) | State of the Transit Gateway VPC attachment |
<!-- END_TF_DOCS -->
