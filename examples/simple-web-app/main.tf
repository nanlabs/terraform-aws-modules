locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Example     = "simple-web-app"
  }
}

# Create VPC for the application
module "vpc" {
  source = "../../modules/aws-vpc"

  name = "${var.project_name}-${var.environment}"
  tags = local.common_tags

  # VPC Configuration
  cidr     = "10.0.0.0/16"
  azs_count = 3

  # NAT Gateway Configuration
  enable_nat_gateway = true
  single_nat_gateway = true

  # Flow Logs
  enable_flow_log = true

  # Subnet Tags
  public_subnet_tags = {
    "Type" = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "Type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }

  # SSM Parameters for VPC details
  create_ssm_parameters = true
}

# Deploy Amplify Application
module "amplify_app" {
  source = "../../modules/aws-amplify-app"

  name                                     = "${var.project_name}-${var.environment}"
  description                              = "Simple web application deployed with Terraform"
  repository                               = var.github_repository
  github_personal_access_token_secret_path = var.github_pat_parameter

  platform = "WEB"

  enable_auto_branch_creation   = true
  enable_branch_auto_build      = true
  enable_branch_auto_deletion   = true
  enable_basic_auth             = false

  auto_branch_creation_patterns = ["main", "develop", "feature/*"]

  auto_branch_creation_config = {
    enable_auto_build = true
    stage             = "DEVELOPMENT"
  }

  # Build spec optimized for React/Node.js applications
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
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

  # Single page application routing
  custom_rules = [
    {
      source = "/<*>"
      status = "404"
      target = "/index.html"
    }
  ]

  environment_variables = {
    NODE_ENV = var.environment
    REGION   = var.aws_region
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
  }

  # Only configure custom domain if provided
  domains = var.domain_name != "" ? {
    (var.domain_name) = {
      enable_auto_subdomain = false
      wait_for_verification = true
      sub_domain = [
        {
          branch_name = "main"
          prefix      = ""
        }
      ]
    }
  } : {}

  tags = local.common_tags
}
