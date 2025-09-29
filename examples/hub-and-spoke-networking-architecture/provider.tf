# Provider Configuration

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Example     = "hub-and-spoke-networking-architecture"
    }
  }
}