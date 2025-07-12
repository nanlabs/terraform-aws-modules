module "mongodb_atlas_cluster" {
  source = "../../"

  project_name = var.project_name
  org_id       = var.org_id

  cluster_name      = var.cluster_name
  region            = var.region
  instance_type     = var.instance_type
  mongodb_major_ver = var.mongodb_major_ver
  cluster_type      = var.cluster_type
  num_shards        = var.num_shards
  backup_enabled    = var.backup_enabled

  # AWS Integration
  create_ssm_parameters = var.create_ssm_parameters
  ssm_parameter_prefix  = var.ssm_parameter_prefix
  create_secret         = var.create_secret
  secret_prefix         = var.secret_prefix

  access_lists = var.access_lists

  tags = var.tags
}
