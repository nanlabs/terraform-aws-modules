# aws-transit-gateway

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw"></a> [tgw](#module\_tgw) | terraform-aws-modules/transit-gateway/aws | ~> 2.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route_table.hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.hub_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.hub_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ram_principal_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway | `number` | `64512` | no |
| <a name="input_create_hub_route_table"></a> [create\_hub\_route\_table](#input\_create\_hub\_route\_table) | Create dedicated route table for hub VPCs | `bool` | `true` | no |
| <a name="input_create_isolated_route_table"></a> [create\_isolated\_route\_table](#input\_create\_isolated\_route\_table) | Create dedicated route table for isolated VPCs | `bool` | `false` | no |
| <a name="input_create_spoke_route_table"></a> [create\_spoke\_route\_table](#input\_create\_spoke\_route\_table) | Create dedicated route table for spoke VPCs | `bool` | `true` | no |
| <a name="input_cross_account_principals"></a> [cross\_account\_principals](#input\_cross\_account\_principals) | List of AWS account IDs to share the Transit Gateway with | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Transit Gateway | `string` | `"Transit Gateway for hub-and-spoke networking"` | no |
| <a name="input_enable_auto_accept_shared_attachments"></a> [enable\_auto\_accept\_shared\_attachments](#input\_enable\_auto\_accept\_shared\_attachments) | Whether resource attachment requests are automatically accepted | `bool` | `false` | no |
| <a name="input_enable_cross_account_sharing"></a> [enable\_cross\_account\_sharing](#input\_enable\_cross\_account\_sharing) | Enable sharing Transit Gateway with other AWS accounts | `bool` | `true` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Whether resource attachments are automatically associated with the default association route table | `bool` | `false` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `false` | no |
| <a name="input_hub_vpc_id"></a> [hub\_vpc\_id](#input\_hub\_vpc\_id) | VPC ID of the hub/infrastructure VPC to attach | `string` | `null` | no |
| <a name="input_hub_vpc_private_subnet_ids"></a> [hub\_vpc\_private\_subnet\_ids](#input\_hub\_vpc\_private\_subnet\_ids) | List of private subnet IDs from the hub VPC for TGW attachment | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Transit Gateway | `string` | n/a | yes |
| <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals) | Indicates whether principals outside your organization can be associated with a resource share | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hub_route_table_id"></a> [hub\_route\_table\_id](#output\_hub\_route\_table\_id) | Hub route table identifier |
| <a name="output_hub_vpc_attachment_id"></a> [hub\_vpc\_attachment\_id](#output\_hub\_vpc\_attachment\_id) | Hub VPC attachment identifier |
| <a name="output_isolated_route_table_id"></a> [isolated\_route\_table\_id](#output\_isolated\_route\_table\_id) | Isolated route table identifier |
| <a name="output_ram_resource_share_arn"></a> [ram\_resource\_share\_arn](#output\_ram\_resource\_share\_arn) | RAM resource share ARN |
| <a name="output_ram_resource_share_id"></a> [ram\_resource\_share\_id](#output\_ram\_resource\_share\_id) | RAM resource share identifier |
| <a name="output_spoke_route_table_id"></a> [spoke\_route\_table\_id](#output\_spoke\_route\_table\_id) | Spoke route table identifier |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | EC2 Transit Gateway Amazon Resource Name (ARN) |
| <a name="output_transit_gateway_association_default_route_table_id"></a> [transit\_gateway\_association\_default\_route\_table\_id](#output\_transit\_gateway\_association\_default\_route\_table\_id) | Identifier of the default association route table |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
| <a name="output_transit_gateway_propagation_default_route_table_id"></a> [transit\_gateway\_propagation\_default\_route\_table\_id](#output\_transit\_gateway\_propagation\_default\_route\_table\_id) | Identifier of the default propagation route table |
| <a name="output_transit_gateway_route_table_default_association_route_table"></a> [transit\_gateway\_route\_table\_default\_association\_route\_table](#output\_transit\_gateway\_route\_table\_default\_association\_route\_table) | Boolean whether the Gateway uses its default association route table |
| <a name="output_transit_gateway_route_table_default_propagation_route_table"></a> [transit\_gateway\_route\_table\_default\_propagation\_route\_table](#output\_transit\_gateway\_route\_table\_default\_propagation\_route\_table) | Boolean whether the Gateway uses its default propagation route table |
<!-- END_TF_DOCS -->
