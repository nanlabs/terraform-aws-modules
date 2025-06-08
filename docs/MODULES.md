# Modules Guide

This guide explains how to use and create modules in this repository.

## Using Modules

### Basic Usage

To use a module from this repository, add it to your Terraform configuration:

```hcl
module "vpc" {
  source = "github.com/nanlabs/terraform-modules//modules/aws-vpc"

  vpc_cidr = "10.0.0.0/16"
  # ... other variables
}
```

### Versioning

Always specify a version when using modules:

```hcl
module "vpc" {
  source  = "github.com/nanlabs/terraform-modules//modules/aws-vpc"
  version = "1.0.0"  # Use semantic versioning

  # ... variables
}
```

### Examples

Each module includes example configurations in its `examples/` directory. These examples demonstrate common use cases and best practices.

## Creating Modules

### Module Structure

Each module must follow this structure:

```txt
modules/your-module/
├── main.tf           # Main resource definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Version constraints
├── README.md         # Documentation
├── examples/         # Example configurations
│   └── basic/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── docs/            # Additional documentation
    └── MODULE.md    # Auto-generated docs
```

### Using the Template

1. Copy the `modules/__template__` directory to create a new module:

   ```bash
   cp -r modules/__template__ modules/your-module
   ```

2. Update the following files:
   - `main.tf`: Define your resources
   - `variables.tf`: Define input variables
   - `outputs.tf`: Define output values
   - `versions.tf`: Set version constraints
   - `README.md`: Update documentation

3. Create at least one example in the `examples/` directory

### Best Practices

1. **Input Variables**
   - Use descriptive names
   - Provide default values when appropriate
   - Include type constraints
   - Add descriptions for all variables

2. **Outputs**
   - Output all useful attributes
   - Use consistent naming
   - Include descriptions

3. **Documentation**
   - Keep README.md up to date
   - Document all variables and outputs
   - Include usage examples
   - Reference terraform-docs

4. **Testing**
   - Include working examples
   - Test with different configurations
   - Validate security settings

## Module Development Workflow

1. Create a new branch for your module
2. Copy the template directory
3. Implement the module
4. Add examples
5. Generate documentation
6. Test the module
7. Create a pull request

## Documentation

Use terraform-docs to generate documentation:

```bash
terraform-docs markdown . > docs/MODULE.md
```

The documentation should include:

- Module description
- Requirements
- Providers
- Inputs
- Outputs
- Examples

## References

- [Terraform Module Documentation](https://www.terraform.io/language/modules)
- [Best Practices](BEST_PRACTICES.md)
- [Awesome NAN](https://github.com/nanlabs/awesome-nan)
