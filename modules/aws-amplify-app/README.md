# AWS Amplify App Module

Terraform module that provides an opinionated wrapper around the CloudPosse Amplify App module with integrated GitHub Personal Access Token management via AWS Systems Manager Parameter Store.

## Why This Wrapper Exists

This wrapper adds several valuable features on top of the base CloudPosse module:

- **🔐 Integrated GitHub PAT Management**: Automatically retrieves GitHub Personal Access Token from AWS Systems Manager Parameter Store, eliminating the need to pass sensitive tokens directly
- **📋 Opinionated Defaults**: Pre-configured settings optimized for common React/Node.js applications
- **🏷️ Consistent Tagging**: Standardized tag structure across all resources
- **🔧 Simplified Interface**: Reduced complexity by exposing only the most commonly used parameters while maintaining full flexibility

## Usage

```hcl
module "app" {
  source = "../../modules/aws-amplify-app"

  name = "example-amplify-app"

  # https://docs.aws.amazon.com/amplify/latest/userguide/getting-started.html
  # The GitHub PAT needs to have the scope `admin:repo_hook`
  # Refer to "Setting up the Amplify GitHub App for AWS CloudFormation, CLI, and SDK deployments"
  # in https://docs.aws.amazon.com/amplify/latest/userguide/setting-up-GitHub-access.html
  github_personal_access_token_secret_path = "/nanlabs/github-personal-access-token"

  platform = "WEB"

  repository = "https://github.com/nanlabs/react-boilerplate

  iam_service_role_enabled = true

  # https://docs.aws.amazon.com/amplify/latest/userguide/ssr-CloudWatch-logs.html
  iam_service_role_actions = [
    "logs:CreateLogStream",
    "logs:CreateLogGroup",
    "logs:DescribeLogGroups",
    "logs:PutLogEvents"
  ]

  enable_auto_branch_creation = false

  enable_branch_auto_build = true

  enable_branch_auto_deletion = true

  enable_basic_auth = false

  auto_branch_creation_patterns = [
    "*",
    "*/**"
  ]

  auto_branch_creation_config = {
    # Enable auto build for the created branches
    enable_auto_build = true
  }

  # The build spec for React
  build_spec = <<-EOT
      version: 1
      frontend:
        phases:
          preBuild:
            commands:
              - npm install
          build:
            commands:
              - npm run build
        artifacts:
          baseDirectory: dist
          files:
            - '**/*'
        cache:
          paths:
            - node_modules/**/*
    EOT

  custom_rules = [
    {
      source = "/<*>"
      status = "404"
      target = "/index.html"
    }
  ]

  environment_variables = {
    ENV = "test"
  }

  environments = {
    main = {
      branch_name                 = "main"
      enable_auto_build           = true
      backend_enabled             = false
      enable_performance_mode     = true
      enable_pull_request_preview = false
      framework                   = "React"
      stage                       = "PRODUCTION"
    }
    dev = {
      branch_name                 = "dev"
      enable_auto_build           = true
      backend_enabled             = false
      enable_performance_mode     = false
      enable_pull_request_preview = true
      framework                   = "React"
      stage                       = "DEVELOPMENT"
    }
  }

  domains = {
    "test.net" = {
      enable_auto_sub_domain = true
      wait_for_verification  = false
      sub_domain = [
        {
          branch_name = "main"
          prefix      = ""
        },
        {
          branch_name = "dev"
          prefix      = "dev"
        }
      ]
    }
    "test.io" = {
      enable_auto_sub_domain = true
      wait_for_verification  = false
      sub_domain = [
        {
          branch_name = "main"
          prefix      = ""
        },
        {
          branch_name = "dev"
          prefix      = "dev"
        }
      ]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_amplify_app"></a> [amplify\_app](#module\_amplify\_app) | cloudposse/amplify-app/aws | 1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.github_pat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
