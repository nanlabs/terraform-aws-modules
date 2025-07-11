# Complete Aurora PostgreSQL Example

This example creates a complete Aurora PostgreSQL cluster with:

- Aurora PostgreSQL 15.8
- Serverless v2 scaling (0.5-2.0 ACUs)
- Two instances (writer + reader)
- Automatic password management via AWS Secrets Manager
- Performance Insights enabled
- Proper VPC and security group configuration
- SSM parameters for connection details

## Usage

To run this example:

```bash
cd examples/complete
terraform init
terraform plan
terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.89.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.89.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aurora | ../../ | n/a |
| vpc | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_security_group.aurora | resource |
| aws_availability_zones.available | data source |
| aws_caller_identity.current | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region | `string` | `"us-east-1"` | no |
| database_name | Name of the database to create | `string` | `"example"` | no |
| master_username | Username for the master DB user | `string` | `"postgres"` | no |
| name | Name to be used on all the resources as identifier | `string` | `"aurora-example"` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{"Environment": "dev", "Example": "aurora-complete", "Terraform": "true"}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_arn | Amazon Resource Name (ARN) of cluster |
| cluster_database_name | Name for an automatically created database |
| cluster_endpoint | Writer endpoint for the cluster |
| cluster_engine_version_actual | The running version of the cluster |
| cluster_master_user_secret | Generated master user secret when manage_master_user_password is set to true |
| cluster_master_username | Master username for the cluster |
| cluster_port | Port on which the cluster accepts connections |
| cluster_reader_endpoint | A read-only endpoint for the cluster |
| security_group_id | ID of the security group created for Aurora |
