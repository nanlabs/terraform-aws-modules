variable "project_name" {
  description = "Name of the MongoDB Atlas project"
  type        = string
  default     = "example-project"
}

variable "org_id" {
  description = "MongoDB Atlas organization ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the MongoDB Atlas cluster"
  type        = string
  default     = "example-cluster"
}

variable "region" {
  description = "AWS region for the cluster"
  type        = string
  default     = "US_EAST_1"
}

variable "instance_type" {
  description = "MongoDB Atlas instance type"
  type        = string
  default     = "M10"
}

variable "mongodb_major_ver" {
  description = "MongoDB major version"
  type        = number
  default     = 7
}

variable "cluster_type" {
  description = "Type of MongoDB cluster"
  type        = string
  default     = "REPLICASET"
}

variable "num_shards" {
  description = "Number of shards"
  type        = number
  default     = 1
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "create_ssm_parameters" {
  description = "Create SSM parameters for cluster details"
  type        = bool
  default     = true
}

variable "ssm_parameter_prefix" {
  description = "Prefix for SSM parameters"
  type        = string
  default     = "/mongodb/example"
}

variable "create_secret" {
  description = "Create AWS Secrets Manager secret"
  type        = bool
  default     = true
}

variable "secret_prefix" {
  description = "Prefix for secret name"
  type        = string
  default     = "mongodb/example"
}

variable "access_lists" {
  description = "IP access list for the cluster"
  type        = map(string)
  default = {
    "example-access" = "0.0.0.0/0" # WARNING: This allows access from anywhere, restrict in production
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "example"
    Project     = "mongodb-atlas-module"
    Owner       = "platform-team"
  }
}
