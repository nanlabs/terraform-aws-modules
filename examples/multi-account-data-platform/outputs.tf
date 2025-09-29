############################################################
# Consolidated Outputs
############################################################

output "infrastructure" {
  description = "Core infrastructure details"
  value = {
    vpc_id          = module.infra_vpc.vpc_id
    private_subnets = module.infra_vpc.private_subnets
    public_subnets  = module.infra_vpc.public_subnets
    transit_gateway = {
      id  = module.transit_gateway.transit_gateway_id
      arn = module.transit_gateway.transit_gateway_arn
    }
    encryption = {
      s3_kms_key_arn   = module.encryption.s3_kms_key_arn
      glue_kms_key_arn = module.encryption.glue_kms_key_arn
      permission_boundary_arn = module.encryption.permission_boundary_arn
    }
  }
}

output "dev_environment" {
  description = "Development environment deployed resources"
  value = {
    vpc_id                 = module.dev_vpc.vpc_id
    private_subnets        = module.dev_vpc.private_subnets
    public_subnets         = module.dev_vpc.public_subnets
    tgw_attachment_id      = module.dev_tgw_attachment.vpc_attachment_id
    data_lake_bucket_id    = module.dev_data_lake.storage_bucket_id
    data_lake_bucket_arn   = module.dev_data_lake.storage_bucket_arn
    data_lake_temp_bucket  = module.dev_data_lake.temp_bucket_id
    data_lake_paths        = module.dev_data_lake.data_lake_paths
    iceberg_paths          = module.dev_data_lake.iceberg_paths
    glue_job_names         = module.dev_glue_jobs.glue_job_names
  glue_workflow_names    = module.dev_glue_workflows.workflow_names
    bastion_private_ip     = module.dev_bastion.instance_private_ip
  }
}

# output "staging_environment" { ... }
# output "prod_environment" { ... }
