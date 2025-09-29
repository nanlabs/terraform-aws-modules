# AWS Shared Networking Module

This module creates shared networking infrastructure components and stores critical network information in AWS Systems Manager (SSM) Parameter Store for cross-account access. It's designed to support hub-and-spoke network architectures where a central networking account provides connectivity services to spoke accounts.

## Features

- Stores hub VPC information in SSM Parameter Store for cross-account access
- Creates DHCP options for custom domain name resolution
- Configures VPC Flow Logs for network monitoring
- Provides cross-account access to NAT Gateways and Internet Gateways
- Supports multi-account network sharing scenarios
- Centralized network parameter management

## Usage

```hcl
module "shared_networking" {
  source = "./modules/aws/aws-shared-networking"

  name_prefix = "dwh-infra-networking"

  # Hub VPC information
  hub_vpc_id               = "vpc-1234567890abcdef0"
  hub_vpc_cidr            = "10.0.0.0/16"
  hub_internet_gateway_id = "igw-1234567890abcdef0"
  hub_nat_gateway_ids     = ["nat-1234567890abcdef0", "nat-0987654321fedcba0"]

  # Subnet information
  hub_public_subnets  = ["subnet-1234567890abcdef0", "subnet-0987654321fedcba0"]
  hub_private_subnets = ["subnet-abcdef1234567890", "subnet-fedcba0987654321"]

  # Route table information
  hub_public_route_table_ids  = ["rtb-1234567890abcdef0"]
  hub_private_route_table_ids = ["rtb-0987654321fedcba0", "rtb-abcdef1234567890"]

  # Cross-account access configuration
  shared_accounts = {
    workloads = {
      account_id = "653028031609"
      role_name  = "SharedNetworkingRole"
    }
    security = {
      account_id = "608682095927"
      role_name  = "SharedNetworkingRole"
    }
  }

  # Network configuration
  enable_dhcp_options   = true
  domain_name          = "dwh.internal"
  enable_flow_logs     = true
  flow_logs_s3_bucket  = "dwh-networking-flow-logs"

  tags = {
    Environment = "shared"
    Purpose     = "hub-networking"
  }
}
```

## Cross-Account Integration

This module creates SSM parameters that can be accessed by other accounts:

### SSM Parameters Created

- `/{name_prefix}/shared-networking/hub-vpc-id` - Hub VPC ID
- `/{name_prefix}/shared-networking/hub-vpc-cidr` - Hub VPC CIDR block
- `/{name_prefix}/shared-networking/hub-igw-id` - Internet Gateway ID
- `/{name_prefix}/shared-networking/hub-nat-gateway-ids` - NAT Gateway IDs (comma-separated)
- `/{name_prefix}/shared-networking/hub-public-subnets` - Public subnet IDs (comma-separated)
- `/{name_prefix}/shared-networking/hub-private-subnets` - Private subnet IDs (comma-separated)
- `/{name_prefix}/shared-networking/hub-public-route-tables` - Public route table IDs (comma-separated)
- `/{name_prefix}/shared-networking/hub-private-route-tables` - Private route table IDs (comma-separated)

### Spoke Account Access

Spoke accounts can retrieve shared networking information using:

```hcl
data "aws_ssm_parameter" "hub_vpc_id" {
  name = "/dwh-infra-networking/shared-networking/hub-vpc-id"
}

data "aws_ssm_parameter" "hub_nat_gateway_ids" {
  name = "/dwh-infra-networking/shared-networking/hub-nat-gateway-ids"
}

locals {
  hub_vpc_id         = data.aws_ssm_parameter.hub_vpc_id.value
  hub_nat_gateway_ids = split(",", data.aws_ssm_parameter.hub_nat_gateway_ids.value)
}
```

## Network Architecture

This module supports hub-and-spoke network architectures where:

1. **Hub Account (Networking)**: Provides centralized Internet access, NAT Gateways, and shared services
2. **Spoke Accounts**: Connect to the hub via VPC peering or Transit Gateway for Internet access
3. **Shared Resources**: NAT Gateways, Internet Gateways, and DNS services are shared across accounts

## VPC Flow Logs

When `enable_flow_logs` is true, the module configures VPC Flow Logs for network monitoring:

- Flow logs are stored in the specified S3 bucket
- Captures ALL traffic (accepted, rejected, and all)
- Provides network visibility for security and troubleshooting

## DHCP Options

Custom DHCP options can be configured for:

- Custom domain name resolution
- Internal DNS resolution
- Integration with on-premises DNS (if needed)

## Security Considerations

- SSM parameters are created with appropriate tags for governance
- Cross-account access requires proper IAM roles and policies
- VPC Flow Logs provide network traffic visibility
- All resources are tagged for cost allocation and governance

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs)
by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation in the [MODULE.md](./docs/MODULE.md) file.
