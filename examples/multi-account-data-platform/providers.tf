###############################################
# Providers & Aliases
#
# This example simulates a multi-account setup using provider aliases
# instead of actual separate AWS accounts (to keep it runnable locally).
#
# Accounts (conceptual):
#   - infrastructure: shared networking, transit gateway, central encryption
#   - dev (workloads): data lake, glue jobs/workflows (development)
#   - staging (commented): data lake + jobs promoted version
#   - prod (commented): production hardened configuration
#
# You can replace a provider alias with a real assume role configuration:
# provider "aws" {
#   alias   = "workloads_dev"
#   region  = var.region
#   assume_role {
#     role_arn     = "arn:aws:iam::123456789012:role/OrganizationAccountAccessRole"
#     session_name = "terraform"
#   }
# }
###############################################

variable "region" {
  type        = string
  description = "AWS region to deploy all accounts"
  default     = "us-east-1"
}

provider "aws" {
  alias  = "infrastructure"
  region = var.region
}

provider "aws" {
  alias  = "workloads_dev"
  region = var.region
}

# provider "aws" {
#   alias  = "workloads_staging"
#   region = var.region
# }
#
# provider "aws" {
#   alias  = "workloads_prod"
#   region = var.region
# }
