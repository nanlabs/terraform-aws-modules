variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "complete-enterprise"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.31"
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for MSK DNS records"
  type        = string
  default     = ""
}

# Database variables
variable "aurora_master_username" {
  description = "Master username for Aurora cluster"
  type        = string
  default     = "postgres"
}

variable "aurora_master_password" {
  description = "Master password for Aurora cluster"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "docdb_master_username" {
  description = "Master username for DocumentDB cluster"
  type        = string
  default     = "docdb"
}

variable "docdb_master_password" {
  description = "Master password for DocumentDB cluster"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

# Feature toggles
variable "enable_gpu_nodes" {
  description = "Enable GPU node group for ML workloads"
  type        = bool
  default     = false
}

variable "enable_msk" {
  description = "Enable MSK Apache Kafka cluster"
  type        = bool
  default     = true
}

variable "enable_documentdb" {
  description = "Enable DocumentDB cluster"
  type        = bool
  default     = true
}
