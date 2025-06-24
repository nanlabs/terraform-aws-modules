# MongoDB Atlas Cluster Module

Terraform module that creates a complete MongoDB Atlas cluster with integrated project management, team configuration, VPC peering, and security controls. This is a **custom implementation** for MongoDB Atlas infrastructure.

## Key Features

This custom module provides comprehensive MongoDB Atlas cluster management:

- **🏢 Project & Organization Management**: Automated project creation with team assignments and role-based access
- **🔐 Security & Access Control**: IP access list management and team-based permissions
- **🌐 Network Integration**: VPC peering configuration for secure connectivity
- **🛡️ Enterprise Security**: Advanced authentication and network security controls
- **⚙️ Production-Ready Configuration**: Optimized cluster settings for enterprise workloads
- **🏷️ Consistent Resource Management**: Standardized project and cluster organization

## Usage

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
  mongodb_major_ver  = 4.2
  cluster_type       = "REPLICASET"
  num_shards         = 1
  replication_factor = 3
  provider_backup    = true
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
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | >= 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_project.project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_teams.team](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/teams) | resource |
| [mongodbatlas_project_ip_access_list.access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_cluster.cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
