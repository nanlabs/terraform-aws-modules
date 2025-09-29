variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
}

# ==============================================================================
# SHARED SERVICES VPC VARIABLES
# ==============================================================================

variable "shared_services_vpc_id" {
  description = "ID of the Shared Services VPC (hub for shared services)"
  type        = string
}

variable "shared_services_vpc_cidr" {
  description = "CIDR block of the Shared Services VPC"
  type        = string
}

variable "shared_services_public_subnets" {
  description = "List of public subnet IDs in the Shared Services VPC"
  type        = list(string)
}

variable "shared_services_private_subnets" {
  description = "List of private subnet IDs in the Shared Services VPC"
  type        = list(string)
}

variable "shared_services_public_route_table_ids" {
  description = "List of public route table IDs in the Shared Services VPC"
  type        = list(string)
}

variable "shared_services_private_route_table_ids" {
  description = "List of private route table IDs in the Shared Services VPC"
  type        = list(string)
}

# ==============================================================================
# EGRESS VPC VARIABLES
# ==============================================================================

variable "egress_vpc_id" {
  description = "ID of the Egress VPC (centralized internet egress)"
  type        = string
}

variable "egress_vpc_cidr" {
  description = "CIDR block of the Egress VPC"
  type        = string
}

variable "egress_nat_gateway_ids" {
  description = "List of NAT Gateway IDs in the Egress VPC"
  type        = list(string)
}

# ==============================================================================
# TRANSIT GATEWAY VARIABLES
# ==============================================================================

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

variable "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table"
  type        = string
}

variable "shared_accounts" {
  description = "Map of accounts that can access shared networking resources"
  type = map(object({
    account_id = string
    role_name  = string
  }))
  default = {}
}

variable "enable_dhcp_options" {
  description = "Enable DHCP options for the VPC"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for DHCP options"
  type        = string
  default     = ""
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_s3_bucket" {
  description = "S3 bucket name for VPC Flow Logs"
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
