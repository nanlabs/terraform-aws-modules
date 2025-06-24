# AWS MSK (Amazon Managed Streaming for Apache Kafka) Module

Terraform module that provides an opinionated wrapper around the CloudPosse MSK module with enhanced security configuration, integrated DNS management, and production-ready defaults.

## Why This Wrapper Exists

This wrapper adds significant value over using the base CloudPosse MSK module directly:

- **🔐 Enhanced Security**: Pre-configured SASL/SCRAM authentication, IAM authentication, and TLS encryption options
- **🌐 DNS Integration**: Integrated Route53 DNS record management for broker endpoints
- **📊 Comprehensive Logging**: Pre-configured CloudWatch and S3 logging with proper IAM permissions
- **🛡️ Network Security**: Advanced security group configuration with customizable rules and CIDR block management
- **⚙️ Production-Ready Defaults**: Opinionated broker sizing, monitoring, and performance configurations
- **🏷️ Consistent Tagging**: Standardized tag structure across all MSK cluster resources

## Prerequisites

Before using this module, ensure you have:

- An AWS account with MSK permissions
- VPC and subnets configured for the MSK cluster
- Route53 hosted zone (if using DNS integration)

## Usage

To use this module, include the following code in your Terraform configuration:

```hcl
module "msk_cluster" {
  source = "../../modules/aws-msk"

  name              = "my-msk-cluster"
  kafka_version     = "2.8.0"
  broker_instance_type = "kafka.m5.large"
  broker_per_zone   = 1
  private_subnets   = ["subnet-12345678", "subnet-87654321"]
  vpc_id            = "vpc-12345678"

  # DNS configuration
  zone_id = "Z1234567890"

  # Security configuration
  client_sasl_scram_enabled = true
  client_tls_auth_enabled   = true

  tags = {
    Environment = "production"
    Team        = "data-platform"
  }
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
| <a name="module_kafka"></a> [kafka](#module\_kafka) | cloudposse/msk-apache-kafka-cluster/aws | 2.4.0 |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
