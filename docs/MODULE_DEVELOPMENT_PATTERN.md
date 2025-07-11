# Module Development Pattern

This document describes the standardized pattern for developing Terraform modules in this repository.

## 📁 File Structure Pattern

All wrapper modules should follow this consistent file structure:

```txt
modules/<module-name>/
├── variables.tf              # Shared/common variables (name, tags, etc.)
├── <provider>-variables.tf   # Provider-specific variables (complete wrapper)
├── <resource>.tf            # Main resource implementation
├── outputs.tf               # Shared/common outputs
├── <provider>-outputs.tf    # Provider-specific outputs (complete wrapper)
├── versions.tf              # Version constraints
├── README.md               # Module documentation
└── docs/
    └── MODULE.md           # Detailed documentation
```

### Example: AWS VPC Module

```txt
modules/aws-vpc/
├── variables.tf          # Shared variables (name, tags, azs_count)
├── vpc-variables.tf      # All VPC-specific variables
├── vpc.tf               # VPC module implementation
├── outputs.tf           # Shared outputs (azs, name, legacy aliases)
├── vpc-outputs.tf       # All VPC-specific outputs
├── ssm.tf              # Additional resources (SSM parameters)
├── sg.tf               # Additional resources (security groups)
├── versions.tf         # Version constraints
├── README.md           # Module documentation
└── docs/
    └── MODULE.md       # Detailed documentation
```

## 🎯 Design Principles

### 1. Complete Wrapper Philosophy

Each module should be a **complete wrapper** around official Terraform modules or AWS resources:

- **Expose ALL variables** from the underlying module/resource
- **Provide strong defaults** for common use cases
- **Maintain simplicity** for basic usage
- **Enable full customization** when needed

### 2. File Organization

#### `variables.tf` - Shared Variables

Contains variables that are common across modules:

```hcl
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
```

#### `<provider>-variables.tf` - Provider-Specific Variables

Contains ALL variables from the underlying module with appropriate defaults:

```hcl
# VPC Core Configuration
variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = true
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# ... ALL other variables from terraform-aws-modules/vpc/aws
```

#### `outputs.tf` - Shared Outputs

Contains common outputs and any custom additions:

```hcl
output "name" {
  description = "The name specified as argument to this module"
  value       = var.name
}

# Legacy aliases if needed
output "app_subnets" {
  description = "Legacy alias for private_subnets"
  value       = module.vpc.private_subnets
}
```

#### `<provider>-outputs.tf` - Provider-Specific Outputs

Contains ALL outputs from the underlying module:

```hcl
# VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

# ... ALL other outputs from terraform-aws-modules/vpc/aws
```

### 3. Version Management

#### Prefer Official Modules

Always prefer official Terraform modules over third-party ones:

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
      version = ">= 5.0"
    }
  }
}
```

Use specific versions for modules:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"  # Specific version, not ranges

  # ... configuration
}
```

## 🔄 Migration Strategy

When updating existing modules to this pattern:

### Phase 1: Restructure Files

1. Create `<provider>-variables.tf` with all variables
2. Simplify `variables.tf` to shared variables only
3. Create `<provider>-outputs.tf` with all outputs
4. Simplify `outputs.tf` to shared outputs only

### Phase 2: Update Implementation

1. Replace third-party modules with official ones
2. Update to latest versions
3. Pass through all variables to underlying module
4. Ensure all outputs are exposed

### Phase 3: Update Examples

1. Update all examples to use new variable names
2. Add examples showing advanced customization
3. Update documentation

## 📝 Example Implementation

### Simple Usage (Shared Variables Only)

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "my-vpc"
  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

### Advanced Usage (Full Customization)

```hcl
module "vpc" {
  source = "../../modules/aws-vpc"

  # Shared variables
  name = "my-vpc"
  tags = { Environment = "production" }

  # VPC-specific customization
  cidr                     = "172.16.0.0/16"
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_vpn_gateway       = true
  enable_flow_log          = true
  flow_log_destination_type = "s3"

  # Subnets
  public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets  = ["172.16.11.0/24", "172.16.12.0/24"]
  database_subnets = ["172.16.21.0/24", "172.16.22.0/24"]

  # Custom subnet tags
  public_subnet_tags = {
    Type = "public"
  }
  private_subnet_tags = {
    Type = "private"
  }
}
```

## ✅ Quality Checklist

Before considering a module complete, ensure:

- [ ] Uses latest version of underlying official module
- [ ] Exposes ALL variables with appropriate defaults
- [ ] Exposes ALL outputs from underlying module
- [ ] Has comprehensive documentation
- [ ] Includes both simple and advanced examples
- [ ] Follows the standardized file structure
- [ ] Has appropriate version constraints
- [ ] No hardcoded values (except sensible defaults)
- [ ] Includes validation where appropriate
- [ ] Tagged appropriately for cost tracking

## 🚀 Benefits of This Pattern

1. **Consistency**: All modules follow the same pattern
2. **Flexibility**: Support both simple and complex use cases
3. **Maintainability**: Clear separation of concerns
4. **Discoverability**: Easy to find what you need
5. **Future-proof**: Easy to add new features
6. **Standards**: Prefer official modules over third-party
