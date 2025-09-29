# ==============================================================================
# VARIABLES - Hub-and-Spoke Networking Architecture
# ==============================================================================

variable "project_name" {
  description = "Name of the networking project"
  type        = string
  default     = "hub-spoke-network"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "shared"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# ==============================================================================
# VPC CIDR BLOCKS
# ==============================================================================

variable "hub_vpc_cidr" {
  description = "CIDR block for the hub VPC (shared services)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "egress_vpc_cidr" {
  description = "CIDR block for the egress VPC (centralized internet access)"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dev_vpc_cidr" {
  description = "CIDR block for the development spoke VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "staging_vpc_cidr" {
  description = "CIDR block for the staging spoke VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "prod_vpc_cidr" {
  description = "CIDR block for the production spoke VPC"
  type        = string
  default     = "10.30.0.0/16"
}

# ==============================================================================
# BASTION CONFIGURATION
# ==============================================================================

variable "bastion_instance_type" {
  description = "Instance type for bastion hosts"
  type        = string
  default     = "t3.nano"
}

variable "bastion_allowed_cidrs" {
  description = "List of CIDR blocks allowed to access bastion hosts"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this in production
}

variable "create_environment_bastions" {
  description = "Whether to create dedicated bastion hosts for each environment"
  type        = bool
  default     = false
}

# ==============================================================================
# NETWORKING FEATURES
# ==============================================================================

variable "enable_vpc_endpoints" {
  description = "Enable VPC endpoints for AWS services"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for all VPCs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Retention period for VPC Flow Logs in days"
  type        = number
  default     = 30
}

# ==============================================================================
# ADDITIONAL TAGS
# ==============================================================================

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
