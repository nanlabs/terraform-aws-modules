# Versioning & Release Strategy

This document describes the versioning and release strategy for the terraform-modules repository.

## 📋 Table of Contents

- [Overview](#overview)
- [Versioning Strategy](#versioning-strategy)
- [Automated Release Process](#automated-release-process)
- [Manual Release Process](#manual-release-process)
- [CI/CD Validation](#cicd-validation)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

This repository uses a **global versioning strategy** where all modules are versioned together as a single repository. This approach provides:

- **Consistency**: All modules are tested and released together
- **Simplicity**: One version number for the entire repository
- **Compatibility**: Ensures module inter-dependencies work correctly
- **Traceability**: Clear history of what changed in each release

## Versioning Strategy

We use **Semantic Versioning (SemVer)** with the format `vMAJOR.MINOR.PATCH`:

### Version Components

- **MAJOR** (`v2.0.0`): Incompatible API changes or breaking changes
  - Removing or renaming module input variables
  - Changing variable types or validation rules
  - Removing modules entirely
  - Changes that require users to update their configurations

- **MINOR** (`v1.1.0`): New functionality in a backwards-compatible manner
  - Adding new modules
  - Adding new optional input variables
  - Adding new output values
  - New features that don't break existing usage

- **PATCH** (`v1.0.1`): Backwards-compatible bug fixes
  - Fixing bugs in existing functionality
  - Documentation updates
  - Security patches
  - Internal refactoring without API changes

### Why Semantic Versioning?

1. **Industry Standard**: Widely adopted and understood
2. **Terraform Ecosystem**: Compatible with Terraform registry and tooling
3. **Dependency Management**: Allows safe pinning to minor versions
4. **Clear Communication**: Breaking changes are immediately apparent

## Automated Release Process

### Triggers

Releases are automatically triggered when:

1. **Changelog Updates**: Changes are merged to `main` with updates to `CHANGELOG.md`
2. **Module Changes**: Direct changes to files in the `modules/` directory
3. **Manual Trigger**: Using GitHub Actions workflow dispatch
4. **Release File**: Updates to the `.release-trigger` file

### Workflow Steps

1. **Change Detection**: Identifies what changed and determines release type
2. **Version Calculation**: Bumps version based on release type
3. **Changelog Update**: Moves unreleased changes to the new version section
4. **Git Tagging**: Creates and pushes a new git tag
5. **GitHub Release**: Creates a GitHub release with release notes
6. **Notification**: Updates relevant documentation and links

### Release Type Detection

The automation determines release type from:

1. **Commit Messages**: Include `release-type: major|minor|patch`
2. **PR Description**: Same syntax in PR description
3. **Default**: If not specified, defaults to `minor`

## Manual Release Process

### Using the Release Script

```bash
# Validate changed modules
./scripts/release-manager.sh validate-modules

# Create a new release
./scripts/release-manager.sh create-release --type=minor

# Update changelog only
./scripts/release-manager.sh update-changelog v1.2.3

# List all modules
./scripts/release-manager.sh list-modules

# Dry run to see what would happen
./scripts/release-manager.sh create-release --dry-run --type=patch
```

### Manual GitHub Actions Trigger

1. Go to the **Actions** tab in GitHub
2. Select the **🚀 Automated Release** workflow
3. Click **Run workflow**
4. Select the release type and options
5. Click **Run workflow**

### Direct Release Process

If automation fails, create releases manually:

```bash
# 1. Update CHANGELOG.md
vim CHANGELOG.md

# 2. Commit changes
git add CHANGELOG.md
git commit -m "chore: bump version to v1.2.3"

# 3. Create tag
git tag v1.2.3

# 4. Push changes
git push origin main
git push origin v1.2.3

# 5. Create GitHub release manually
gh release create v1.2.3 --title "v1.2.3" --notes-file RELEASE_NOTES.md
```

## CI/CD Validation

### Pre-Release Validation

Every PR triggers validation for changed modules:

1. **Format Check**: `terraform fmt -check`
2. **Initialization**: `terraform init -backend=false`
3. **Validation**: `terraform validate`
4. **Linting**: `tflint` with security and best practice rules
5. **Security Scan**: `checkov` for security vulnerabilities
6. **Documentation**: Ensures terraform-docs are up to date

### Module Change Detection

The CI system automatically:

- Detects which modules changed in a PR
- Runs validation only on changed modules
- Provides PR comments with validation results
- Prevents merge if validation fails

### Workflow Validation

Separate workflows validate:

- GitHub Actions workflow syntax
- Release script functionality
- Required workflow presence
- Configuration consistency

## Best Practices

### For Contributors

1. **Always update CHANGELOG.md** with your changes under `[Unreleased]`
2. **Specify release type** in PR description when needed
3. **Test modules locally** before submitting PRs
4. **Follow semantic versioning principles** when determining impact
5. **Document breaking changes** clearly in the changelog

### For Consumers

1. **Pin to specific versions** in production:

   ```hcl
   source = "git::https://github.com/nanlabs/terraform-modules.git//modules/aws-vpc?ref=v1.2.3"
   ```

2. **Use minor version pinning** for automatic patch updates:

   ```hcl
   source = "git::https://github.com/nanlabs/terraform-modules.git//modules/aws-vpc?ref=v1.2"
   ```

3. **Never use `main` branch** in production
4. **Review changelogs** before upgrading versions
5. **Test upgrades** in non-production environments first

### For Maintainers

1. **Review PRs carefully** for breaking changes
2. **Ensure changelog entries** are accurate and complete
3. **Validate release notes** before publishing
4. **Monitor release automation** for failures
5. **Communicate breaking changes** proactively

## Troubleshooting

### Common Issues

#### Release Workflow Fails

1. **Check workflow logs** in GitHub Actions
2. **Verify CHANGELOG.md format** follows Keep a Changelog
3. **Ensure unreleased section** has actual changes
4. **Check git permissions** and token scope

#### Version Calculation Wrong

1. **Verify commit message format** includes `release-type:`
2. **Check latest tag** exists and follows semver
3. **Manually trigger** with specific version type

#### Module Validation Fails

1. **Run validation locally**:

   ```bash
   ./scripts/release-manager.sh validate-modules
   ```

2. **Check terraform version** compatibility
3. **Verify module dependencies** are satisfied
4. **Review linting rules** and fix violations

#### Changelog Not Updated

1. **Check unreleased section** has entries
2. **Verify file permissions** allow writing
3. **Ensure proper markdown format**
4. **Manually update and commit** if needed

### Getting Help

1. **Check workflow logs** for specific error messages
2. **Review this documentation** for procedures
3. **Test with dry-run mode** before making changes
4. **Ask in GitHub Discussions** for complex issues

### Emergency Procedures

#### Rollback a Release

```bash
# Delete the tag locally and remotely
git tag -d v1.2.3
git push origin :refs/tags/v1.2.3

# Delete the GitHub release
gh release delete v1.2.3

# Revert changelog changes
git revert <commit-hash>
```

#### Hot Fix Release

```bash
# Create patch release for urgent fixes
./scripts/release-manager.sh create-release --type=patch --force

# Or manually trigger with GitHub Actions
# Select "patch" as release type
```

## References

- [Semantic Versioning Specification](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Terraform Registry Publishing](https://www.terraform.io/docs/registry/providers/publishing.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Repository Contributing Guidelines](../docs/CONTRIBUTING_GUIDELINES.md)
