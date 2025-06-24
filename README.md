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
- [Versioning Strategy](docs/VERSIONING.md) - Release management and versioning guidelines

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
  source = "git::https://github.com/nanlabs/terraform-modules.git//modules/aws-vpc?ref=v1.0.0"

  vpc_cidr = "10.0.0.0/16"
  # ... other variables
}
```

See each module's README.md for detailed usage instructions and examples.

## 🔖 Versioning & Release Strategy

This repository uses **Semantic Versioning** (SemVer) with the format `vMAJOR.MINOR.PATCH`:

- **MAJOR**: Incompatible API changes or breaking changes to existing modules
- **MINOR**: New modules or backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### 🚀 Automated Releases

Releases are automatically created when:

1. **Changes are merged to `main`** with updates to the `CHANGELOG.md` under the `[Unreleased]` section
2. **Module changes are detected** in the `modules/` directory
3. **Manual trigger** via GitHub Actions workflow dispatch

### 📝 Release Types

Specify the release type in your PR or commit message:

- `release-type: major` - For breaking changes
- `release-type: minor` - For new features (default)
- `release-type: patch` - For bug fixes

### 🎯 Using Specific Versions

When consuming modules, always pin to a specific version:

```hcl
# ✅ Good - Pin to specific version
module "example" {
  source = "git::https://github.com/nanlabs/terraform-modules.git//modules/MODULE_NAME?ref=v1.2.3"
}

# ⚠️ Acceptable - Pin to minor version (receives patches)
module "example" {
  source = "git::https://github.com/nanlabs/terraform-modules.git//modules/MODULE_NAME?ref=v1.2"
}

# ❌ Avoid - Using latest or main branch
module "example" {
  source = "git::https://github.com/nanlabs/terraform-modules.git//modules/MODULE_NAME?ref=main"
}
```

### 🛠️ Manual Release Management

Use the provided script for manual release operations:

```bash
# Validate changed modules
./scripts/release-manager.sh validate-modules

# Create a manual release
./scripts/release-manager.sh create-release --type=minor

# List all modules
./scripts/release-manager.sh list-modules

# Get help
./scripts/release-manager.sh --help
```

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
