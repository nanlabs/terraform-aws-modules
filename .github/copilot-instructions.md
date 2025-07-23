# GitHub Copilot Instructions for NaN Labs Terraform Modules

## Repository Overview

This repository contains **production-ready, reusable Terraform modules** for cloud infrastructure provisioning, primarily focused on AWS services with some multi-cloud support. The modules are designed following enterprise best practices and are used by dozens of companies in production environments.

## Core Principles

### 1. Always Reference Documentation First

- **MANDATORY**: Before any planning or implementation, always reference the `docs/` directory
- Start with `README.md` for general guidance and module catalog
- Check specific documentation files for detailed requirements:
  - `docs/BEST_PRACTICES.md` - Coding standards and security practices
  - `docs/MODULE_DEVELOPMENT_PATTERN.md` - Standardized module development approach
  - `docs/MODULES.md` - Complete module catalog and usage examples
  - `docs/USAGE.md` - Advanced usage patterns and versioning strategy
  - `docs/DEV_SETUP.md` - Development environment setup
  - `docs/VERSIONING.md` - Release management and versioning guidelines
  - `docs/CONTRIBUTING_GUIDELINES.md` - Contribution workflow and standards

### 2. Follow the Complete Wrapper Philosophy

All modules in this repository follow a **complete wrapper pattern**:

- **Expose ALL variables** from underlying official modules
- **Provide strong defaults** for common use cases
- **Maintain simplicity** for basic usage
- **Enable full customization** when needed
- **Prefer official modules** (terraform-aws-modules) over third-party alternatives

## Repository Structure and Patterns

### Module Organization

```
modules/
├── __template__/          # Template for new module creation
├── aws-vpc/              # VPC with subnets, gateways, flow logs
├── aws-eks/              # Managed Kubernetes with essential addons
├── aws-rds/              # PostgreSQL/MySQL databases
├── aws-rds-aurora/       # Aurora clusters with serverless options
├── aws-docdb/            # MongoDB-compatible document database
├── aws-bastion/          # Secure jump hosts with SSM
├── aws-iam-role/         # IAM roles with best practices
├── aws-msk/              # Apache Kafka streaming platform
├── aws-amplify-app/      # Frontend hosting and CI/CD
└── mongodb-atlas-cluster/ # Multi-cloud MongoDB service
```

### Example Configurations

```
examples/
├── simple-web-app/               # MVP setup (~$46/month)
├── medium-complexity-infrastructure/  # Microservices (~$300/month)
└── complete-enterprise-setup/    # Full enterprise (~$940/month)
```

### Documentation Structure

```
docs/
├── README.md                     # Documentation index
├── BEST_PRACTICES.md            # Security, performance, cost optimization
├── MODULE_DEVELOPMENT_PATTERN.md # Standardized development approach
├── MODULES.md                   # Complete module catalog
├── USAGE.md                     # Advanced usage patterns
├── VERSIONING.md                # Release strategy
└── DEV_SETUP.md                 # Development environment
```

## Module Development Standards

### File Structure Pattern

All modules **MUST** follow this standardized structure:

```
modules/<module-name>/
├── variables.tf              # Shared/common variables (name, tags, etc.)
├── <provider>-variables.tf   # Provider-specific variables (complete wrapper)
├── <resource>.tf            # Main resource implementation
├── ssm.tf                   # SSM parameters (conditional creation)
├── outputs.tf               # Shared/common outputs
├── <provider>-outputs.tf    # Provider-specific outputs (complete wrapper)
├── versions.tf              # Version constraints
├── README.md               # Module documentation
├── examples/               # Working examples
│   └── basic/
└── docs/
    └── MODULE.md           # Auto-generated terraform-docs
```

### Variable Organization

#### `variables.tf` - Shared Variables

```hcl
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add all resources"
  type        = map(string)
  default     = {}
}

variable "create_ssm_parameters" {
  description = "Whether to create SSM parameters for resource details"
  type        = bool
  default     = true
}
```

#### `<provider>-variables.tf` - Complete Wrapper Variables

- **Expose ALL variables** from the underlying official module
- **Provide sensible defaults** for common use cases
- **Include comprehensive descriptions** and type constraints
- **Group related variables** logically with comments

### SSM Parameters Best Practices

**CRITICAL**: Always use conditional creation to avoid empty values:

```hcl
locals {
  # Conditions to avoid creating SSM parameters with empty or null values
  create_database_subnets_ssm = var.create_ssm_parameters && length(var.database_subnets) > 0
  create_internet_gateway_ssm = var.create_ssm_parameters && var.create_igw
}

resource "aws_ssm_parameter" "database_subnets" {
  count = local.create_database_subnets_ssm ? 1 : 0
  # ... configuration
}
```

### Version Management

#### Module Preferences (in order)

1. **First choice**: `terraform-aws-modules/*` (official AWS modules)
2. **Second choice**: `hashicorp/*` (HashiCorp maintained)
3. **Avoid**: `cloudposse/*` when official alternatives exist
4. **Last resort**: Custom implementation with native resources

#### Version Constraints

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
```

**Always use specific versions for modules:**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"  # Specific version, not ranges
}
```

## Usage Patterns

### Module Referencing

#### Production Usage

```hcl
module "vpc" {
  source = "github.com/nanlabs/terraform-modules//modules/aws-vpc?ref=v1.2.3"

  name = "my-production-vpc"
  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

#### Development/Local Usage

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "dev-vpc"
  tags = { Environment = "development" }
}
```

### Simple vs Advanced Usage

#### Simple Usage (Shared Variables Only)

```hcl
module "rds" {
  source = "../../modules/aws-rds"

  name = "my-app-db"
  tags = { Environment = "production" }
}
```

#### Advanced Usage (Full Customization)

```hcl
module "rds" {
  source = "../../modules/aws-rds"

  name = "my-app-db"
  tags = { Environment = "production" }

  # Full customization available
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.r6g.large"
  allocated_storage    = 100
  multi_az            = true
  backup_retention_period = 14
}
```

## Security and Best Practices

### Security Standards

- **Encryption by default** for all supported resources
- **Least privilege IAM policies** with principle of least access
- **Network security** with proper security group configurations
- **Secrets management** using AWS SSM Parameter Store or Secrets Manager
- **Conditional resource creation** to prevent empty SSM parameters

### Cost Optimization

- **Right-sizing defaults** for cost-effective resource allocation
- **Lifecycle management** for storage resources
- **Conditional resource creation** based on actual needs
- **Resource tagging** for cost tracking and management

### Documentation Requirements

1. **README.md** with clear usage examples
2. **Auto-generated docs** using terraform-docs in `docs/MODULE.md`
3. **Working examples** in `examples/` directory
4. **Comprehensive variable descriptions**
5. **Output descriptions** for all exposed values

## Module Creation Workflow

### For New Modules

1. **Verify Necessity**: Ensure no existing module meets requirements
2. **Use Template**: Start with `modules/__template__/`
3. **Follow File Structure**: Implement standardized pattern
4. **Implement Complete Wrapper**: Expose all variables from underlying module
5. **Add Conditional Logic**: Especially for SSM parameters
6. **Create Examples**: Both simple and advanced usage
7. **Generate Documentation**: Use terraform-docs
8. **Test Thoroughly**: Validate all configurations

### For Module Updates

1. **Review Documentation**: Check MODULE_DEVELOPMENT_PATTERN.md
2. **Update Underlying Module**: Use latest stable versions
3. **Maintain Backward Compatibility**: Unless major version bump
4. **Update Examples**: Ensure they work with changes
5. **Regenerate Documentation**: Keep docs in sync
6. **Test Migration Path**: Verify existing deployments

## Quality Standards

### Pre-commit Checklist

- [ ] Uses latest version of underlying official module
- [ ] Exposes ALL variables with appropriate defaults
- [ ] Exposes ALL outputs from underlying module
- [ ] Has comprehensive documentation
- [ ] Includes both simple and advanced examples
- [ ] Follows the standardized file structure
- [ ] Has appropriate version constraints
- [ ] No hardcoded values (except sensible defaults)
- [ ] Includes validation where appropriate
- [ ] SSM parameters use conditional creation
- [ ] Tagged appropriately for cost tracking

### Testing Requirements

- Run `terraform fmt` before committing
- Use `terraform validate` for syntax checking
- Test with `terraform plan` before applying
- Verify all examples work correctly
- Test both simple and advanced configurations

## Error Prevention

### Common Mistakes to Avoid

- Creating modules without checking existing options first
- Not following the complete wrapper philosophy
- Missing conditional logic for SSM parameters
- Not exposing all variables from underlying modules
- Using third-party modules when official alternatives exist
- Hardcoding values that should be configurable
- Missing comprehensive documentation
- Not providing working examples

### SSM Parameter Issues

**CRITICAL**: Always check that SSM parameters are only created when values exist:

```hcl
# ❌ WRONG - Can create empty parameters
resource "aws_ssm_parameter" "database_subnets" {
  count = var.create_ssm_parameters ? 1 : 0
  value = join(",", try(module.vpc.database_subnets, []))
}

# ✅ CORRECT - Only create when values exist
locals {
  create_database_subnets_ssm = var.create_ssm_parameters && length(var.database_subnets) > 0
}

resource "aws_ssm_parameter" "database_subnets" {
  count = local.create_database_subnets_ssm ? 1 : 0
  value = join(",", module.vpc.database_subnets)
}
```

## Implementation Workflow

### For Infrastructure Changes

1. **Review Documentation**: Check `docs/` directory for relevant patterns
2. **Understand Context**: Review existing similar modules for patterns
3. **Choose Right Module**: Use the module catalog in `docs/MODULES.md`
4. **Follow Examples**: Start with examples in `examples/` directory
5. **Use Versioning**: Always pin to specific module versions
6. **Test Locally**: Validate configuration before deployment
7. **Document Usage**: Update relevant documentation

### For Troubleshooting

1. **Check Examples**: Look at working examples in `examples/` directory
2. **Review Module Docs**: Check `modules/<name>/docs/MODULE.md`
3. **Validate Configuration**: Use `terraform validate` and `terraform plan`
4. **Check SSM Logic**: Ensure conditional creation is properly implemented
5. **Review Best Practices**: Reference `docs/BEST_PRACTICES.md`

## Support and References

- **Primary Documentation**: Always check `docs/` directory first
- **Module Catalog**: Complete list in `docs/MODULES.md`
- **Working Examples**: See `examples/` directory
- **Contributing**: Reference `docs/CONTRIBUTING_GUIDELINES.md`
- **Best Practices**: See `docs/BEST_PRACTICES.md`
- **Development Pattern**: See `docs/MODULE_DEVELOPMENT_PATTERN.md`
- **Usage Guide**: See `docs/USAGE.md`

## Quick Reference Commands

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Generate documentation
terraform-docs markdown . > docs/MODULE.md

# Test examples
cd examples/basic && terraform init && terraform plan

# Create new module from template
cp -r modules/__template__ modules/new-module
```

---

**Remember**: When in doubt, always reference the comprehensive documentation in the `docs/` directory and follow the established patterns in existing modules. This repository prioritizes production-ready, enterprise-grade infrastructure with strong defaults and complete customization capabilities.
