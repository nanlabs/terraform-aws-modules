# Data Processing Pipeline Outputs

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

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

# S3 Bucket Information
output "data_lake_bucket_name" {
  description = "Name (ID) of the main data lake bucket"
  value       = module.data_lake_bucket.storage_bucket_id
}

output "data_lake_bucket_arn" {
  description = "ARN of the main data lake bucket"
  value       = module.data_lake_bucket.storage_bucket_arn
}

// No additional buckets are exposed by the data lake module now (legacy removed)

# Glue Information
output "glue_databases" {
  description = "Glue database names for each layer (legacy single outputs replaced)"
  value = {
    raw_zone = module.glue_catalog.raw_zone_database_name
    bronze   = module.glue_catalog.bronze_database_name
    silver   = module.glue_catalog.silver_database_name
    gold     = module.glue_catalog.gold_database_name
  }
}

output "glue_jobs" {
  description = "Map of Glue job names"
  value       = module.glue_jobs.glue_job_names
}

output "glue_workflows" {
  description = "Map of workflow logical keys to names"
  value       = module.glue_workflow.workflow_names
}

# MSK/Kafka Information (conditional)
output "kafka_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = var.enable_streaming ? module.msk_cluster[0].cluster_arn : null
}

output "kafka_bootstrap_brokers" {
  description = "Bootstrap brokers of the MSK cluster"
  value       = var.enable_streaming ? module.msk_cluster[0].bootstrap_brokers : null
}

output "kafka_bootstrap_brokers_tls" {
  description = "TLS bootstrap brokers of the MSK cluster"
  value       = var.enable_streaming ? module.msk_cluster[0].bootstrap_brokers_tls : null
}

output "kafka_zookeeper_connect_string" {
  description = "Zookeeper connection string"
  value       = var.enable_streaming ? module.msk_cluster[0].zookeeper_connect_string : null
}

# Bastion Host Information
output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value       = module.bastion.instance_id
}

// Bastion module only exposes instance private details; no public IP is created (SSM access)
output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = module.bastion.instance_private_ip
}

output "bastion_security_group_id" {
  description = "Security group ID of the bastion host"
  value       = module.bastion.security_group_id
}

# IAM Roles and Policies
// Glue service role comes from glue_jobs module execution role
output "glue_execution_role_arn" {
  description = "ARN of the Glue execution IAM role"
  value       = module.glue_jobs.glue_execution_role_arn
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role (if enabled)"
  value       = var.enable_lambda_processing ? aws_iam_role.lambda_execution_role[0].arn : null
}

# CloudWatch Log Groups
output "glue_log_group_name" {
  description = "Name of the Glue CloudWatch log group"
  value       = aws_cloudwatch_log_group.glue_logs.name
}

output "glue_log_group_arn" {
  description = "ARN of the Glue CloudWatch log group"
  value       = aws_cloudwatch_log_group.glue_logs.arn
}

output "lambda_log_group_name" {
  description = "Name of the Lambda CloudWatch log group (if enabled)"
  value       = var.enable_lambda_processing ? aws_cloudwatch_log_group.lambda_logs[0].name : null
}

# Connection Information
// VPC endpoints not created directly by this VPC module example

# Data Pipeline Summary
output "pipeline_summary" {
  description = "Summary of the data processing pipeline"
  value = {
    project_name = var.project_name
    environment  = var.environment
    region       = var.region

    # Infrastructure
    vpc_id = module.vpc.vpc_id

    # Storage
  main_bucket = module.data_lake_bucket.storage_bucket_id

    # Processing
  glue_database = module.glue_catalog.bronze_database_name
    job_count     = length(local.glue_jobs)

    # Streaming
    streaming_enabled = var.enable_streaming
    kafka_cluster     = var.enable_streaming ? module.msk_cluster[0].cluster_name : "disabled"

    # Access
  bastion_private_ip = module.bastion.instance_private_ip

    # Monitoring
    log_retention_days = var.log_retention_days

    # Cost optimization
    single_nat_gateway = var.single_nat_gateway
    spot_instances     = var.enable_spot_instances
  }
}

# Quick Access Commands
output "useful_commands" {
  description = "Useful AWS CLI commands for managing the pipeline"
  value = {
  upload_data = "aws s3 cp your-file.json s3://${module.data_lake_bucket.storage_bucket_id}/raw/"

    list_glue_jobs = "aws glue list-jobs --region ${var.region}"

  start_workflow = "aws glue start-workflow-run --name ${module.glue_workflow.workflow_names["data_processing"]} --region ${var.region}"

    list_kafka_clusters = var.enable_streaming ? "aws kafka list-clusters --region ${var.region}" : "Kafka not enabled"

    connect_bastion = "aws ssm start-session --target ${module.bastion.instance_id} --region ${var.region}"

    view_glue_logs = "aws logs describe-log-streams --log-group-name ${aws_cloudwatch_log_group.glue_logs.name} --region ${var.region}"
  }
}
