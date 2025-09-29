# 🚀 Module Usage Guide

This guide provides detailed information on how to use modules from this repository, versioning strategies, and advanced usage patterns.

## 📋 Table of Contents

- [Module Usage](#-module-usage)
- [Versioning & Release Strategy](#-versioning--release-strategy)
- [Development Environment](#-development-environment)
- [Advanced Usage Patterns](#-advanced-usage-patterns)

## 🚀 Module Usage

Each module is designed to be **plug-and-play** with sensible defaults, yet highly customizable for complex requirements.

### Quick Start

```hcl
module "vpc" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.0.0"

  vpc_cidr = "10.0.0.0/16"
  # That's it! VPC with best practices is ready 🎉
}
```

### 💡 Pro Tips

- **📌 Always pin versions**: Use specific tags (e.g., `?ref=v1.2.3`) for production
- **🔍 Check examples**: Every module includes comprehensive examples
- **📖 Read the docs**: Each module has detailed README with all options
- **🧪 Test first**: Use examples to validate before customizing

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
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/MODULE_NAME?ref=v1.2.3"
}

# ⚠️ Acceptable - Pin to minor version (receives patches)
module "example" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/MODULE_NAME?ref=v1.2"
}

# ❌ Avoid - Using latest or main branch
module "example" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/MODULE_NAME?ref=main"
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

## 💻 Development Environment

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

## 🔧 Advanced Usage Patterns

### Module Composition

```hcl
# Compose multiple modules for complex infrastructure
module "network" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.2.3"

  vpc_cidr = "10.0.0.0/16"
  name     = "my-app"
}

module "database" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-rds?ref=v1.2.3"

  vpc_id         = module.network.vpc_id
  subnet_ids     = module.network.private_subnet_ids
  instance_class = "db.t3.micro"
}

module "kubernetes" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-eks?ref=v1.2.3"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
}
```

### Environment-Specific Configurations

```hcl
# environments/staging/main.tf
module "staging_infra" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.2.3"

  vpc_cidr = "10.1.0.0/16"
  name     = "staging"

  # Staging-specific optimizations
  enable_nat_gateway = false  # Cost optimization
  single_nat_gateway = true
}

# environments/production/main.tf
module "production_infra" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.2.3"

  vpc_cidr = "10.0.0.0/16"
  name     = "production"

  # Production optimizations
  enable_nat_gateway = true
  single_nat_gateway = false  # High availability
  enable_flow_logs   = true   # Security monitoring
}
```

---

For more detailed information, check out:

- [📦 Complete Module List](../README.md#-available-modules)
- [🎪 Working Examples](../examples/)
- [📖 Best Practices](BEST_PRACTICES.md)
- [🤝 Contributing Guide](CONTRIBUTING_GUIDELINES.md)
