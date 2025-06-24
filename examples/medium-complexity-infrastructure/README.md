# Medium Complexity Infrastructure Example

This example demonstrates a medium-complexity infrastructure setup with EKS cluster, RDS database, and supporting infrastructure.

## Architecture

- **VPC**: Custom VPC with public/private/database subnets
- **EKS**: Kubernetes cluster with managed node groups
- **RDS**: PostgreSQL database with backup and monitoring
- **Bastion**: Secure bastion host for database access
- **IAM**: Custom roles and policies

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. kubectl installed
3. Terraform >= 1.0

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name medium-complexity-dev
```

## Cleanup

```bash
terraform destroy
```

## Estimated Cost

- **VPC**: ~$45/month (NAT Gateway)
- **EKS**: ~$72/month (Control plane)
- **Node Groups**: ~$150/month (3 x t3.medium)
- **RDS**: ~$25/month (db.t3.micro)
- **Bastion**: ~$8/month (t3.nano)
- **Total**: ~$300/month

## Resources Created

- 1 VPC with 3 AZs
- 1 EKS cluster with OIDC provider
- 2 EKS node groups (system and application)
- 1 RDS PostgreSQL instance
- 1 Bastion host
- Custom IAM roles and policies
- Security groups and NACLs
