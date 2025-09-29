# Analytics Platform with Document Store Outputs

# VPC Information
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = module.vpc.database_subnets
}

# Data Lake Information
output "data_lake_bucket_name" {
  description = "Name (ID) of the main data lake bucket"
  value       = module.data_lake.storage_bucket_id
}

output "data_lake_bucket_arn" {
  description = "ARN of the main data lake bucket"
  value       = module.data_lake.storage_bucket_arn
}

# Data Lake Paths
output "data_lake_raw_zone_path" {
  description = "S3 path to the raw zone"
  value       = module.data_lake.data_lake_paths.raw_zone
}

output "data_lake_bronze_path" {
  description = "S3 path to the bronze layer"
  value       = module.data_lake.data_lake_paths.bronze
}

# DocumentDB Information
output "documentdb_cluster_endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = module.docdb.writer_endpoint
}

output "documentdb_cluster_reader_endpoint" {
  description = "DocumentDB cluster reader endpoint"
  value       = module.docdb.reader_endpoint
}

output "documentdb_cluster_identifier" {
  description = "DocumentDB cluster identifier"
  value       = module.docdb.cluster_name
}

output "documentdb_cluster_arn" {
  description = "DocumentDB cluster ARN"
  value       = module.docdb.arn
}

output "documentdb_port" {
  description = "DocumentDB port"
  value       = module.docdb.port
}

# Glue outputs
output "glue_database_name" {
  description = "Glue database name"
  value       = "${replace(local.name, "-", "_")}_database" # Static name since no glue_catalog module
}

output "glue_crawler_name" {
  description = "Glue crawler name"
  value       = "${local.name}-crawler" # Static name since no glue_catalog module
}

output "glue_jobs" {
  description = "Information about created Glue jobs"
  value = {
    for job in keys(module.glue_jobs.glue_job_names) : job.name => {
      name     = job.name
      arn      = job.arn
      role_arn = job.role_arn
    }
  }
}

# Kafka Information (conditional)
output "kafka_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = var.enable_streaming ? module.msk.cluster_arn : null
}

output "kafka_bootstrap_brokers" {
  description = "Bootstrap brokers of the MSK cluster"
  value       = var.enable_streaming ? module.msk.bootstrap_brokers : null
}

output "kafka_bootstrap_brokers_tls" {
  description = "TLS bootstrap brokers of the MSK cluster"
  value       = var.enable_streaming ? module.msk.bootstrap_brokers_tls : null
}

# Bastion Host Information
output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value       = module.bastion.instance_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.bastion.instance_private_ip
}

output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = module.bastion.instance_private_ip
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion host"
  value       = module.bastion.security_group_id
}

# CloudWatch Logs
output "analytics_platform_log_group_name" {
  description = "Name of the analytics platform CloudWatch log group"
  value       = aws_cloudwatch_log_group.analytics_platform_logs.name
}

# Platform Summary
output "platform_summary" {
  description = "Summary of the analytics platform infrastructure"
  value = {
    project_name = var.project_name
    environment  = var.environment
    region       = var.region

    # Infrastructure
    vpc_id = module.vpc.vpc_id

    # Data Storage
  data_lake_bucket = module.data_lake.storage_bucket_id
  documents_bucket = module.data_lake.storage_bucket_id

    # Document Database
    documentdb_endpoint  = module.docdb.writer_endpoint
    documentdb_instances = var.docdb_cluster_size

    # Processing
    glue_database = "${replace(local.name, "-", "_")}_database"
    job_count     = length(keys(module.glue_jobs.glue_job_names))

    # Streaming
    streaming_enabled = var.enable_streaming
    kafka_cluster     = var.enable_streaming ? module.msk.cluster_name : "disabled"

    # Access
    bastion_ip = module.bastion.instance_private_ip

    # Features
    document_search_enabled = var.enable_document_search
    ml_integration_enabled  = var.enable_ml_integration
    real_time_sync_enabled  = var.enable_real_time_sync
  }
}

# Connection Information
output "connection_info" {
  description = "Connection information for accessing the platform"
  value = {
    documentdb = {
      endpoint            = module.docdb.writer_endpoint
      port                = module.docdb.port
      connect_via_bastion = "mongo --host ${module.docdb.writer_endpoint} --port ${module.docdb.port} --ssl"
    }

    bastion = {
      public_ip       = module.bastion.instance_private_ip
      connect_command = "aws ssm start-session --target ${module.bastion.instance_id}"
    }

    data_lake = {
  main_bucket        = module.data_lake.storage_bucket_id
  documents_bucket   = module.data_lake.storage_bucket_id
  ml_features_bucket = module.data_lake.storage_bucket_id
    }

    kafka = var.enable_streaming ? {
      bootstrap_brokers = module.msk.bootstrap_brokers
      zookeeper_connect = module.msk.zookeeper_connect_string
    } : null
  }
}

# Useful Commands
output "useful_commands" {
  description = "Useful commands for managing the analytics platform"
  value = {
    # DocumentDB commands
    connect_to_documentdb = "mongo --host ${module.docdb.writer_endpoint} --port ${module.docdb.port} --ssl --sslCAFile rds-ca-2019-root.pem"

    # S3 commands
  list_documents         = "aws s3 ls s3://${module.data_lake.storage_bucket_id}/ --recursive"
  list_data_lake         = "aws s3 ls s3://${module.data_lake.storage_bucket_id}/ --recursive"
  upload_sample_document = "aws s3 cp sample-doc.json s3://${module.data_lake.storage_bucket_id}/"

    # Glue commands
    list_glue_jobs      = "aws glue list-jobs --region ${var.region}"
    start_crawler       = "aws glue start-crawler --name ${"${local.name}-crawler"} --region ${var.region}"
    check_glue_database = "aws glue get-database --name ${"${replace(local.name, "-", "_")}_database"} --region ${var.region}"

    # Kafka commands (if enabled)
    list_kafka_topics = var.enable_streaming ? "aws kafka list-clusters --region ${var.region}" : "Kafka not enabled"

    # Bastion connection
    connect_to_bastion = "aws ssm start-session --target ${module.bastion.instance_id} --region ${var.region}"

    # Monitoring
    view_platform_logs = "aws logs describe-log-streams --log-group-name ${aws_cloudwatch_log_group.analytics_platform_logs.name} --region ${var.region}"
  }
}
