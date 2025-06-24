# AWS EKS Cluster Module

Terraform module that provides an opinionated wrapper around the CloudPosse EKS modules with integrated VPC CNI optimization, node group management, and OIDC configuration.

## Why This Wrapper Exists

This wrapper adds significant value over using the base CloudPosse modules directly:

- **🚀 VPC CNI Optimization**: Pre-configured VPC CNI addon with IP warming settings optimized for faster pod startup times
- **🔧 Integrated Node Groups**: Simplified node group creation with sensible defaults and timeout configurations
- **🔑 OIDC Integration**: Built-in OIDC provider setup for service account authentication
- **📊 Enhanced Monitoring**: Pre-configured CloudWatch logging and monitoring with optimized retention periods
- **🛡️ Security Hardening**: API-only authentication mode with proper access control configuration
- **⚙️ Production-Ready Defaults**: Opinionated settings based on EKS best practices for enterprise workloads

## Usage

```hcl
module "eks" {
  source = "../../modules/aws-eks"

  name            = "my-eks-cluster"

  region                  = "us-east-1"
  vpc_id                  = "vpc-xxxxxxxx"
  private_subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  public_subnets          = ["subnet-xxxxxxxx", "subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  kubernetes_version      = "1.30"
  tags                    = {
    Environment = "production"
  }
  oidc_provider_enabled   = true
  private_ipv6_enabled    = false
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
  cluster_log_retention_period = 90
  cluster_encryption_config_enabled = true
  cluster_encryption_config_kms_key_id = "arn:aws:kms:us-east-1:xxxxxxxxxx:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  cluster_encryption_config_kms_key_enable_key_rotation = true
  cluster_encryption_config_kms_key_deletion_window_in_days = 30
  cluster_encryption_config_kms_key_policy = ""
  cluster_encryption_config_resources = ["secrets"]
  allowed_security_group_ids = ["sg-xxxxxxxx"]
  allowed_cidr_blocks        = ["10.0.0.0/16"]

  addons = [
    {
      addon_name    = "vpc-cni"
      addon_version = null
    },
    {
      addon_name    = "kube-proxy"
      addon_version = null
    },
    {
      addon_name    = "coredns"
      addon_version = null
    }
  ]

  node_groups = [
    {
      instance_types          = ["m5.large"]
      min_size                = 3
      max_size                = 6
      desired_size            = 4
      health_check_type       = "EC2"
      kubernetes_labels       = {
        environment = "production"
      }
    }
  ]
}
```

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
