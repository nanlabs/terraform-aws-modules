# Output all database information
output "databases" {
  description = "Map of all created Glue databases with their details"
  value = {
    for key, db in aws_glue_catalog_database.databases : key => {
      name     = db.name
      arn      = db.arn
      layer    = local.all_databases[key].layer
      sublayer = local.all_databases[key].sublayer
      location = db.location_uri
    }
  }
}

# Output databases by layer for easier access
output "databases_by_layer" {
  description = "Map of databases organized by layer"
  value = {
    for layer in var.layers : layer => {
      for key, db in aws_glue_catalog_database.databases :
      # Use sublayer if it exists, otherwise use "data" as default
      coalesce(local.all_databases[key].sublayer, "data") => {
        name     = db.name
        arn      = db.arn
        location = db.location_uri
      } if local.all_databases[key].layer == layer
    }
  }
}

# Output databases by sublayer for easier access (only for layers with sublayers)
output "databases_by_sublayer" {
  description = "Map of databases organized by sublayer"
  value = {
    for sublayer in flatten([
      for layer, sublayers in var.data_lake_sublayers : sublayers
      ]) : sublayer => {
      for key, db in aws_glue_catalog_database.databases :
      local.all_databases[key].layer => {
        name     = db.name
        arn      = db.arn
        location = db.location_uri
      } if local.all_databases[key].sublayer == sublayer
    }
  }
}

# Output special databases
output "shared_database" {
  description = "Shared database details"
  value = var.create_shared_databases && contains(keys(aws_glue_catalog_database.databases), "shared") ? {
    name     = aws_glue_catalog_database.databases["shared"].name
    arn      = aws_glue_catalog_database.databases["shared"].arn
    location = aws_glue_catalog_database.databases["shared"].location_uri
  } : null
}

output "export_database" {
  description = "Export database details"
  value = var.create_export_database && contains(keys(aws_glue_catalog_database.databases), "export") ? {
    name     = aws_glue_catalog_database.databases["export"].name
    arn      = aws_glue_catalog_database.databases["export"].arn
    location = aws_glue_catalog_database.databases["export"].location_uri
  } : null
}

# Legacy outputs for backward compatibility (pick the first database for each layer)
output "raw_zone_database_name" {
  description = "Name of the first raw_zone database (for backward compatibility)"
  value = length([
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "raw_zone"
    ]) > 0 ? [
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "raw_zone"
  ][0] : null
}

output "bronze_database_name" {
  description = "Name of the first bronze database (for backward compatibility)"
  value = length([
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "bronze"
    ]) > 0 ? [
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "bronze"
  ][0] : null
}

output "silver_database_name" {
  description = "Name of the first silver database (for backward compatibility)"
  value = length([
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "silver"
    ]) > 0 ? [
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "silver"
  ][0] : null
}

output "gold_database_name" {
  description = "Name of the first gold database (for backward compatibility)"
  value = length([
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "gold"
    ]) > 0 ? [
    for key, db in aws_glue_catalog_database.databases : db.name
    if local.all_databases[key].layer == "gold"
  ][0] : null
}

# Output database ARNs map for easier reference
output "database_arns" {
  description = "Map of database names to ARNs"
  value = {
    for key, db in aws_glue_catalog_database.databases : db.name => db.arn
  }
}
