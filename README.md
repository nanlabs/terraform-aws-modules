# Terraform Modules by NaNLABS 🌍 🔧

This repository contains reusable Terraform modules for various cloud providers and services. These modules follow best practices and are designed to be composable, maintainable, and secure.

<div align="center">

📖 CLICK OR TAP ❲☰❳ TO SHOW TABLE-OF-CONTENTS 📖

</div> <!-- center -->

## Motivation

Building and maintaining infrastructure across cloud providers can become repetitive and error-prone. This repository consolidates reusable Terraform modules following best practices, allowing your team to provision infrastructure efficiently, securely, and consistently—whether it’s an AWS VPC, a Kubernetes cluster, or a MongoDB Atlas database.

## Documentation

- [Development Setup](docs/DEV_SETUP.md) - How to set up your development environment
- [Modules Guide](docs/MODULES.md) - How to use and create modules
- [Best Practices](docs/BEST_PRACTICES.md) - Module design, input/output, tagging, and security guidelines
- [Contributing Guidelines](docs/CONTRIBUTING_GUIDELINES.md) - How to contribute to this repository

## Available Modules

### AWS Modules

- [AWS VPC](modules/aws-vpc/) - Virtual Private Cloud module
- [AWS MSK](modules/aws-msk/) - Managed Streaming for Kafka module
- [AWS RDS](modules/aws-rds/) - Relational Database Service module
- [AWS RDS Aurora](modules/aws-rds-aurora/) - Aurora database module
- [AWS VPC Endpoints](modules/aws-vpc-endpoints/) - VPC Endpoints module
- [AWS Bastion](modules/aws-bastion/) - Bastion host module
- [AWS DocumentDB](modules/aws-docdb/) - DocumentDB module
- [AWS EKS](modules/aws-eks/) - Elastic Kubernetes Service module
- [AWS IAM Role](modules/aws-iam-role/) - IAM Role module
- [AWS Amplify App](modules/aws-amplify-app/) - Amplify application module

### Other Cloud Providers

- [MongoDB Atlas Cluster](modules/mongodb-atlas-cluster/) - MongoDB Atlas cluster module

## Module Usage

Each module is designed to be used independently or composed with other modules. To use a module:

```hcl
module "vpc" {
  source = "github.com/nanlabs/terraform-modules//modules/aws-vpc"
  version = "1.0.0"

  vpc_cidr = "10.0.0.0/16"
  # ... other variables
}
```

See each module's README.md for detailed usage instructions and examples.

## Development

### Prerequisites

- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/) (recommended)
- [AWS CLI](https://aws.amazon.com/cli/) (for AWS modules)
- [MongoDB Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/) (for MongoDB modules)

### Development Container

This repository includes a development container configuration that provides a consistent development environment. To use it:

1. Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code
2. Open this repository in VS Code
3. When prompted, click "Reopen in Container" or use the command palette (F1) and select "Remote-Containers: Reopen in Container"

The development container includes:

- Terraform CLI
- terraform-docs
- tfsec
- Terragrunt
- AWS CLI
- MongoDB Atlas CLI
- Pre-commit hooks
- Linting tools

### Local Setup

If you prefer to set up your environment locally, see [Development Setup](docs/DEV_SETUP.md) for detailed instructions.

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/CONTRIBUTING_GUIDELINES.md) for details.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- [Awesome NAN](https://github.com/nanlabs/awesome-nan) - Best practices and resources
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Contributors

[![Contributors](https://contrib.rocks/image?repo=nanlabs/terraform-modules)](https://github.com/nanlabs/terraform-modules/graphs/contributors)

Made with [contributors-img](https://contrib.rocks).
