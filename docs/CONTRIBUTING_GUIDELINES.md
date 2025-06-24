# Contributing Guidelines

Thank you for your interest in contributing to our Terraform modules repository! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Set up your development environment (see [Development Setup](DEV_SETUP.md))
4. Create a new branch for your changes

## Development Workflow

1. **Branch Naming**
   - Use descriptive branch names
   - Follow the pattern: `type/description`
   - Examples:
     - `feature/new-module`
     - `fix/vpc-security`
     - `docs/readme-update`

2. **Commit Messages**
   - Use clear, descriptive messages
   - Follow conventional commits format
   - Reference issues when applicable
   - Include release type for version bumps (e.g., `release-type: minor`)

3. **Pull Requests**
   - Create PRs early for discussion
   - Keep PRs focused and small
   - Update documentation
   - **Update CHANGELOG.md** under `[Unreleased]` section
   - **Specify release type** if changes should trigger a new version
   - Include tests and examples

## Module Development

### Creating New Modules

1. Use the template in `modules/__template__`
2. Follow the [Modules Guide](MODULES.md)
3. Implement best practices from [Best Practices](BEST_PRACTICES.md)
4. Include examples and tests

### Updating Existing Modules

1. Maintain backward compatibility
2. Update documentation
3. Add migration guides if needed
4. Test changes thoroughly
5. **Consider versioning impact** - breaking changes require major version bump

## Testing

### Required Tests

1. **Unit Tests**
   - Variable validation
   - Output values
   - Error conditions

2. **Integration Tests**
   - Real provider testing
   - Module composition
   - Error handling

3. **Security Tests**
   - tfsec checks
   - IAM validation
   - Encryption verification

### Running Tests

```bash
# Run all tests
make test

# Run specific tests
make test-unit
make test-integration
make test-security
```

## Documentation

### Required Documentation

1. **Module Documentation**
   - README.md
   - Input/output documentation
   - Usage examples
   - Requirements

2. **Code Documentation**
   - Comments for complex logic
   - Design decisions
   - External references

### Generating Documentation

```bash
# Generate module documentation
terraform-docs markdown . > docs/MODULE.md

# Update README.md
terraform-docs markdown . > README.md
```

## Review Process

1. **Code Review**
   - All PRs require review
   - Address review comments
   - Keep PRs up to date

2. **CI/CD Checks**
   - All checks must pass
   - Fix any failures
   - Update if needed

3. **Final Steps**
   - Squash commits if requested
   - Update PR description
   - Request final review

## Release Process

This repository uses **automated releases** with semantic versioning. Contributors should follow these guidelines:

### 🔖 Versioning Strategy

We use **Semantic Versioning (SemVer)** with the format `vMAJOR.MINOR.PATCH`:

- **MAJOR**: Breaking changes or incompatible API changes
- **MINOR**: New features in a backwards-compatible manner (default)
- **PATCH**: Backwards-compatible bug fixes

### 📝 Changelog Management

**Required for all contributions:**

1. **Update CHANGELOG.md** under the `[Unreleased]` section
2. **Categorize your changes:**
   - `Added` - New features or modules
   - `Changed` - Changes in existing functionality
   - `Fixed` - Bug fixes
   - `Security` - Vulnerability fixes
   - `Deprecated` - Soon-to-be removed features
   - `Removed` - Removed features

**Example:**

```markdown
## [Unreleased]

### Added
- New AWS DocumentDB module (#123)

### Fixed
- Fixed VPC security group rules validation (#124)
```

### 🚀 Release Types

Specify the release type in your PR description or commit message:

- `release-type: major` - For breaking changes
- `release-type: minor` - For new features (default)
- `release-type: patch` - For bug fixes

**Example commit:**

```bash
feat: add new EKS module with advanced networking

release-type: minor

- Added comprehensive EKS module
- Includes VPC integration and security best practices
```

### 🤖 Automated Releases

Releases are automatically triggered when:

1. **Changes are merged to `main`** with updates to `CHANGELOG.md`
2. **Module changes** are detected in the `modules/` directory
3. **Manual trigger** via GitHub Actions workflow dispatch

### 📋 Contributor Checklist

Before submitting a PR:

- [ ] Updated `CHANGELOG.md` under `[Unreleased]` section
- [ ] Specified release type if changes should trigger a new version
- [ ] Tested all changes locally
- [ ] Updated module documentation if applicable
- [ ] Followed semantic versioning principles

### 📚 Additional Resources

For detailed information about our versioning strategy, see [Versioning Strategy](VERSIONING.md).

## Getting Help

- Open an issue for bugs
- Use discussions for questions
- Join our community chat
- Check existing documentation

## References

- [Development Setup](DEV_SETUP.md)
- [Modules Guide](MODULES.md)
- [Best Practices](BEST_PRACTICES.md)
- [Versioning Strategy](VERSIONING.md)
- [Awesome NAN](https://github.com/nanlabs/awesome-nan)
