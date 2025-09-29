variable "database_prefix" {
  description = "Prefix for all Glue database names. Should follow the pattern: namespace-short_domain-account_name (e.g., dwh-wl-workloads-data-lake-develop)"
  type        = string
}

variable "catalog_id" {
  description = "The ID of the Glue Catalog. If not provided, the AWS account ID will be used"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of data lake layers to create databases for"
  type        = list(string)
  default     = ["bronze", "silver", "gold"]

  validation {
    condition     = length(var.layers) > 0
    error_message = "At least one layer must be specified."
  }
}

variable "data_lake_sublayers" {
  description = "Configuration for sublayers within each data lake layer. Each layer can have multiple sublayers (e.g., source systems, processing stages)"
  type        = map(list(string))
  default = {
    # Example: bronze = ["klaviyo", "salesforce", "stripe"]
    # If empty or not specified, the layer will be treated as single-layer
  }
  validation {
    condition = alltrue([
      for layer, sublayers in var.data_lake_sublayers :
      length(sublayers) > 0 || length(sublayers) == 0
    ])
    error_message = "Sublayers list can be empty (for single-layer) or contain at least one sublayer."
  }
}

variable "s3_bucket_uri" {
  description = "The S3 bucket URI where data lake data is stored (e.g., s3://bucket-name)"
  type        = string
}

variable "data_lake_paths" {
  description = "Map of layer names to their S3 path prefixes"
  type        = map(string)
  default = {
    bronze = "iceberg-warehouse/bronze"
    silver = "iceberg-warehouse/silver"
    gold   = "iceberg-warehouse/gold"
  }
}

variable "create_shared_databases" {
  description = "Whether to create shared databases (shared, export)"
  type        = bool
  default     = true
}

variable "create_export_database" {
  description = "Whether to create an export database for final outputs"
  type        = bool
  default     = true
}

variable "additional_databases" {
  description = "Map of additional databases to create outside of the standard data lake layers"
  type = map(object({
    description = string
    location    = optional(string, null)
    parameters  = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module"
  type        = map(string)
  default     = {}
}
