variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "github-oidc-multi-example"
}

variable "infrastructure_repository" {
  description = "GitHub repository for infrastructure (owner/repo)"
  type        = string
  default     = "organization/infrastructure"
}

variable "data_jobs_repository" {
  description = "GitHub repository for data jobs (owner/repo)"
  type        = string
  default     = "organization/data-jobs"
}

variable "analytics_repository" {
  description = "GitHub repository for analytics (owner/repo)"
  type        = string
  default     = "organization/analytics"
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "my-terraform-state-bucket"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "example"
    Purpose     = "multi-repo-oidc"
  }
}
