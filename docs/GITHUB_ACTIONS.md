# GitHub Actions Workflows

This document describes all GitHub Actions workflows configured in this Terraform modules repository.

## 📋 Workflows Overview

| Workflow                                          | Purpose                                | Trigger                | Status    |
| ------------------------------------------------- | -------------------------------------- | ---------------------- | --------- |
| [🔍 Terraform Validation](#-terraform-validation) | Terraform format and syntax validation | Push/PR to main        | ✅ Active |
| [📝 Terraform Docs](#-terraform-docs)             | Automatic documentation generation     | Push/PR to main        | ✅ Active |
| [🧹 MegaLinter](#-megalinter)                     | Code linting and formatting            | Push/PR to main        | ✅ Active |
| [🚀 Automated Release](#-automated-release)       | Automatic release creation             | Push to main + changes | ✅ Active |

---

## 🔍 Terraform Validation

**File:** `.github/workflows/terraform-validation.yml`

### Purpose

Intelligent Terraform module validation that detects changes and executes validations only on affected components to optimize CI/CD time.

### Triggers

- **Push to main**: Validates changes being merged
- **Pull requests to main**: Validates proposed changes (excludes draft PRs)

### Key Features

#### 🎯 **Smart Change Detection**

- Automatically detects which modules have been modified
- Identifies changes to main examples
- Only runs validations on affected components

#### 🔧 **Format Validation**

- Runs `terraform fmt -check -recursive` from repository root
- Ensures all Terraform files follow consistent formatting standards
- Fails if any formatting issues are detected

#### ✅ **Module Validation**

- Validates only the modules that have been changed
- Runs `terraform init` and `terraform validate` on each modified module
- Automatically validates module-specific examples if they exist

#### 📚 **Example Validation**

- Always validates main examples (`examples/`) when any module changes
- Validates module-specific examples (e.g., `modules/aws-bastion/examples/`)
- Ensures examples remain functional after module updates

### Workflow Jobs

1. **`detect-changes`**: Analyzes git diff to determine what changed
2. **`terraform-fmt`**: Format validation from repository root
3. **`validate-modules`**: Matrix validation of changed modules + their examples
4. **`validate-examples`**: Matrix validation of main examples
5. **`terraform-validation-summary`**: Comprehensive reporting and final status

### Example Output

```text
✅ Terraform Format Check: Passed
✅ Module Validation: Passed
   - Validated modules: aws-vpc aws-rds
✅ Examples Validation: Passed

🔄 Changes Detected
- Modules changed: true
- Examples changed: false
- Any Terraform files changed: true
- Changed modules: aws-vpc aws-rds
```

### Benefits

- **⚡ Efficiency**: Only validates changed components
- **🔍 Comprehensive**: Covers modules, examples, and formatting
- **📊 Transparent**: Clear reporting and failure reasons
- **🚀 Parallel**: Uses matrix strategy for faster execution
- **🛡️ Reliable**: Catches issues before they reach main branch

---

## 📝 Terraform Docs

**File:** `.github/workflows/tf-docs.yml`

### Purpose

Automatically generates documentation for all Terraform modules using terraform-docs.

### Triggers

- **Push to main**: Updates documentation after merge
- **Pull requests to main**: Generates docs for review (excludes draft PRs)

### Features

- **Automatic Generation**: Updates `docs/MODULE.md` in each module
- **Git Synchronization**: Automatically commits documentation changes
- **Consistent Format**: Uses standard template for all documentation

### Benefits

- **📚 Always Updated Documentation**: No outdated docs
- **🤖 Complete Automation**: No manual intervention required
- **📝 Consistent Format**: All documentation follows the same standard

---

## 🧹 MegaLinter

**File:** `.github/workflows/mega-linter.yml`

### Purpose

Comprehensive linting and automatic fix application for multiple languages and formats.

### Triggers

- **Push to main**: Validation after merge
- **Pull requests to main**: Validation of proposed changes

### Key Features

- **Multi-Language Linting**: Support for Terraform, YAML, Markdown, JSON, etc.
- **Auto-Fix**: Automatically applies fixes when possible
- **Detailed Reports**: Generates comprehensive reports of issues found
- **PR Integration**: Creates automatic PRs with applied fixes

### Configuration

- **Apply Fixes**: Enabled for pull requests
- **Mode**: Direct commit of fixes
- **Cancellation**: Concurrent workflows are automatically cancelled

### Benefits

- **🎯 Code Quality**: Maintains consistent standards
- **🔧 Auto-Fixes**: Reduces manual work
- **📊 Visibility**: Clear reports of quality issues
- **🚀 Efficiency**: Detects problems early in the process

---

## 🚀 Automated Release

**File:** `.github/workflows/release.yml`

### Purpose

Automates release creation based on changes in CHANGELOG.md and modules.

### Triggers

- **Push to main** with changes in:
  - `CHANGELOG.md`
  - `.release-trigger`
  - `modules/**`
- **Manual**: Workflow dispatch with release type options

### Features

- **Automatic Release**: Detects changes and creates appropriate releases
- **Semantic Versioning**: Support for major, minor, patch
- **Changelog Validation**: Verifies changelog is updated
- **Manual Trigger**: Allows manual releases with custom configuration

### Manual Options

- **Release Type**: major, minor, patch
- **Skip Changelog Check**: Bypasses changelog validation

### Benefits

- **🎯 Consistent Releases**: Automated and predictable process
- **📝 Documentation**: Changelog integration
- **🔄 Flexibility**: Both automatic and manual modes
- **📦 Distribution**: Facilitates adoption of new versions

---

## 🛠️ Configuration and Maintenance

### Repository Requirements

- Module structure in `modules/` directory
- Main examples in `examples/` directory
- Module-specific examples in `modules/{module-name}/examples/`
- Proper Terraform version files and lock files

### Required Permissions

- **contents: write** - For automatic commits and releases
- **pull-requests: write** - For creating/updating PRs
- **issues: write** - For reporting issues

### Monitoring

- All workflows include detailed reports
- Failures are clearly identified with specific reasons
- GitHub Step Summary provides executive summaries

### Best Practices

1. **Keep Changelog Updated**: For automatic releases
2. **Format Before Commit**: Run `terraform fmt -recursive` locally
3. **Test Examples**: Validate examples before pushing
4. **Review Draft PRs**: Mark as ready when prepared for CI

---

## 🔧 Troubleshooting

### Common Failures

#### Terraform Format Issues

```bash
# Local solution
terraform fmt -recursive .
```

#### Module Validation Failures

```bash
# Local debug
cd modules/{module-name}
terraform init -backend=false
terraform validate
```

#### Example Validation Failures

```bash
# Local debug
cd examples/{example-name}
terraform init -backend=false
terraform validate
```

### Logs and Debugging

- Each job provides detailed logs
- GitHub Step Summary includes executive summary
- Artifacts available for downloads (MegaLinter reports)

---

## 📚 Additional Resources

- [Terraform Documentation](https://terraform.io/docs)
- [terraform-docs](https://terraform-docs.io/)
- [MegaLinter Documentation](https://megalinter.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## 🤝 Contributing

To modify or add workflows:

1. Edit files in `.github/workflows/`
2. Test locally when possible
3. Validate YAML syntax
4. Document changes in this file
5. Test in PR before merging to main
