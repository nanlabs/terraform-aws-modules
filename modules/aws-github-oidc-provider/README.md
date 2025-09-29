# GitHub OIDC Provider Module

This module creates the necessary AWS resources to enable GitHub Actions to authenticate with AWS using OpenID Connect (OIDC) instead of storing long-lived AWS credentials as secrets.

## Features

- **Dual Mode Support**: Single repository mode (backward compatibility) and multi-repository mode
- **Secure Authentication**: Uses OIDC instead of long-lived credentials
- **Flexible Permissions**: Configurable IAM policies per repository
- **Environment/Branch Control**: Restrict access to specific GitHub environments or branches
- **Terraform State Access**: Optional permissions for Terraform state bucket access

## Usage

### Single Repository Mode (Backward Compatibility)

```hcl
module "github_oidc" {
  source = "../../../../modules/aws/aws-github-oidc-provider"

  github_repository   = "owner/repository"
  github_environments = ["production"] # or use github_branches = ["main"]
  role_name          = "github-actions-role"

  # Permissions
  attach_power_user_policy      = true
  attach_iam_full_access_policy = true
  attach_additional_permissions = true

  # Terraform state access
  terraform_state_bucket     = "my-terraform-state-bucket"
  terraform_state_account_id = "123456789012"
  terraform_state_region     = "us-east-1"

  tags = {
    Environment = "production"
    Purpose     = "CI/CD"
  }
}
```

### Multi-Repository Mode

```hcl
module "github_oidc_multi" {
  source = "../../../../modules/aws/aws-github-oidc-provider"

  repositories = {
    infrastructure = {
      github_repository         = "owner/infrastructure-repo"
      github_environments      = ["production"]
      role_name               = "infrastructure-github-actions"
      attach_power_user_policy = true
      attach_iam_full_access_policy = true
      attach_additional_permissions = true
      terraform_state_bucket    = "terraform-state-bucket"
      terraform_state_account_id = "123456789012"
      terraform_state_region    = "us-east-1"
    }

    data_jobs = {
      github_repository    = "owner/data-jobs-repo"
      github_environments = ["develop", "staging", "production"]
      role_name          = "data-jobs-github-actions"
      custom_policy_arns = [aws_iam_policy.data_jobs_policy.arn]
    }
  }

  tags = {
    Environment = "shared"
    Purpose     = "Multi-repo CI/CD"
  }
}
```

## Authentication Patterns

### Environment-Based Authentication

When using `github_environments`, the trust policy allows:

- Actions running in specified environments
- Pull request workflows (for terraform plan)

### Branch-Based Authentication

When using `github_branches`, the trust policy allows:

- Actions running on specified branches
- Pull request workflows targeting those branches

## Terraform State Access

The module can optionally grant permissions to access Terraform state stored in S3:

```hcl
terraform_state_bucket     = "my-terraform-state-bucket"
terraform_state_account_id = "123456789012"
terraform_state_region     = "us-east-1"
```

This enables the GitHub Actions role to:

- List, get, put, and delete objects in the state bucket
- Assume cross-account roles for organizational access

## Security Considerations

1. **OIDC Trust Policy**: Only the specified repositories can assume the roles
2. **Environment/Branch Restrictions**: Additional constraints on when roles can be assumed
3. **Least Privilege**: Use custom policies instead of broad managed policies when possible
4. **Short-Lived Credentials**: OIDC tokens have limited lifetime
5. **Pull Request Support**: Allows terraform plan on pull requests for validation

## Examples

See the `examples/` directory for complete usage examples.

## Module Documentation

This documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs).
