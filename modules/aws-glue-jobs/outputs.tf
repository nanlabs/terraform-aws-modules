#------------------------------------------------------------------------------
# Glue Jobs Outputs
#------------------------------------------------------------------------------

output "glue_job_names" {
  description = "Names of the created Glue jobs"
  value       = { for k, v in aws_glue_job.this : k => v.name }
}

output "glue_job_arns" {
  description = "ARNs of the created Glue jobs"
  value       = { for k, v in aws_glue_job.this : k => v.arn }
}

output "glue_job_ids" {
  description = "IDs of the created Glue jobs"
  value       = { for k, v in aws_glue_job.this : k => v.id }
}

#------------------------------------------------------------------------------
# IAM Role Outputs
#------------------------------------------------------------------------------

output "glue_execution_role_arn" {
  description = "ARN of the Glue execution IAM role"
  value       = module.glue_execution_role.iam_role_arn
}

output "glue_execution_role_name" {
  description = "Name of the Glue execution IAM role"
  value       = module.glue_execution_role.iam_role_name
}

output "glue_execution_role_id" {
  description = "ID of the Glue execution IAM role"
  value       = module.glue_execution_role.iam_role_arn
}

#------------------------------------------------------------------------------
# S3 Bucket Outputs
#------------------------------------------------------------------------------

output "scripts_bucket_name" {
  description = "Name of the S3 bucket used for Glue scripts"
  value       = local.scripts_bucket_name
}

output "scripts_bucket_arn" {
  description = "ARN of the S3 bucket used for Glue scripts"
  value       = local.scripts_bucket_arn
}

output "scripts_bucket_id" {
  description = "ID of the S3 bucket used for Glue scripts"
  value       = var.create_s3_bucket ? module.glue_scripts_bucket[0].s3_bucket_id : var.existing_s3_bucket_name
}

output "scripts_bucket_domain_name" {
  description = "Domain name of the S3 bucket used for Glue scripts"
  value       = var.create_s3_bucket ? module.glue_scripts_bucket[0].s3_bucket_bucket_domain_name : null
}

output "scripts_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket used for Glue scripts"
  value       = var.create_s3_bucket ? module.glue_scripts_bucket[0].s3_bucket_bucket_regional_domain_name : null
}

#------------------------------------------------------------------------------
# CloudWatch Log Groups Outputs
#------------------------------------------------------------------------------

output "log_group_names" {
  description = "Names of the CloudWatch log groups for Glue jobs"
  value       = { for k, v in aws_cloudwatch_log_group.glue_jobs : k => v.name }
}

output "log_group_arns" {
  description = "ARNs of the CloudWatch log groups for Glue jobs"
  value       = { for k, v in aws_cloudwatch_log_group.glue_jobs : k => v.arn }
}

#------------------------------------------------------------------------------
# Resource Metadata Outputs
#------------------------------------------------------------------------------

output "resource_prefix" {
  description = "Resource prefix used for naming"
  value       = local.resource_prefix
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}

#------------------------------------------------------------------------------
# Configuration Summary Outputs
#------------------------------------------------------------------------------

output "glue_jobs_summary" {
  description = "Summary of created Glue jobs with their key configuration"
  value = {
    for k, v in aws_glue_job.this : k => {
      name              = v.name
      arn               = v.arn
      glue_version      = v.glue_version
      worker_type       = v.worker_type
      number_of_workers = v.number_of_workers
      script_location   = v.command[0].script_location
      role_arn          = v.role_arn
      log_group         = aws_cloudwatch_log_group.glue_jobs[k].name
    }
  }
}

#------------------------------------------------------------------------------
# VPC Connection Outputs
#------------------------------------------------------------------------------

output "vpc_connection_name" {
  description = "Name of the Glue VPC connection"
  value       = aws_glue_connection.vpc_connection.name
}

output "vpc_connection_arn" {
  description = "ARN of the Glue VPC connection"
  value       = aws_glue_connection.vpc_connection.arn
}
