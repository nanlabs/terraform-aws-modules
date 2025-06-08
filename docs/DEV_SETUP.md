# Development Setup

This guide will help you set up your development environment for working with Terraform modules.

## Prerequisites

- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/) (recommended)
- [AWS CLI](https://aws.amazon.com/cli/) (for AWS modules)
- [MongoDB Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/) (for MongoDB modules)

## Development Container

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

## Local Setup (Alternative)

If you prefer to set up your environment locally:

1. Install [Terraform](https://www.terraform.io/downloads.html) (version specified in module's `versions.tf`)
2. Install [terraform-docs](https://terraform-docs.io/user-guide/installation/)
3. Install [tfsec](https://aquasecurity.github.io/tfsec/latest/getting-started/installation/)
4. Install [pre-commit](https://pre-commit.com/#install)
5. Install [AWS CLI](https://aws.amazon.com/cli/) and configure credentials
6. Install [MongoDB Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/) if working with MongoDB modules

## Pre-commit Hooks

This repository uses pre-commit hooks to ensure code quality. To set them up:

```bash
# Install pre-commit
pip install pre-commit

# Install the git hooks
pre-commit install
```

The hooks will run automatically on commit and include:

- Terraform formatting
- Terraform documentation generation
- Terraform security checks
- Markdown linting
- Code duplication checks

## Environment Variables

Copy the example environment file and update it with your values:

```bash
cp .envrc.example .envrc
```

Then, either:
- Use [direnv](https://direnv.net/) to automatically load the environment variables
- Source the file manually: `source .envrc`

## Testing

To test modules locally:

1. Navigate to the module's `examples/` directory
2. Initialize Terraform: `terraform init`
3. Plan the changes: `terraform plan`
4. Apply if the plan looks good: `terraform apply`

## Next Steps

- Read the [Modules Guide](MODULES.md) to understand how to use and create modules
- Review the [Best Practices](BEST_PRACTICES.md) for module development
- Check the [Contributing Guidelines](CONTRIBUTING_GUIDELINES.md) if you want to contribute
