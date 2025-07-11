# Shared Module Variables
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Helper variables for backwards compatibility and convenience
variable "azs_count" {
  description = "Number of Availability Zones to use. This value is used to determine the number of public and private subnets to create when azs is not specified."
  type        = number
  default     = 3
}
