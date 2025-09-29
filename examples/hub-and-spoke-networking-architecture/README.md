# Hub-and-Spoke Networking Architecture Example

This example demonstrates a comprehensive hub-and-spoke networking architecture using AWS Transit Gateway, shared networking services, and centralized egress control following AWS Well-Architected Framework principles.

## Architecture

- **Shared Services VPC (Hub)**: Central hub for shared services and management
- **Egress VPC**: Centralized internet egress with security controls
- **Transit Gateway**: Central networking hub for multi-VPC connectivity
- **Spoke VPCs**: Workload-specific VPCs (dev, staging, prod)
- **VPC Endpoints**: Secure private connectivity to AWS services
- **Bastion Host**: Secure access point with SSM Session Manager

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. Multiple AWS accounts setup (optional but recommended)
3. Terraform >= 1.0
4. Understanding of AWS networking concepts

## Architecture Components

### Hub VPC (Shared Services)

- **Purpose**: Host shared services and management tools
- **Subnets**: Public, private, and database subnets across 3 AZs
- **Services**: Bastion hosts, shared databases, monitoring tools
- **Connectivity**: Central point for all spoke VPCs

### Egress VPC

- **Purpose**: Centralized internet access with security controls
- **Components**: NAT Gateways, security appliances, web filtering
- **Benefits**: Centralized security policies, cost optimization

### Spoke VPCs

- **Development**: Development and testing workloads
- **Staging**: Pre-production validation environment
- **Production**: Live production workloads
- **Isolation**: Network segmentation between environments

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan -var-file="terraform.tfvars"

# Apply the configuration (this will take 15-20 minutes)
terraform apply -var-file="terraform.tfvars"
```

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and customize:

```hcl
project_name = "my-hub-spoke-network"
environment  = "shared"
aws_region   = "us-east-1"

# VPC CIDR blocks (ensure no overlap)
hub_vpc_cidr     = "10.0.0.0/16"
egress_vpc_cidr  = "10.1.0.0/16"
dev_vpc_cidr     = "10.10.0.0/16"
staging_vpc_cidr = "10.20.0.0/16"
prod_vpc_cidr    = "10.30.0.0/16"

# Security configuration
bastion_allowed_cidrs = ["203.0.113.0/24"]  # Your office IP
```

## Network Traffic Flow

### Internet Access
```
Spoke VPC → Transit Gateway → Egress VPC → NAT Gateway → Internet
```

### Inter-VPC Communication
```
Spoke VPC A → Transit Gateway → Hub VPC → Transit Gateway → Spoke VPC B
```

### Management Access
```
Internet → Hub VPC Bastion → Transit Gateway → Spoke VPC Resources
```

## Cleanup

⚠️ **Warning**: This will destroy all networking infrastructure. Ensure no dependent resources exist.

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Estimated Cost

- **Transit Gateway**: $36/month (base charge)
- **TGW Attachments**: $36/month (5 attachments × $36)
- **Data Processing**: ~$20/month (estimated cross-AZ traffic)
- **Hub VPC NAT Gateway**: $45/month (1 NAT Gateway)
- **Egress VPC NAT Gateways**: $135/month (3 NAT Gateways)
- **Bastion Hosts**: $24/month (3 × t3.nano)
- **VPC Endpoints**: $60/month (shared endpoints)
- **VPC Flow Logs**: $15/month (5 VPCs)
- **Total**: ~$371/month

## Resources Created

### Networking
- 1 Transit Gateway with 5 VPC attachments
- 5 VPCs (hub, egress, dev, staging, prod)
- 15 subnets (3 per VPC across 3 AZs)
- 4 NAT Gateways (centralized egress pattern)
- Route tables and security groups
- VPC Flow Logs for all VPCs

### Security
- 3 Bastion hosts (one per environment)
- Security groups with least privilege
- NACLs for additional security layers
- VPC endpoints for secure AWS API access

### Monitoring
- CloudWatch Log Groups for VPC Flow Logs
- SSM parameters for network discovery
- Route 53 private hosted zones

## Security Features

- **Network Segmentation**: Complete isolation between environments
- **Centralized Egress**: All internet traffic through controlled egress points
- **Least Privilege**: Security groups follow minimal access principles
- **Monitoring**: Comprehensive VPC Flow Logs
- **Private Connectivity**: VPC endpoints for AWS services
- **Secure Access**: SSM Session Manager for bastion access

## Routing Strategy

### Hub Route Table
- Routes to all spoke VPCs
- Route to egress VPC for internet access
- Local VPC routes

### Spoke Route Tables
- Route to hub VPC for shared services
- Route to egress VPC for internet access
- No direct spoke-to-spoke communication

### Egress Route Table
- Route to hub VPC
- Default route to internet gateway
- NAT Gateway routes for private subnets

## Scalability

This architecture can easily scale to support:
- Additional spoke VPCs (up to 5000 per Transit Gateway)
- Cross-region connectivity via Transit Gateway peering
- On-premises connectivity via VPN or Direct Connect
- Additional AWS accounts via Resource Sharing

## Monitoring and Troubleshooting

### VPC Flow Logs
- Enabled on all VPCs and subnets
- Stored in CloudWatch Logs
- 1-minute aggregation for detailed monitoring

### Transit Gateway Monitoring
- CloudWatch metrics for packet counts and bytes
- Route table monitoring
- Attachment status monitoring

### Network Testing Tools
- VPC Reachability Analyzer
- AWS Config for compliance monitoring
- CloudTrail for API call auditing

