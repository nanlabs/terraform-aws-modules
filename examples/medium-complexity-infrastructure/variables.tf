variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "medium-complexity"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.31"
}

variable "db_master_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "postgres"
}

variable "db_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
  default     = "changeme123!"
}

variable "enable_bastion" {
  description = "Enable bastion host for database access"
  type        = bool
  default     = true
}
