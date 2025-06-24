# Scripts 🛠️

This directory contains utility scripts for managing the terraform-modules repository.

## Available Scripts

### `maintenance.sh`

A comprehensive script for maintaining the terraform-modules repository with common development tasks.

**Features:**

- Format all Terraform files
- Validate all Terraform configurations
- Generate module documentation
- Run linting and security checks
- Validate example configurations
- Check for outdated versions
- Full maintenance check combining all tasks

**Usage:**

```bash
# Format all Terraform files
./scripts/maintenance.sh format

# Validate all configurations
./scripts/maintenance.sh validate

# Generate documentation
./scripts/maintenance.sh docs

# Run full maintenance check
./scripts/maintenance.sh full-check

# Get help
./scripts/maintenance.sh help
```

### `release-manager.sh`

A comprehensive script for managing releases and validating Terraform modules in this repository.

**Features:**

- Create new releases with automatic version bumping
- Validate changed modules
- Update changelog entries
- List all available modules
- Dry-run mode for safe testing

**Usage:**

```bash
# Validate changed modules
./scripts/release-manager.sh validate-modules

# Create a new release
./scripts/release-manager.sh create-release --type=minor

# List all modules
./scripts/release-manager.sh list-modules

# Get help
./scripts/release-manager.sh --help
```

**Options:**

- `-h, --help` - Show help message
- `-v, --version` - Show script version
- `-t, --type=TYPE` - Release type (major, minor, patch)
- `-m, --modules=LIST` - Comma-separated list of modules to validate
- `-f, --force` - Force operation without confirmation
- `-d, --dry-run` - Show what would be done without executing

## Easy Options Framework

The scripts in this directory use the `easy-options` framework for consistent argument parsing and help generation. This framework is located in the `easy-options/` subdirectory.

## Adding New Scripts

When adding new scripts to this directory:

1. **Use the easy-options framework** for consistent CLI interfaces
2. **Include comprehensive help documentation** in the script header
3. **Add the script to this README** with usage examples
4. **Make scripts executable** with `chmod +x`
5. **Follow the existing naming conventions**

## Contributing

For guidelines on contributing new scripts or improvements, see the main [Contributing Guidelines](../docs/CONTRIBUTING_GUIDELINES.md).
