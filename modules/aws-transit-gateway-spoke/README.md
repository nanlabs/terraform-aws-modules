# AWS Transit Gateway Spoke Module

This module creates a Transit Gateway spoke configuration for hub-and-spoke networking architecture. It handles:

- VPC attachment to Transit Gateway
- Route table associations and propagation
- Routing configuration for hub and spoke connectivity
- SSM parameters for cross-account reference

## Features

- **VPC Attachment**: Attaches spoke VPC to shared Transit Gateway
- **Route Configuration**: Configures routing to hub VPC and optionally to other spokes
- **Internet Access**: Routes internet traffic through hub VPC NAT Gateway
- **Cross-Account Support**: Works with Transit Gateway shared via AWS Resource Access Manager (RAM)
- **SSM Integration**: Stores attachment information for hub account reference

## Usage

```hcl
module "transit_gateway_spoke" {
  source = "../../aws/aws-transit-gateway-spoke"

  name                    = "workloads-data-lake-develop"
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = "10.2.0.0/16"
  subnet_ids              = module.vpc.private_subnets
  private_route_table_ids = module.vpc.private_route_table_ids
  
  # Hub configuration
  hub_vpc_cidr            = "10.0.0.0/16"
  enable_internet_via_hub = true
  
  # Spoke-to-spoke routing (optional)
  enable_spoke_to_spoke_routing = false
  other_spoke_cidrs            = ["10.1.0.0/16", "10.3.0.0/16"]
  
  tags = local.tags
}
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                          Hub Account                            │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Hub VPC                              │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │    │
│  │  │   Public    │  │   Private   │  │  Database   │      │    │
│  │  │   Subnets   │  │   Subnets   │  │   Subnets   │      │    │
│  │  │             │  │             │  │             │      │    │
│  │  │ NAT Gateway │  │   Bastion   │  │  Endpoints  │      │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘      │    │
│  └─────────────────────────┬───────────────────────────────┘    │
│                            │                                    │
│            ┌───────────────┴───────────────┐                    │
│            │     Transit Gateway           │                    │
│            │  ┌─────────┐  ┌─────────┐     │                    │
│            │  │   Hub   │  │  Spoke  │     │                    │
│            │  │ Routes  │  │ Routes  │     │                    │
│            │  └─────────┘  └─────────┘     │                    │
│            └───────────────┬───────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ (Shared via RAM)
                              │
┌─────────────────────────────┴─────────────────────────────────────┐
│                       Spoke Accounts                             │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │                   Spoke VPC                             │     │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │     │
│  │  │   Private   │  │   Private   │  │  Database   │       │     │
│  │  │   Subnets   │  │   Subnets   │  │   Subnets   │       │     │
│  │  │             │  │             │  │             │       │     │
│  │  │ Workloads   │  │  Glue Jobs  │  │     RDS     │       │     │
│  │  └─────────────┘  └─────────────┘  └─────────────┘       │     │
│  └─────────────────────────────────────────────────────────┘     │
└───────────────────────────────────────────────────────────────────┘
```

## Prerequisites

1. **Transit Gateway Shared**: Transit Gateway must be shared from hub account via AWS RAM
2. **SSM Parameters**: Hub account must store Transit Gateway and route table IDs in SSM:
   - `/dwh-infra-networking/transit-gateway/tgw-id`
   - `/dwh-infra-networking/transit-gateway/spoke-route-table-id`
3. **Cross-Account Access**: Spoke account must have permissions to access Transit Gateway

## Routing Behavior

### Default Configuration
- **Hub Access**: Routes to hub VPC (10.0.0.0/16) via Transit Gateway
- **Internet Access**: Default route (0.0.0.0/0) via Transit Gateway to hub NAT Gateway
- **Local Traffic**: Remains within spoke VPC

### Optional Spoke-to-Spoke
- **Inter-Spoke**: Routes to other spoke CIDRs via Transit Gateway
- **Isolation**: Can be disabled for security requirements

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_ec2_transit_gateway_vpc_attachment.spoke | resource |
| aws_ec2_transit_gateway_route_table_association.spoke | resource |
| aws_ec2_transit_gateway_route_table_propagation.spoke_to_hub | resource |
| aws_route.spoke_to_hub | resource |
| aws_route.spoke_to_spoke | resource |
| aws_route.spoke_default_via_hub | resource |
| aws_ssm_parameter.vpc_attachment_id | resource |
| aws_ssm_parameter.spoke_vpc_info | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for resources | `string` | n/a | yes |
| vpc_id | ID of the VPC to attach to Transit Gateway | `string` | n/a | yes |
| vpc_cidr | CIDR block of the spoke VPC | `string` | n/a | yes |
| subnet_ids | List of subnet IDs to use for Transit Gateway attachment | `list(string)` | n/a | yes |
| private_route_table_ids | List of private route table IDs to add routes to | `list(string)` | n/a | yes |
| hub_vpc_cidr | CIDR block of the hub VPC | `string` | `"10.0.0.0/16"` | no |
| hub_route_table_id | ID of the hub route table for propagation | `string` | `null` | no |
| enable_propagation_to_hub | Whether to propagate spoke routes to hub route table | `bool` | `true` | no |
| enable_spoke_to_spoke_routing | Whether to enable routing between spoke VPCs | `bool` | `false` | no |
| other_spoke_cidrs | List of other spoke VPC CIDR blocks for inter-spoke routing | `list(string)` | `[]` | no |
| enable_internet_via_hub | Whether to route internet traffic through hub VPC | `bool` | `true` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_attachment_id | ID of the Transit Gateway VPC attachment |
| vpc_attachment_state | State of the Transit Gateway VPC attachment |
| transit_gateway_id | ID of the Transit Gateway |
| spoke_route_table_id | ID of the spoke route table |
| spoke_vpc_cidr | CIDR block of the spoke VPC |
| hub_vpc_cidr | CIDR block of the hub VPC |
| ssm_parameter_vpc_attachment_id | SSM parameter name for VPC attachment ID |
| ssm_parameter_spoke_vpc_cidr | SSM parameter name for spoke VPC CIDR |

## Migration from VPC Peering

When migrating from VPC peering to Transit Gateway:

1. **Remove VPC Peering**: Comment out or remove VPC peering module
2. **Add Transit Gateway**: Add this module with appropriate configuration
3. **Update Routes**: Module automatically handles route table updates
4. **Test Connectivity**: Verify hub and internet connectivity after deployment

## Cost Considerations

- **Transit Gateway**: $0.05/hour per attachment + $0.02/GB data processing
- **Data Transfer**: Standard AWS data transfer charges apply
- **NAT Gateway**: Shared NAT Gateway in hub reduces costs compared to per-VPC NAT

## Security Considerations

- **Network Isolation**: Spoke VPCs remain isolated unless explicitly configured
- **Route Propagation**: Carefully control which routes are propagated to hub
- **Security Groups**: Update security group rules for new network topology
- **NACLs**: Review Network ACLs for Transit Gateway subnet access
