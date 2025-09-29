############################################################
# Global Variables
############################################################

variable "namespace" {
  description = "Global namespace / business unit prefix (e.g., dwh)"
  type        = string
  default     = "dwh"
}

variable "short_domain" {
  description = "Short domain identifier (e.g., wl for workloads)"
  type        = string
  default     = "wl"
}

variable "environment" {
  description = "Primary active environment (dev | staging | prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Base tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "multi-account-data-platform"
    Terraform   = "true"
    CostCenter  = "analytics"
  }
}

# Networking (shared infra)
variable "vpc_cidr" {
  description = "CIDR for the shared infrastructure VPC"
  type        = string
  default     = "10.50.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs for infra account"
  type        = list(string)
  default     = ["10.50.1.0/24", "10.50.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for infra account"
  type        = list(string)
  default     = ["10.50.101.0/24", "10.50.102.0/24"]
}

# Workloads (dev) VPC
variable "dev_vpc_cidr" {
  description = "CIDR for dev workloads VPC"
  type        = string
  default     = "10.60.0.0/16"
}

variable "dev_private_subnet_cidrs" {
  description = "Private subnets for dev VPC"
  type        = list(string)
  default     = ["10.60.1.0/24", "10.60.2.0/24"]
}

variable "dev_public_subnet_cidrs" {
  description = "Public subnets for dev VPC"
  type        = list(string)
  default     = ["10.60.101.0/24", "10.60.102.0/24"]
}

# Optional future environments (commented usage in main.tf)
variable "staging_vpc_cidr" {
  description = "CIDR for staging workloads VPC"
  type        = string
  default     = "10.70.0.0/16"
}

variable "prod_vpc_cidr" {
  description = "CIDR for prod workloads VPC"
  type        = string
  default     = "10.80.0.0/16"
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to reach bastion hosts"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
