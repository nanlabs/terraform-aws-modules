# GitHub OIDC Provider and IAM Role for Terraform execution via GitHub Actions
# This module creates the necessary infrastructure to allow GitHub Actions
# to authenticate with AWS using OIDC instead of stored credentials
# Supports both single repository mode (backward compatibility) and multi-repository mode

# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local values to handle single vs multi-repository mode
locals {
  # Determine mode based on input variables
  single_mode = var.github_repository != null
  multi_mode  = length(var.repositories) > 0

  # Convert single mode to multi mode format for unified processing
  repositories_normalized = local.single_mode ? {
    single = {
      github_repository             = var.github_repository
      github_branches               = var.github_branches
      github_environments           = var.github_environments
      role_name                     = var.role_name
      max_session_duration          = var.max_session_duration
      attach_power_user_policy      = var.attach_power_user_policy
      attach_iam_full_access_policy = var.attach_iam_full_access_policy
      attach_additional_permissions = var.attach_additional_permissions
      terraform_state_bucket        = var.terraform_state_bucket
      terraform_state_account_id    = var.terraform_state_account_id
      terraform_state_region        = var.terraform_state_region
      custom_policy_arns            = var.custom_policy_arns
    }
  } : var.repositories

  # Extract all unique repositories for OIDC provider name
  all_repositories   = [for k, config in local.repositories_normalized : config.github_repository]
  oidc_provider_name = local.single_mode ? "${var.role_name}-oidc-provider" : "github-actions-oidc-provider"
}

# GitHub OIDC Identity Provider (shared across all repositories)
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  # GitHub's OIDC thumbprints - updated with current GitHub thumbprints
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1", # GitHub Actions OIDC (primary)
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd", # GitHub intermediate certificate
    "f879abce0008e4eb126e0097e46620f5aaae26ad"  # GitHub root certificate
  ]

  tags = merge(var.tags, {
    Name             = local.oidc_provider_name
    Purpose          = "GitHub Actions OIDC authentication"
    GitHubRepository = local.single_mode ? var.github_repository : "Multiple-Repositories"
  })
}

# IAM Roles for GitHub Actions with OIDC trust policy (one per repository)
resource "aws_iam_role" "github_actions" {
  for_each = local.repositories_normalized

  name                 = each.value.role_name
  description          = "Role for GitHub Actions to execute Terraform via OIDC"
  max_session_duration = each.value.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = concat(
              # Include environments if defined
              each.value.github_environments != null ? [
                for env in each.value.github_environments :
                "repo:${each.value.github_repository}:environment:${env}"
              ] : [],
              # Include branches if defined
              each.value.github_branches != null ? [
                for branch in each.value.github_branches :
                "repo:${each.value.github_repository}:ref:refs/heads/${branch}"
              ] : [],
              # Always allow pull requests
              [
                "repo:${each.value.github_repository}:pull_request"
              ]
            )
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name       = each.value.role_name
    Purpose    = "GitHub Actions Terraform execution"
    GitHubRepo = each.value.github_repository
  })
}

# Attach AWS managed policies for Terraform execution
resource "aws_iam_role_policy_attachment" "power_user" {
  for_each = {
    for k, config in local.repositories_normalized : k => config
    if config.attach_power_user_policy
  }

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  for_each = {
    for k, config in local.repositories_normalized : k => config
    if config.attach_iam_full_access_policy
  }

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

# Custom inline policy for additional permissions
resource "aws_iam_role_policy" "additional_permissions" {
  for_each = {
    for k, config in local.repositories_normalized : k => config
    if config.attach_additional_permissions && config.terraform_state_bucket != ""
  }

  name = "${each.value.role_name}-additional-permissions"
  role = aws_iam_role.github_actions[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "organizations:List*",
          "organizations:Describe*",
          "account:GetContactInformation",
          "account:GetAlternateContact",
          "account:GetAccountInformation",
          "sts:TagSession",
          "sts:AssumeRole"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${each.value.terraform_state_bucket}",
          "arn:aws:s3:::${each.value.terraform_state_bucket}/*"
        ]
      }
    ]
  })
}

# Attach custom policies if provided
resource "aws_iam_role_policy_attachment" "custom_policies" {
  for_each = {
    for pair in flatten([
      for repo_key, config in local.repositories_normalized : [
        for policy_idx, policy_arn in config.custom_policy_arns : {
          key        = "${repo_key}-${policy_idx}"
          repo_key   = repo_key
          policy_arn = policy_arn
        }
      ]
    ]) : pair.key => pair
  }

  role       = aws_iam_role.github_actions[each.value.repo_key].name
  policy_arn = each.value.policy_arn
}
