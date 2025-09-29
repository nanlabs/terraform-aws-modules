# AWS Transit Gateway Module

This module creates an AWS Transit Gateway for hub-and-spoke networking architecture, replacing the previous VPC peering approach with a more scalable and manageable solution.

## Features

- **Transit Gateway**: Central routing hub for multiple VPCs
- **Custom Route Tables**: Separate routing domains for hub, spoke, and isolated VPCs
- **Cross-Account Sharing**: Resource sharing via AWS RAM for multi-account architectures
- **VPC Attachments**: Automated attachment of hub infrastructure VPC
- **Flexible Configuration**: Support for various networking topologies

## Usage

### Basic Usage

```hcl
module "transit_gateway" {
  source = "../../../modules/aws/aws-transit-gateway"

  name        = "dwh-infrastructure-tgw"
  description = "Transit Gateway for Data Warehouse infrastructure"

  # Hub VPC attachment
  hub_vpc_id                 = module.vpc.vpc_id
  hub_vpc_private_subnet_ids = module.vpc.private_subnets

  # Cross-account sharing
  enable_cross_account_sharing = true
  cross_account_principals = [
    "816582314932", # develop account
    "072951075112", # staging account
    "653028031609"  # production account
  ]

  tags = {
    Name        = "dwh-infrastructure-tgw"
    Environment = "shared"
    Purpose     = "hub-and-spoke-networking"
  }
}
```

### Advanced Configuration

```hcl
module "transit_gateway" {
  source = "../../../modules/aws/aws-transit-gateway"

  name        = "dwh-infrastructure-tgw"
  description = "Transit Gateway for Data Warehouse infrastructure"

  # Transit Gateway configuration
  amazon_side_asn                           = 64512
  enable_auto_accept_shared_attachments     = false
  enable_default_route_table_association    = false
  enable_default_route_table_propagation    = false

  # Route tables
  create_hub_route_table      = true
  create_spoke_route_table    = true
  create_isolated_route_table = false

  # Hub VPC attachment
  hub_vpc_id                 = module.vpc.vpc_id
  hub_vpc_private_subnet_ids = module.vpc.private_subnets

  # Cross-account sharing
  enable_cross_account_sharing = true
  ram_allow_external_principals = false
  cross_account_principals = [
    "816582314932", # develop account
    "072951075112", # staging account
    "653028031609"  # production account
  ]

  tags = local.tags
}
```

## Architecture

This module implements a hub-and-spoke networking architecture where:

1. **Hub VPC** (Infrastructure account): Contains shared services, bastion, NAT gateways
2. **Spoke VPCs** (Workload accounts): Application-specific VPCs that connect through the hub
3. **Route Tables**: Separate routing domains to control traffic flow

```
┌─────────────────────────────────────┐
│         Infrastructure Account      │
│                                     │
│  ┌─────────────┐  ┌───────────────┐ │
│  │   Hub VPC   │  │ Transit       │ │
│  │ (10.0.0.0/16│──│ Gateway       │ │
│  │             │  │               │ │
│  └─────────────┘  └───────┬───────┘ │
└────────────────────────────┼─────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
┌────────▼────────┐ ┌────────▼────────┐ ┌────────▼────────┐
│  Develop VPC    │ │  Staging VPC    │ │ Production VPC  │
│ (10.2.0.0/16)   │ │ (10.3.0.0/16)   │ │ (10.1.0.0/16)   │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## Migration from VPC Peering

This module is designed to replace the existing VPC peering solution. Key differences:

### Before (VPC Peering)
- Point-to-point connections between VPCs
- Complex routing with multiple peering connections
- Limited scalability (maximum 125 peering connections per VPC)

### After (Transit Gateway)
- Central hub for all VPC connections
- Simplified routing through route tables
- Unlimited VPC attachments
- Better performance for cross-VPC communication

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| tgw | terraform-aws-modules/transit-gateway/aws | ~> 2.13.0 |

## Resources

| Name | Type |
|------|------|
| aws_ec2_transit_gateway_route_table.hub | resource |
| aws_ec2_transit_gateway_route_table.spoke | resource |
| aws_ec2_transit_gateway_route_table.isolated | resource |
| aws_ec2_transit_gateway_vpc_attachment.hub_vpc | resource |
| aws_ec2_transit_gateway_route_table_association.hub_vpc | resource |
| aws_ram_resource_share.tgw | resource |
| aws_ram_resource_association.tgw | resource |
| aws_ram_principal_association.tgw | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Transit Gateway | `string` | n/a | yes |
| description | Description of the Transit Gateway | `string` | `"Transit Gateway for hub-and-spoke networking"` | no |
| amazon_side_asn | The Autonomous System Number (ASN) for the Amazon side of the gateway | `number` | `64512` | no |
| enable_auto_accept_shared_attachments | Whether resource attachment requests are automatically accepted | `bool` | `false` | no |
| enable_default_route_table_association | Whether resource attachments are automatically associated with the default association route table | `bool` | `false` | no |
| enable_default_route_table_propagation | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `false` | no |
| enable_cross_account_sharing | Enable sharing Transit Gateway with other AWS accounts | `bool` | `true` | no |
| ram_allow_external_principals | Indicates whether principals outside your organization can be associated with a resource share | `bool` | `false` | no |
| cross_account_principals | List of AWS account IDs to share the Transit Gateway with | `list(string)` | `[]` | no |
| create_hub_route_table | Create dedicated route table for hub VPCs | `bool` | `true` | no |
| create_spoke_route_table | Create dedicated route table for spoke VPCs | `bool` | `true` | no |
| create_isolated_route_table | Create dedicated route table for isolated VPCs | `bool` | `false` | no |
| hub_vpc_id | VPC ID of the hub/infrastructure VPC to attach | `string` | `null` | no |
| hub_vpc_private_subnet_ids | List of private subnet IDs from the hub VPC for TGW attachment | `list(string)` | `[]` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| transit_gateway_id | EC2 Transit Gateway identifier |
| transit_gateway_arn | EC2 Transit Gateway Amazon Resource Name (ARN) |
| hub_route_table_id | Hub route table identifier |
| spoke_route_table_id | Spoke route table identifier |
| isolated_route_table_id | Isolated route table identifier |
| hub_vpc_attachment_id | Hub VPC attachment identifier |
| ram_resource_share_id | RAM resource share identifier |
| ram_resource_share_arn | RAM resource share ARN |

## Examples

See the [examples](./examples/) directory for working examples to reference:

- [Basic Transit Gateway](./examples/basic/)
- [Multi-account Transit Gateway](./examples/multi-account/)
- [Hub and Spoke Architecture](./examples/hub-and-spoke/)

## References

- [AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)
- [terraform-aws-modules/transit-gateway](https://registry.terraform.io/modules/terraform-aws-modules/transit-gateway/aws/latest)
