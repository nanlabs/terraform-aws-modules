# Complete Enterprise Setup Example

This example demonstrates a complete enterprise-grade infrastructure setup with EKS, RDS Aurora, MSK, DocumentDB, monitoring, and security best practices.

## Architecture

- **VPC**: Multi-AZ VPC with comprehensive subnetting
- **EKS**: Production-ready Kubernetes cluster with multiple node groups
- **RDS Aurora**: PostgreSQL cluster with read replicas
- **MSK**: Apache Kafka cluster for event streaming
- **DocumentDB**: MongoDB-compatible database
- **Bastion**: Secure bastion host for database access
- **IAM**: Comprehensive RBAC and service accounts
- **Monitoring**: VPC Flow Logs and CloudWatch monitoring

## Prerequisites

1. AWS CLI configured with administrative permissions
2. kubectl installed
3. Terraform >= 1.0
4. Route53 hosted zone (for MSK DNS)

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration (this will take 20-30 minutes)
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name complete-enterprise-prod
```

## Cleanup

⚠️ **Warning**: This will destroy all resources including databases. Make sure to backup data first.

```bash
terraform destroy
```

## Estimated Cost

- **VPC**: ~$90/month (3 NAT Gateways)
- **EKS**: ~$72/month (Control plane)
- **Node Groups**: ~$400/month (Mixed instance types)
- **RDS Aurora**: ~$120/month (db.r5.large + read replica)
- **MSK**: ~$150/month (3 x kafka.m5.large)
- **DocumentDB**: ~$100/month (2 x db.t3.medium)
- **Bastion**: ~$8/month (t3.nano)
- **Total**: ~$940/month

## Resources Created

- 1 VPC with 3 AZs and full subnet hierarchy
- 1 EKS cluster with OIDC provider
- 3 EKS node groups (system, application, GPU)
- 1 RDS Aurora PostgreSQL cluster
- 1 MSK Apache Kafka cluster
- 1 DocumentDB cluster
- 1 Bastion host with VPC endpoints
- Comprehensive IAM roles and policies
- Security groups and NACLs
- VPC Flow Logs and monitoring
