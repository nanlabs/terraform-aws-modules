# Terraform Cloud Modules by NaNLABS 🌍 🔧

Welcome to the **Terraform Cloud Modules** repository! This collection of reusable modules provides a robust foundation for provisioning cloud infrastructure across a variety of services. With support for AWS and third-party providers like MongoDB Atlas, these modules are designed for flexibility, scalability, and best practices across cloud platforms.

<div align="center">

📖 CLICK OR TAP ❲☰❳ TO SHOW TABLE-OF-CONTENTS 📖

</div> <!-- center -->

## Motivation

Building and maintaining infrastructure across cloud providers can become repetitive and error-prone. This repository consolidates reusable Terraform modules following best practices, allowing your team to provision infrastructure efficiently, securely, and consistently—whether it’s an AWS VPC, a Kubernetes cluster, or a MongoDB Atlas database.

## Key Features

### 🧱 Modular Design

All infrastructure components are encapsulated as independent Terraform modules, which you can reuse across projects and environments. Each module has its own documentation and example usage.

### ☁️ Multi-Cloud Ready

While most modules are designed for AWS (e.g., VPC, EKS, RDS, IAM), this repository also includes modules for services like **MongoDB Atlas**, making it easier to manage third-party services alongside native cloud resources.

### 🧪 Examples Included

The `examples/` directory provides ready-to-use configurations to demonstrate how to integrate modules in real-world scenarios. Perfect for bootstrapping your infrastructure setup or testing locally.

### 🔐 Security and Best Practices

Modules follow cloud provider recommendations for secure configuration. Sensitive values (like secrets) are never hardcoded and can be managed through secrets managers or parameter stores depending on the environment.

## Repository Structure

```
modules/         → Reusable infrastructure modules
examples/        → Usage examples for each module
scripts/         → Helper scripts (e.g., kubeconfig generator, bastion tunneling)
```

## Modules

Below is a sample of the available modules:

| Module Name             | Description                                      |
| ----------------------- | ------------------------------------------------ |
| `aws-vpc`               | Provisions VPCs with public/private subnets.     |
| `aws-bastion`           | Creates a bastion host for secure SSH access.    |
| `aws-eks`               | Provisions an Amazon EKS Kubernetes cluster.     |
| `aws-msk`               | Deploys an Amazon MSK (Kafka) cluster.           |
| `aws-rds`               | Provisions a PostgreSQL RDS instance.            |
| `aws-rds-aurora`        | Provisions an Aurora cluster (MySQL/PostgreSQL). |
| `aws-iam-role`          | Creates IAM roles and policies.                  |
| `aws-vpc-endpoints`     | Configures VPC endpoints (e.g., S3, DynamoDB).   |
| `aws-amplify-app`       | Provisions an AWS Amplify application.           |
| `mongodb-atlas-cluster` | Provisions a MongoDB Atlas database cluster.     |

Check each module's `README.md` inside the `modules/` directory for inputs, outputs, and usage examples.

## Examples

Visit the [`examples/`](./examples/) directory for full infrastructure setups using one or more modules. These examples can be used to validate module behavior, onboard new teams, or act as blueprints for real-world deployments.

## Infra Tools and Scripts

Find helper scripts in [`scripts/`](./scripts/) for tasks like:

* Connecting to bastion hosts
* Creating tunnels to EKS clusters
* Generating kubeconfig files
* Automating environment setup with `direnv`

Check the [scripts README](./scripts/README.md) for more info.

## Best Practices

* All modules follow Terraform best practices for naming, input validation, and documentation.
* Sensitive data should be injected via secrets managers or parameter stores.
* Consider using [Checkov](https://www.checkov.io/) or [tfsec](https://github.com/aquasecurity/tfsec) for security scanning.
* Validate your code with `terraform validate` and format with `terraform fmt -recursive`.

## Contributing

We welcome improvements and fixes! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) before opening a PR.

## Contributors

[![Contributors](https://contrib.rocks/image?repo=nanlabs/terraform-cloud-modules)](https://github.com/nanlabs/terraform-cloud-modules/graphs/contributors)

Made with [contributors-img](https://contrib.rocks).
