# AWS VPC Module

Complete Terraform wrapper around the official `terraform-aws-modules/vpc/aws` module with opinionated defaults and enhanced functionality.

## Why This Wrapper Exists

This wrapper adds significant value over using the base terraform-aws-modules VPC directly:

- **🎛️ Complete Wrapper**: Exposes ALL variables from the underlying module with sensible defaults
- **🔄 Existing VPC Support**: Can work with existing VPCs while maintaining consistent interface
- **📐 Intelligent Subnet Calculation**: Automatic subnet CIDR calculation based on availability zones
- **📋 Parameter Store Integration**: Stores VPC information in AWS Systems Manager Parameter Store
- **🏷️ Consistent Tagging**: Standardized tag structure across all VPC resources
- **🛡️ Security Defaults**: Pre-configured security settings (Flow Logs, DNS, etc.)
- **📊 Enhanced Outputs**: All outputs from underlying module plus custom additions

- **Complete Wrapper**: Exposes ALL variables from the underlying module with sensible defaults
- **Existing VPC Support**: Can work with existing VPCs while maintaining consistent interface
- **📐 Intelligent Subnet Calculation**: Automatic subnet CIDR calculation based on availability zones
- **💾 Parameter Store Integration**: Stores VPC information in AWS Systems Manager Parameter Store
- **🏷️ Consistent Tagging**: Standardized tag structure across all VPC resources
- **�️ Security Defaults**: Pre-configured security settings (Flow Logs, DNS, etc.)
- **📊 Enhanced Outputs**: All outputs from underlying module plus custom additions

## Usage

### Simple Usage (Recommended)

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "my-vpc"
  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

### Advanced Usage (Full Customization)

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  # Shared variables
  name = "my-vpc"
  tags = { Environment = "production" }

  # VPC Configuration
  cidr                     = "172.16.0.0/16"
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_vpn_gateway       = true
  enable_flow_log          = true
  flow_log_destination_type = "s3"

  # Subnets
  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.11.0/24", "172.16.12.0/24"]
  database_subnets = ["172.16.21.0/24", "172.16.22.0/24"]

  # Custom subnet tags
  public_subnet_tags = {
    Type = "public"
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    Type = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
```

## Module Structure

This module follows our standardized pattern:

- `variables.tf` - Shared variables (name, tags, azs_count)
- `vpc-variables.tf` - All VPC-specific variables (complete wrapper)
- `vpc.tf` - VPC module implementation
- `outputs.tf` - Shared outputs (name, azs, legacy aliases, SSM parameters)
- `vpc-outputs.tf` - All VPC-specific outputs (complete wrapper)

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 6.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
