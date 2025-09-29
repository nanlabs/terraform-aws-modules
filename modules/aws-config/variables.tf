variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "tags" {
  description = "Any extra tags to assign to objects"
  type        = map(any)
  default     = {}
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Config snapshots"
  type        = string
}

variable "delivery_channel_name" {
  description = "The name of the delivery channel"
  type        = string
  default     = null
}

variable "include_global_resource_types" {
  description = "Specifies whether AWS Config includes all supported types of global resources"
  type        = bool
  default     = true
}

variable "recording_group" {
  description = "The recording group configuration"
  type = object({
    all_supported                 = optional(bool, true)
    include_global_resource_types = optional(bool, true)
    resource_types                = optional(list(string), [])
  })
  default = {
    all_supported                 = true
    include_global_resource_types = true
    resource_types                = []
  }
}

variable "snapshot_delivery_properties" {
  description = "Configuration for snapshot delivery"
  type = object({
    delivery_frequency = optional(string, "TwentyFour_Hours")
  })
  default = {
    delivery_frequency = "TwentyFour_Hours"
  }
}
