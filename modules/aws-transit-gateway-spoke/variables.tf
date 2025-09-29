# Variables for Transit Gateway Spoke Module

variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to attach to Transit Gateway"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the spoke VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to use for Transit Gateway attachment"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs to add routes to"
  type        = list(string)
}

variable "hub_vpc_cidr" {
  description = "CIDR block of the hub VPC (if not provided, will be retrieved from SSM)"
  type        = string
  default     = null
}

# Override variables for TGW info (alternative to SSM parameters)
variable "transit_gateway_id" {
  description = "Transit Gateway ID (if provided, will override SSM parameter lookup)"
  type        = string
  default     = null
}

variable "spoke_route_table_id" {
  description = "Spoke route table ID (if provided, will override SSM parameter lookup)"
  type        = string
  default     = null
}

variable "hub_route_table_id" {
  description = "Hub route table ID (if provided, will override SSM parameter lookup)"
  type        = string
  default     = null
}

variable "enable_propagation_to_hub" {
  description = "Whether to propagate spoke routes to hub route table"
  type        = bool
  default     = true
}

variable "enable_spoke_to_spoke_routing" {
  description = "Whether to enable routing between spoke VPCs"
  type        = bool
  default     = false
}

variable "other_spoke_cidrs" {
  description = "List of other spoke VPC CIDR blocks for inter-spoke routing"
  type        = list(string)
  default     = []
}

variable "enable_internet_via_hub" {
  description = "Whether to route internet traffic through hub VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
