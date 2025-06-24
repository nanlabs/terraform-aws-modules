# AWS VPC Module

Terraform module that provides an opinionated wrapper around the terraform-aws-modules VPC module with enhanced subnet management, existing VPC support, and integrated parameter storage.

## Why This Wrapper Exists

This wrapper adds significant value over using the base terraform-aws-modules VPC directly:

- **🔄 Existing VPC Support**: Ability to use existing VPCs while maintaining consistent interface and outputs
- **📐 Intelligent Subnet Calculation**: Automatic subnet CIDR calculation based on availability zones with optimized address space utilization
- **💾 Parameter Store Integration**: Stores VPC information in AWS Systems Manager Parameter Store for easy reference by other modules
- **🏷️ Consistent Tagging**: Standardized tag structure across all VPC resources
- **🔧 Opinionated Defaults**: Pre-configured settings for DNS, NAT Gateway, and subnet configurations optimized for enterprise workloads
- **📊 Enhanced Outputs**: Additional computed outputs for better integration with other infrastructure components

## Usage

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "shared-vpc"

  vpc_cidr_block = "10.0.0.0/16"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
