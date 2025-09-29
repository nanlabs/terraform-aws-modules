# Modules Guide

This guide explains how to use and create modules in this repository, along with a complete catalog of available modules.

## 📦 Complete Module Catalog

### AWS Infrastructure Modules

#### 🌐 AWS VPC

- **Path**: `modules/aws-vpc/`
- **Description**: Complete wrapper around terraform-aws-modules/vpc/aws with strong defaults
- **Features**:
  - Multi-AZ subnets (public, private, database)
  - NAT Gateway, Internet Gateway, Route tables
  - VPC Flow Logs, DNS configuration
  - SSM parameter storage for outputs
  - Complete customization support
- **Use Cases**: Network foundation, multi-AZ setup, isolated environments
- **Example Cost**: ~$45/month (with NAT Gateway)
- **Module Version**: terraform-aws-modules/vpc/aws v5.21.0

**Simple Usage:**
```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "my-vpc"
  tags = {
    Environment = "production"
  }
}
```

**Advanced Usage:**
```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "my-vpc"
  tags = { Environment = "production" }

  # Full customization available
  cidr                = "172.16.0.0/16"
  enable_nat_gateway  = true
  single_nat_gateway  = false
  enable_flow_log     = true

  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.11.0/24", "172.16.12.0/24"]
  database_subnets = ["172.16.21.0/24", "172.16.22.0/24"]
}
```

#### ⚡ AWS EKS

- **Path**: `modules/aws-eks/`
- **Description**: Managed Kubernetes with essential addons
- **Features**: Cluster setup, node groups, IRSA, CNI configuration
- **Use Cases**: Microservices, container orchestration, modern applications
- **Example Cost**: ~$73/month (cluster) + worker nodes

#### 🗄️ AWS RDS

- **Path**: `modules/aws-rds/`
- **Description**: Complete wrapper around terraform-aws-modules/rds/aws with strong defaults
- **Features**:
  - Multi-AZ, automated backups, monitoring
  - Performance Insights, CloudWatch logs
  - Encryption, parameter groups, option groups
  - SSM parameter storage for connection info
  - Complete customization support
- **Use Cases**: Application databases, data persistence, OLTP workloads
- **Example Cost**: ~$15-200/month (depending on instance size)
- **Module Version**: terraform-aws-modules/rds/aws v6.11.0

**Simple Usage:**
```hcl
module "rds" {
  source = "../../modules/aws-rds"

  name = "my-app-db"
  tags = { Environment = "production" }

  engine          = "postgres"
  engine_version  = "16.3"
  instance_class  = "db.t4g.micro"

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group
}
```

**Advanced Usage:**
```hcl
module "rds" {
  source = "../../modules/aws-rds"

  name = "my-production-db"
  tags = { Environment = "production" }

  # Full customization available
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.r6g.large"
  allocated_storage    = 100
  max_allocated_storage = 1000
  multi_az            = true

  performance_insights_enabled = true
  monitoring_interval          = 60
  backup_retention_period      = 14
}
```

#### 🗄️ AWS RDS Aurora

- **Path**: `modules/aws-rds-aurora/`
- **Description**: High-performance Aurora cluster
- **Features**: Serverless options, global database, read replicas
- **Use Cases**: High-availability databases, read-heavy workloads, global apps
- **Example Cost**: ~$25-500/month (depending on configuration)

#### 📨 AWS MSK

- **Path**: `modules/aws-msk/`
- **Description**: Managed Apache Kafka streaming
- **Features**: Multi-AZ clusters, monitoring, security configurations
- **Use Cases**: Event streaming, data pipelines, real-time analytics
- **Example Cost**: ~$180/month (3-broker cluster)

#### 🏰 AWS Bastion

- **Path**: `modules/aws-bastion/`
- **Description**: Secure jump host with SSM
- **Features**: SSM Session Manager, security groups, key management
- **Use Cases**: Secure access, troubleshooting, compliance requirements
- **Example Cost**: ~$8/month (t3.micro)

#### 📊 AWS DocumentDB

- **Path**: `modules/aws-docdb/`
- **Description**: MongoDB-compatible database
- **Features**: Cluster setup, backup, monitoring, security
- **Use Cases**: Document storage, NoSQL applications, MongoDB migration
- **Example Cost**: ~$55/month (basic cluster)

#### 👤 AWS IAM Role

- **Path**: `modules/aws-iam-role/`
- **Description**: IAM roles with best practices
- **Features**: Assume role policies, permission boundaries, trust relationships
- **Use Cases**: Service permissions, access control, IRSA
- **Example Cost**: Free (AWS IAM has no charges)

#### 🌍 AWS Amplify App

- **Path**: `modules/aws-amplify-app/`
- **Description**: Frontend hosting and CI/CD
- **Features**: Git-based deployments, custom domains, branch-based environments
- **Use Cases**: Static sites, SPAs, JAMstack applications
- **Example Cost**: ~$1-15/month (depending on usage)

### Other Cloud Providers

#### 🍃 MongoDB Atlas Cluster

- **Path**: `modules/mongodb-atlas-cluster/`
- **Description**: Managed MongoDB in the cloud
- **Features**: Multi-cloud support, backup, monitoring, scaling
- **Use Cases**: Global databases, serverless apps, MongoDB-as-a-Service
- **Example Cost**: ~$57/month (M10 cluster)

### 🔐 Security, Encryption & Governance Modules (Additional)

#### 🔐 AWS CloudTrail

- **Path**: `modules/aws-cloudtrail/`
- **Description**: Configures account / organization-wide logging.
- **Use Cases**: Audit trails, compliance evidence, security incident investigation.

#### 🛡️ AWS Config

- **Path**: `modules/aws-config/`
- **Description**: Tracks resource configuration history and evaluates rules.
- **Use Cases**: Governance, drift detection, compliance frameworks (CIS, HIPAA).

#### 🔐 AWS GitHub OIDC Provider

- **Path**: `modules/aws-github-oidc-provider/`
- **Description**: Federated identity provider for GitHub Actions (no static keys).
- **Use Cases**: Secure CI/CD deployments, least-privilege ephemeral credentials.

### 🧱 Data Lake & Analytics Modules

#### 🧱 AWS Data Lake Infrastructure

- **Path**: `modules/aws-data-lake-infrastructure/`
- **Description**: Creates medallion-zone S3 bucket structure (raw/bronze, processed/silver, curated/gold, temp) with optional lifecycle policies.
- **Use Cases**: Analytics landing zones, ETL staging, governed storage layout.

#### 🔐 AWS Data Lake Encryption

- **Path**: `modules/aws-data-lake-encryption/`
- **Description**: Centralized KMS keys (S3 + Glue) for secure data operations.
- **Use Cases**: Multi-account encryption, central key rotation, compliance.

#### 🧬 AWS Glue Code Registry

- **Path**: `modules/aws-glue-code-registry/`
- **Description**: Manages Glue Schema / code registries for versioned serialization.
- **Use Cases**: Schema governance, event-driven ETL, compatibility tracking.

#### 📚 AWS Glue Data Lake Catalog

- **Path**: `modules/aws-glue-data-lake-catalog/`
- **Description**: Scaffolds Glue databases and tables for structured zones.
- **Use Cases**: Metadata discovery, unified data cataloging.

#### 🛠️ AWS Glue Jobs

- **Path**: `modules/aws-glue-jobs/`
- **Description**: Wrapper for defining multiple Glue Spark jobs via a map (complete wrapper + command enforcement).
- **Use Cases**: Batch ETL, transformations, enrichment pipelines.

#### 🔄 AWS Glue Workflow

- **Path**: `modules/aws-glue-workflow/`
- **Description**: Orchestrates Glue jobs with triggers (scheduled / dependency).
- **Use Cases**: Chained ETL pipelines, periodic processing, SLA alignment.

### 🛰️ Networking & Shared Services

#### ✈️ AWS Transit Gateway

- **Path**: `modules/aws-transit-gateway/`
- **Description**: Central routing hub for multi-VPC / multi-account architectures.
- **Use Cases**: Hub-and-spoke networking, segmentation, centralized egress.

#### 🛰️ AWS Transit Gateway Spoke

- **Path**: `modules/aws-transit-gateway-spoke/`
- **Description**: Attaches workload VPCs to a Transit Gateway.
- **Use Cases**: Network expansion, environment isolation.

#### 🕸️ AWS Shared Networking

- **Path**: `modules/aws-shared-networking/`
- **Description**: Shared services networking baseline (e.g., endpoints, DNS - depending on implementation).
- **Use Cases**: Centralized networking services account.

#### 📦 AWS TF State Backend

- **Path**: `modules/aws-tfstate-backend/`
- **Description**: Provisions S3 bucket + DynamoDB table for remote Terraform state locking.
- **Use Cases**: Team collaboration, drift prevention, CI automation.

## 🧩 Multi-Account Pattern Reference

The repository includes a simulated multi-account example: `examples/multi-account-data-platform`.

Key concepts demonstrated:

1. Provider aliases standing in for account boundaries (`aws.infrastructure`, `aws.workloads_dev`, future staging/prod commented)
2. Centralized encryption using `aws-data-lake-encryption` with downstream sharing of key ARNs
3. Hub-and-spoke networking with `aws-transit-gateway` + `aws-transit-gateway-spoke`
4. Data lake provisioning + Glue jobs + scheduled workflow orchestration
5. Progressive environment expansion pattern (commented blocks for staging/prod)

For production evolution:

- Replace aliases with real `assume_role` provider blocks per account
- Add explicit KMS grants referencing workload account principals
- Externalize state (one backend per account; pass TGW + key ARNs via remote state or SSM)
- Harden networking (CIDR isolation, DNS resolver endpoints, security account logging aggregation)

Refer to the example README for full architecture notes.

## Using Modules

### Basic Usage

To use a module from this repository, add it to your Terraform configuration:

```hcl
module "vpc" {
  source = "github.com/nanlabs/terraform-modules//modules/aws-vpc"

  vpc_cidr = "10.0.0.0/16"
  # ... other variables
}
```

### Versioning

Always specify a version when using modules:

```hcl
module "vpc" {
  source  = "github.com/nanlabs/terraform-modules//modules/aws-vpc"
  version = "1.0.0"  # Use semantic versioning

  # ... variables
}
```

### Examples

Each module includes example configurations in its `examples/` directory. These examples demonstrate common use cases and best practices.

## Creating Modules

### Module Structure

Each module must follow this structure:

```txt
modules/your-module/
├── main.tf           # Main resource definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Version constraints
├── README.md         # Documentation
├── examples/         # Example configurations
│   └── basic/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── docs/            # Additional documentation
    └── MODULE.md    # Auto-generated docs
```

### Using the Template

1. Copy the `modules/__template__` directory to create a new module:

   ```bash
   cp -r modules/__template__ modules/your-module
   ```

2. Update the following files:

   - `main.tf`: Define your resources
   - `variables.tf`: Define input variables
   - `outputs.tf`: Define output values
   - `versions.tf`: Set version constraints
   - `README.md`: Update documentation

3. Create at least one example in the `examples/` directory

### Best Practices

1. **Input Variables**

   - Use descriptive names
   - Provide default values when appropriate
   - Include type constraints
   - Add descriptions for all variables

2. **Outputs**

   - Output all useful attributes
   - Use consistent naming
   - Include descriptions

3. **Documentation**

   - Keep README.md up to date
   - Document all variables and outputs
   - Include usage examples
   - Reference terraform-docs

4. **Testing**
   - Include working examples
   - Test with different configurations
   - Validate security settings

## Module Development Workflow

1. Create a new branch for your module
2. Copy the template directory
3. Implement the module
4. Add examples
5. Generate documentation
6. Test the module
7. Create a pull request

## Documentation

Use terraform-docs to generate documentation:

```bash
terraform-docs markdown . > docs/MODULE.md
```

The documentation should include:

- Module description
- Requirements
- Providers
- Inputs
- Outputs
- Examples

## References

- [Terraform Module Documentation](https://www.terraform.io/language/modules)
- [Best Practices](BEST_PRACTICES.md)
- [Awesome NAN](https://github.com/nanlabs/awesome-nan)
