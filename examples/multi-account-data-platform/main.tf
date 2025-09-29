############################################################
# Multi-Account Data Platform (Infra + Dev) with KMS
#
# This example shows a realistic pattern:
#  - Shared infrastructure account provisions core networking, transit gateway, and encryption (KMS)
#  - Workloads (dev) account provisions its own VPC, attaches to TGW, and deploys data lake + Glue jobs
#  - Staging & Prod blocks are provided commented out for promotion path demonstration
#
# Naming convention: namespace-short_domain-account-component-environment
#   e.g., dwh-wl-infra-networking, dwh-wl-workloads-data-lake-dev
############################################################

locals {
  account_tags = {
    infrastructure = merge(var.tags, { Account = "infrastructure" })
    dev            = merge(var.tags, { Account = "workloads-dev" })
    # staging       = merge(var.tags, { Account = "workloads-staging" })
    # prod          = merge(var.tags, { Account = "workloads-prod" })
  }

  name_prefixes = {
    infrastructure = "${var.namespace}-${var.short_domain}-infra"
    dev            = "${var.namespace}-${var.short_domain}-workloads-dev"
    # staging       = "${var.namespace}-${var.short_domain}-workloads-staging"
    # prod          = "${var.namespace}-${var.short_domain}-workloads-prod"
  }
}

############################################################
# 1. Infrastructure Account - VPC & Transit Gateway
############################################################

module "infra_vpc" {
  source = "../../modules/aws-vpc"

  providers = { aws = aws.infrastructure }

  name = "${local.name_prefixes.infrastructure}-networking"
  cidr = var.vpc_cidr

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = var.private_subnet_cidrs
  public_subnets   = var.public_subnet_cidrs
  enable_nat_gateway = false

  tags = local.account_tags.infrastructure
}

module "transit_gateway" {
  source = "../../modules/aws-transit-gateway"

  providers = { aws = aws.infrastructure }

  name = "${local.name_prefixes.infrastructure}-tgw"

  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true

  tags = local.account_tags.infrastructure
}

############################################################
# 2. Infrastructure Account - Central Encryption (KMS)
############################################################

module "encryption" {
  source = "../../modules/aws-data-lake-encryption"

  providers = { aws = aws.infrastructure }

  name = "${local.name_prefixes.infrastructure}-encryption"
  tags = local.account_tags.infrastructure

  enable_kms_logging        = true
  create_permission_boundary = true
}

############################################################
# 3. Dev Workloads Account - VPC
############################################################

module "dev_vpc" {
  source = "../../modules/aws-vpc"

  providers = { aws = aws.workloads_dev }

  name             = "${local.name_prefixes.dev}-networking"
  cidr             = var.dev_vpc_cidr
  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = var.dev_private_subnet_cidrs
  public_subnets   = var.dev_public_subnet_cidrs
  enable_nat_gateway = false

  tags = local.account_tags.dev
}

############################################################
# 4. Dev Workloads Account - TGW Attachment
############################################################

module "dev_tgw_attachment" {
  source = "../../modules/aws-transit-gateway-spoke"

  providers = { aws = aws.workloads_dev }

  name                    = "${local.name_prefixes.dev}-tgw-attachment"
  transit_gateway_id      = module.transit_gateway.transit_gateway_id
  vpc_id                  = module.dev_vpc.vpc_id
  vpc_cidr                = var.dev_vpc_cidr
  hub_vpc_cidr            = var.vpc_cidr
  subnet_ids              = module.dev_vpc.private_subnets
  private_route_table_ids = module.dev_vpc.private_route_table_ids

  tags = local.account_tags.dev
}

############################################################
# 5. Dev Workloads Account - Data Lake (S3) using infra KMS
############################################################

module "dev_data_lake" {
  source = "../../modules/aws-data-lake-infrastructure"

  providers = { aws = aws.workloads_dev }

  name       = "${local.name_prefixes.dev}-data-lake"
  tags       = local.account_tags.dev

  kms_key_arn        = module.encryption.s3_kms_key_arn
  create_temp_bucket = true
}

############################################################
# 6. (Optional) Bastion host in Dev for troubleshooting
############################################################

module "dev_bastion" {
  source = "../../modules/aws-bastion"

  providers = { aws = aws.workloads_dev }

  name               = "${local.name_prefixes.dev}-bastion"
  vpc_id             = module.dev_vpc.vpc_id
  private_subnets    = module.dev_vpc.private_subnets
  public_subnets     = module.dev_vpc.public_subnets
  allowed_cidrs      = var.allowed_admin_cidrs
  instance_type      = "t3.micro"
  create_ssh_key     = false

  tags = local.account_tags.dev
}

############################################################
# 7. Dev Glue Jobs / Workflows (Skeleton)
############################################################

module "dev_glue_jobs" {
  source = "../../modules/aws-glue-jobs"

  providers = { aws = aws.workloads_dev }

  name = "${local.name_prefixes.dev}-glue-jobs"
  tags = local.account_tags.dev

  glue_jobs = {
    sample_job = {
      description          = "Example Spark ETL job (dev)"
      worker_type          = "G.1X"
      number_of_workers    = 2
      timeout              = 10
      max_retries          = 0
      glue_version         = "4.0"
      python_version       = "3"
      command = {
        script_location = "s3://${module.dev_data_lake.storage_bucket_id}/scripts/sample_job.py"
      }
      temp_s3_path      = module.dev_data_lake.temp_bucket_id != null ? "s3://${module.dev_data_lake.temp_bucket_id}/tmp/" : null
      default_arguments    = {
        "--enable-metrics" = "true"
      }
    }
  }
}

module "dev_glue_workflows" {
  source = "../../modules/aws-glue-workflow"

  providers = { aws = aws.workloads_dev }

  name = "${local.name_prefixes.dev}-glue-workflows"
  tags = local.account_tags.dev

  workflows = {
    nightly_ingestion = {
      description = "Nightly ingestion + transformation workflow"
      triggers = [
        {
          name        = "nightly-schedule"
          type        = "SCHEDULED"
          schedule    = "cron(0 2 * * ? *)" # 2 AM UTC
          enabled     = true
          start_on_creation = true
          actions = [{ job_name = module.dev_glue_jobs.glue_job_names["sample_job"] }]
        }
      ]
    }
  }
}

############################################################
# 8. (Commented) Staging / Prod Blocks (Pattern Reference)
############################################################

# module "staging_vpc" { ... }
# module "staging_tgw_attachment" { ... }
# module "staging_data_lake" { ... kms_key_arn = module.encryption.s3_kms_key_arn }
# module "staging_glue_jobs" { ... reuse upgraded scripts }
# module "staging_glue_workflows" { ... promote schedule }
#
# module "prod_vpc" { ... enhanced networking / extra subnets }
# module "prod_tgw_attachment" { ... }
# module "prod_data_lake" { ... kms_key_arn = module.encryption.s3_kms_key_arn enable_versioning = true }
# module "prod_glue_jobs" { ... version_locked scripts }
# module "prod_glue_workflows" { ... more granular workflows }

############################################################
# End of main
############################################################
