# Simple Web App Example

This example demonstrates how to deploy a simple web application using AWS Amplify with a custom VPC.

## Architecture

- **VPC**: Custom VPC with public/private subnets
- **Amplify**: Frontend hosting with GitHub integration
- **SSM**: Parameter store for GitHub PAT

## Prerequisites

1. AWS CLI configured
2. GitHub Personal Access Token stored in Parameter Store
3. GitHub repository with a web application

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Estimated Cost

- **VPC**: ~$45/month (NAT Gateway)
- **Amplify**: ~$1/month (for build minutes)
- **Total**: ~$46/month

## Resources Created

- 1 VPC with 3 AZs
- 3 Public subnets
- 3 Private subnets
- 1 Internet Gateway
- 1 NAT Gateway
- 1 Amplify Application
- Route53 records (if domain configured)
