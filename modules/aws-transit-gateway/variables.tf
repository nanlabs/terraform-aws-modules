# Transit Gateway Configuration Variables

variable "name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Transit Gateway for hub-and-spoke networking"
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway"
  type        = number
  default     = 64512
}

variable "enable_auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = bool
  default     = false
}

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = false
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = false
}

# Cross-account sharing configuration
variable "enable_cross_account_sharing" {
  description = "Enable sharing Transit Gateway with other AWS accounts"
  type        = bool
  default     = true
}

variable "ram_allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share"
  type        = bool
  default     = false
}

variable "cross_account_principals" {
  description = "List of AWS account IDs to share the Transit Gateway with"
  type        = list(string)
  default     = []
}

# Route table configuration
variable "create_hub_route_table" {
  description = "Create dedicated route table for hub VPCs"
  type        = bool
  default     = true
}

variable "create_spoke_route_table" {
  description = "Create dedicated route table for spoke VPCs"
  type        = bool
  default     = true
}

variable "create_isolated_route_table" {
  description = "Create dedicated route table for isolated VPCs"
  type        = bool
  default     = false
}

# Hub VPC attachment configuration
variable "hub_vpc_id" {
  description = "VPC ID of the hub/infrastructure VPC to attach"
  type        = string
  default     = null
}

variable "hub_vpc_private_subnet_ids" {
  description = "List of private subnet IDs from the hub VPC for TGW attachment"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
