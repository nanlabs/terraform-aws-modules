# Modules Guide

This guide explains how to use and create modules in this repository, along with a complete catalog of available modules.

## 📦 Complete Module Catalog

### AWS Infrastructure Modules

#### 🌐 AWS VPC

- **Path**: `modules/aws-vpc/`
- **Description**: Virtual Private Cloud with best practices
- **Features**: Multi-AZ subnets, NAT Gateway, Internet Gateway, Route tables
- **Use Cases**: Network foundation, multi-AZ setup, isolated environments
- **Example Cost**: ~$45/month (with NAT Gateway)

#### ⚡ AWS EKS

- **Path**: `modules/aws-eks/`
- **Description**: Managed Kubernetes with essential addons
- **Features**: Cluster setup, node groups, IRSA, CNI configuration
- **Use Cases**: Microservices, container orchestration, modern applications
- **Example Cost**: ~$73/month (cluster) + worker nodes

#### 🗄️ AWS RDS

- **Path**: `modules/aws-rds/`
- **Description**: Relational database with monitoring
- **Features**: Multi-AZ, automated backups, monitoring, parameter groups
- **Use Cases**: Application databases, data persistence, OLTP workloads
- **Example Cost**: ~$15-200/month (depending on instance size)

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
