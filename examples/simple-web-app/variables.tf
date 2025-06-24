variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "simple-web-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_repository" {
  description = "GitHub repository URL for the web application"
  type        = string
  default     = "https://github.com/nanlabs/react-boilerplate"
}

variable "github_pat_parameter" {
  description = "SSM Parameter Store path for GitHub Personal Access Token"
  type        = string
  default     = "/nanlabs/github-personal-access-token"
}

variable "domain_name" {
  description = "Custom domain name for the application (optional)"
  type        = string
  default     = ""
}
