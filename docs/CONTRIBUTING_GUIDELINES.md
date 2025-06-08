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

3. **Pull Requests**
   - Create PRs early for discussion
   - Keep PRs focused and small
   - Update documentation
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

1. **Versioning**
   - Follow semantic versioning
   - Update version in module
   - Tag releases properly

2. **Changelog**
   - Update CHANGELOG.md
   - Document all changes
   - Include migration notes

3. **Documentation**
   - Update all docs
   - Generate new docs
   - Review for accuracy

## Getting Help

- Open an issue for bugs
- Use discussions for questions
- Join our community chat
- Check existing documentation

## References

- [Development Setup](DEV_SETUP.md)
- [Modules Guide](MODULES.md)
- [Best Practices](BEST_PRACTICES.md)
- [Awesome NAN](https://github.com/nanlabs/awesome-nan)
