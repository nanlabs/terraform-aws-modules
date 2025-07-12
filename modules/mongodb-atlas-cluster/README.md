# MongoDB Atlas Cluster Module

Terraform module that creates a complete MongoDB Atlas cluster with integrated project management, team configuration, VPC peering, security controls, and AWS integration. This is a **custom implementation** for MongoDB Atlas infrastructure with enhanced AWS Secrets Manager and SSM Parameter Store integration.

## Why This Module Exists

While MongoDB Atlas provides excellent infrastructure, managing projects, teams, access controls, VPC peering, and AWS integration can become complex and repetitive. This module:

- **🏢 Simplifies Project Management**: Automates project creation with proper team assignments and role-based access
- **🔐 Enforces Security Best Practices**: Built-in IP access lists, team permissions, and network security
- **🌐 Streamlines Network Integration**: VPC peering configuration with AWS for secure connectivity
- **⚙️ Provides Production-Ready Defaults**: Optimized cluster settings for enterprise workloads
- **🏷️ Ensures Consistent Resource Management**: Standardized project and cluster organization
- **📊 Reduces Configuration Complexity**: Single module call instead of managing multiple Atlas resources
- **🔑 AWS Integration**: Automatic storage of connection details in AWS Secrets Manager and SSM Parameter Store

## Key Features

This custom module provides comprehensive MongoDB Atlas cluster management:

- **🏢 Project & Organization Management**: Automated project creation with team assignments and role-based access
- **🔐 Security & Access Control**: IP access list management and team-based permissions
- **🌐 Network Integration**: VPC peering configuration for secure connectivity
- **🛡️ Enterprise Security**: Advanced authentication and network security controls
- **⚙️ Production-Ready Configuration**: Optimized cluster settings for enterprise workloads
- **🏷️ Consistent Resource Management**: Standardized project and cluster organization
- **🔑 AWS Secrets Manager Integration**: Automatic storage of connection strings and cluster details
- **📝 SSM Parameter Store Integration**: Configurable parameter storage for cluster metadata
- **🔒 Enhanced Security**: Sensitive connection data stored securely in AWS

## Usage

### Basic Usage

```hcl
provider "aws" {
  region = "eu-west-1"
}

provider "mongodbatlas" {}

module "atlas_cluster" {
  source = "../../modules/mongodb-atlas-cluster"

  project_name = "my-project"
  org_id       = "5edf67f9b9614996228111"

  teams = {
    Devops : {
      users : ["example@mail.io", "user@mail.io"]
      role : "GROUP_OWNER"
    },
    DevTeam : {
      users : ["developer@mail.io"]
      role : "GROUP_READ_ONLY"
    }
  }

  access_lists = {
    "example comment" : "52.12.41.46/32",
    "second example" : "54.215.4.201/32"
  }

  region = "EU_WEST_1"

  cluster_name = "MyCluster"

  instance_type      = "M30"
  mongodb_major_ver  = 7
  cluster_type       = "REPLICASET"
  num_shards         = 1
  replication_factor = 3
  backup_enabled     = true
  pit_enabled        = false

  vpc_peer = {
    vpc_peer1 : {
      aws_account_id : "020201234877"
      region : "eu-west-1"
      vpc_id : "vpc-0240c8a47312svc3e"
      route_table_cidr_block : "172.16.0.0/16"
    },
    vpc_peer2 : {
      aws_account_id : "0205432147877"
      region : "eu-central-1"
      vpc_id : "vpc-0f0dd82430bhv0e1a"
      route_table_cidr_block : "172.17.0.0/16"
    }
  }

  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "platform-team"
  }
}
```

### With AWS Integration

```hcl
module "atlas_cluster_with_aws" {
  source = "../../modules/mongodb-atlas-cluster"

  project_name = "my-production-app"
  org_id       = "5edf67f9b9614996228111"

  # ... cluster configuration ...

  # Enable AWS Secrets Manager integration
  create_secret               = true
  secret_prefix              = "myapp/mongodb"
  secret_description         = "MongoDB Atlas connection details for production"
  secret_recovery_window_in_days = 30

  # Enable SSM Parameter Store integration
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/myapp/mongodb"

  tags = {
    Environment = "production"
    Project     = "myapp"
    Owner       = "platform-team"
  }
}
```

### Accessing Connection Details

When AWS integration is enabled, you can access connection details from your applications:

```hcl
# Get connection details from Secrets Manager
data "aws_secretsmanager_secret_version" "mongodb" {
  secret_id = module.atlas_cluster_with_aws.secret_arn
}

locals {
  mongodb_config = jsondecode(data.aws_secretsmanager_secret_version.mongodb.secret_string)
}

# Use in other resources
resource "aws_lambda_function" "app" {
  # ... lambda configuration ...

  environment {
    variables = {
      MONGODB_URI = local.mongodb_config.mongo_uri_with_options
    }
  }
}

# Or get individual parameters from SSM
data "aws_ssm_parameter" "cluster_id" {
  name = "/myapp/mongodb/cluster_id"
}
```

## Benefits

✅ **One Command Setup**: Deploy complete MongoDB Atlas infrastructure with teams, security, and networking
✅ **Enterprise-Ready**: Built-in best practices for production workloads
✅ **AWS Integration**: Seamless integration with AWS Secrets Manager and SSM Parameter Store
✅ **Cost-Optimized**: Intelligent defaults for efficient resource usage
✅ **Security-First**: Encryption, access controls, and network isolation by default
✅ **Scalable Design**: Easy to extend with additional features and integrations
✅ **Enhanced Security**: Sensitive connection data stored securely in AWS
✅ **Operational Excellence**: Automated secret rotation and parameter management

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | >= 1.30.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | >= 1.30.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_project.project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_teams.team](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/teams) | resource |
| [mongodbatlas_project_ip_access_list.access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_cluster.cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster) | resource |
| [mongodbatlas_network_peering.mongo_peer](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/network_peering) | resource |
| [mongodbatlas_database_user.user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [aws_vpc_peering_connection_accepter.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_ssm_parameter.mongodb_details](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_secretsmanager_secret.mongodb_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mongodb_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
