# AWS Glue Data Lake Catalog Module
# Creates Glue databases for data lake medallion architecture with sublayer separation

# Locals to compute all database combinations
locals {
  # Create a map of all database combinations (layer + sublayer)
  # Only create sublayer-specific databases if sublayers are defined for that layer
  database_combinations = flatten([
    for layer in var.layers : [
      for sublayer in lookup(var.data_lake_sublayers, layer, []) : {
        key           = "${layer}_${sublayer}"
        layer         = layer
        sublayer      = sublayer
        database_name = "${var.database_prefix}_${layer}_${sublayer}"
        description   = "Database for ${layer} layer data from ${sublayer} sublayer"
        location      = "${var.s3_bucket_uri}/${lookup(var.data_lake_paths, layer, layer)}/${sublayer}/"
      }
    ] if length(lookup(var.data_lake_sublayers, layer, [])) > 0
  ])

  # Create single-layer databases for layers without sublayers
  single_layer_databases = [
    for layer in var.layers : {
      key           = layer
      layer         = layer
      sublayer      = null
      database_name = "${var.database_prefix}_${layer}_data"
      description   = "Database for ${layer} layer data"
      location      = "${var.s3_bucket_uri}/${lookup(var.data_lake_paths, layer, layer)}/"
    } if length(lookup(var.data_lake_sublayers, layer, [])) == 0
  ]

  # Convert to map for easy access
  sublayer_databases = {
    for db in local.database_combinations : db.key => db
  }

  single_databases = {
    for db in local.single_layer_databases : db.key => db
  }

  # Special databases (not tied to layers)
  special_databases = var.create_shared_databases ? {
    shared = {
      key           = "shared"
      layer         = "shared"
      sublayer      = null
      database_name = "${var.database_prefix}_shared"
      description   = "Shared database for common tables and reference data"
      location      = "${var.s3_bucket_uri}/shared/"
    }
    export = var.create_export_database ? {
      key           = "export"
      layer         = "export"
      sublayer      = null
      database_name = "${var.database_prefix}_export"
      description   = "Export database for final data outputs and CSV exports"
      location      = "${var.s3_bucket_uri}/export/"
    } : null
  } : {}

  # Remove null values
  filtered_special_databases = {
    for k, v in local.special_databases : k => v if v != null
  }

  # Additional databases from configuration
  additional_databases = {
    for name, config in var.additional_databases : name => {
      key           = name
      layer         = name
      sublayer      = null
      database_name = "${var.database_prefix}_${name}"
      description   = config.description
      location      = config.location != null ? config.location : "${var.s3_bucket_uri}/${name}/"
      parameters    = config.parameters
    }
  }

  # All databases combined
  all_databases = merge(local.sublayer_databases, local.single_databases, local.filtered_special_databases, local.additional_databases)
}

# Create Glue databases for each combination
resource "aws_glue_catalog_database" "databases" {
  for_each = local.all_databases

  name        = each.value.database_name
  description = each.value.description
  catalog_id  = var.catalog_id

  # Set location URI for the database
  location_uri = each.value.location

  parameters = merge(
    {
      "classification" = each.value.layer
      "layer"          = each.value.layer
      "purpose"        = "data-lake-storage"
    },
    each.value.sublayer != null ? {
      "sublayer" = each.value.sublayer
    } : {},
    contains(["silver", "gold"], each.value.layer) ? {
      "table-format"    = "iceberg"
      "iceberg-enabled" = "true"
    } : {},
    # Include custom parameters for additional databases
    lookup(each.value, "parameters", {})
  )

  tags = merge(var.tags, {
    Name      = each.value.database_name
    Layer     = title(each.value.layer)
    Component = "Glue Catalog"
    }, each.value.sublayer != null ? {
    Sublayer = each.value.sublayer
    } : {}, contains(["silver", "gold"], each.value.layer) ? {
    TableFormat = "Iceberg"
  } : {})
}
