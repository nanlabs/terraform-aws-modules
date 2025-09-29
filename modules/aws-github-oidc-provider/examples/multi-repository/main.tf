# Multi-Repository GitHub OIDC Example
# This example shows how to configure OIDC for multiple repositories
# with different permission sets and access patterns

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Custom IAM policy for data jobs
resource "aws_iam_policy" "data_jobs_permissions" {
  name        = "${var.name}-data-jobs-permissions"
  description = "Custom permissions for data jobs repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::my-data-bucket",
          "arn:aws:s3:::my-data-bucket/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Multi-repository OIDC configuration
module "github_oidc_multi" {
  source = "../../"

  repositories = {
    # Infrastructure repository with full permissions
    infrastructure = {
      github_repository             = var.infrastructure_repository
      github_environments           = ["production"]
      role_name                     = "${var.name}-infrastructure-github-actions"
      attach_power_user_policy      = true
      attach_iam_full_access_policy = true
      attach_additional_permissions = true
      terraform_state_bucket        = var.terraform_state_bucket
      terraform_state_account_id    = data.aws_caller_identity.current.account_id
      terraform_state_region        = data.aws_region.current.id
    }

    # Data jobs repository with custom permissions
    data_jobs = {
      github_repository   = var.data_jobs_repository
      github_environments = ["develop", "staging", "production"]
      role_name           = "${var.name}-data-jobs-github-actions"
      custom_policy_arns  = [aws_iam_policy.data_jobs_permissions.arn]
    }

    # Analytics repository with branch-based access
    analytics = {
      github_repository        = var.analytics_repository
      github_branches          = ["main", "develop"]
      role_name                = "${var.name}-analytics-github-actions"
      attach_power_user_policy = true
      custom_policy_arns       = [aws_iam_policy.data_jobs_permissions.arn]
    }
  }

  tags = var.tags
}
