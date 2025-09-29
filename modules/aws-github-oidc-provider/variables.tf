# Variables for GitHub OIDC Provider module

# Single repository mode (backward compatibility)
variable "github_repository" {
  description = "GitHub repository in the format 'owner/repo' that will be allowed to assume the role. Use this for single repository mode."
  type        = string
  default     = null

  validation {
    condition     = var.github_repository == null || can(regex("^[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+$", var.github_repository))
    error_message = "GitHub repository must be in the format 'owner/repo'."
  }
}

# Multi-repository mode
variable "repositories" {
  description = "Map of repositories with their configurations. Use this for multi-repository mode."
  type = map(object({
    github_repository             = string
    github_branches               = optional(list(string), ["main"])
    github_environments           = optional(list(string), null)
    role_name                     = string
    max_session_duration          = optional(number, 3600)
    attach_power_user_policy      = optional(bool, false)
    attach_iam_full_access_policy = optional(bool, false)
    attach_additional_permissions = optional(bool, false)
    terraform_state_bucket        = optional(string, "")
    terraform_state_account_id    = optional(string, "")
    terraform_state_region        = optional(string, "")
    custom_policy_arns            = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for repo_config in var.repositories :
      can(regex("^[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+$", repo_config.github_repository))
    ])
    error_message = "All GitHub repositories must be in the format 'owner/repo'."
  }

  validation {
    condition = alltrue([
      for repo_config in var.repositories :
      can(regex("^[a-zA-Z0-9+=,.@_-]+$", repo_config.role_name))
    ])
    error_message = "All role names must contain only alphanumeric characters and the following: +=,.@_-"
  }

  validation {
    condition = alltrue([
      for repo_config in var.repositories :
      repo_config.max_session_duration >= 3600 && repo_config.max_session_duration <= 43200
    ])
    error_message = "All max session durations must be between 3600 (1 hour) and 43200 (12 hours) seconds."
  }
}

# Single repository mode variables (backward compatibility)
variable "github_branches" {
  description = "List of GitHub branches that are allowed to assume the role (single repository mode)"
  type        = list(string)
  default     = ["main"]
}

variable "github_environments" {
  description = "List of GitHub environments that are allowed to assume the role. If set, this takes precedence over branches (single repository mode)"
  type        = list(string)
  default     = null
}

variable "role_name" {
  description = "Name of the IAM role to create for GitHub Actions (single repository mode)"
  type        = string
  default     = null

  validation {
    condition     = var.role_name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name))
    error_message = "Role name must contain only alphanumeric characters and the following: +=,.@_-"
  }
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds for the IAM role (single repository mode)"
  type        = number
  default     = 3600 # 1 hour

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 (1 hour) and 43200 (12 hours) seconds."
  }
}

variable "attach_power_user_policy" {
  description = "Whether to attach the PowerUserAccess managed policy to the role (single repository mode)"
  type        = bool
  default     = true
}

variable "attach_iam_full_access_policy" {
  description = "Whether to attach the IAMFullAccess managed policy to the role (single repository mode)"
  type        = bool
  default     = true
}

variable "attach_additional_permissions" {
  description = "Whether to attach additional permissions for Terraform state access and organizational read access (single repository mode)"
  type        = bool
  default     = true
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket used for Terraform state storage (single repository mode)"
  type        = string
  default     = ""
}

variable "terraform_state_account_id" {
  description = "AWS Account ID where the Terraform state bucket is located (single repository mode)"
  type        = string
  default     = ""
}

variable "terraform_state_region" {
  description = "AWS region where the Terraform state bucket is located (single repository mode)"
  type        = string
  default     = ""
}

variable "custom_policy_arns" {
  description = "List of custom policy ARNs to attach to the GitHub Actions role (single repository mode)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
