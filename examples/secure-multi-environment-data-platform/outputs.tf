# Secure Multi-Environment Data Platform Outputs

# Shared Services VPC
output "shared_services_vpc_id" {
  description = "ID of the shared services VPC"
  value       = module.shared_services_vpc.vpc_id
}

output "shared_services_vpc_cidr" {
  description = "CIDR block of the shared services VPC"
  value       = module.shared_services_vpc.vpc_cidr_block
}

# Development Environment
output "dev_vpc_id" {
  description = "ID of the development VPC"
  value       = module.dev_environment.vpc_id
}

output "dev_vpc_cidr" {
  description = "CIDR block of the development VPC"
  value       = module.dev_environment.vpc_cidr_block
}

output "dev_private_subnets" {
  description = "Private subnet IDs for development"
  value       = module.dev_environment.private_subnets
}

# Staging Environment
output "staging_vpc_id" {
  description = "ID of the staging VPC"
  value       = module.staging_environment.vpc_id
}

output "staging_vpc_cidr" {
  description = "CIDR block of the staging VPC"
  value       = module.staging_environment.vpc_cidr_block
}

output "staging_private_subnets" {
  description = "Private subnet IDs for staging"
  value       = module.staging_environment.private_subnets
}

# Production Environment
output "prod_vpc_id" {
  description = "ID of the production VPC"
  value       = module.prod_environment.vpc_id
}

output "prod_vpc_cidr" {
  description = "CIDR block of the production VPC"
  value       = module.prod_environment.vpc_cidr_block
}

output "prod_private_subnets" {
  description = "Private subnet IDs for production"
  value       = module.prod_environment.private_subnets
}

# Security Resources
output "shared_kms_key_id" {
  description = "ID of the shared KMS key"
  value       = aws_kms_key.shared_key.key_id
}

output "shared_kms_key_arn" {
  description = "ARN of the shared KMS key"
  value       = aws_kms_key.shared_key.arn
}

output "shared_kms_key_alias" {
  description = "Alias of the shared KMS key"
  value       = aws_kms_alias.shared_key_alias.name
}

# CloudTrail
output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_s3_bucket" {
  description = "S3 bucket for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.bucket
}

# Security Hub
output "security_hub_enabled" {
  description = "Whether Security Hub is enabled"
  value       = aws_securityhub_account.main.id
}

# Config
output "config_recorder_name" {
  description = "Name of the Config recorder"
  value       = aws_config_configuration_recorder.main.name
}

output "config_delivery_channel_name" {
  description = "Name of the Config delivery channel"
  value       = aws_config_delivery_channel.main.name
}

output "config_s3_bucket" {
  description = "S3 bucket for Config logs"
  value       = aws_s3_bucket.config_logs.bucket
}

# Logging
output "platform_log_group_name" {
  description = "Name of the platform CloudWatch log group"
  value       = aws_cloudwatch_log_group.platform_logs.name
}

output "platform_log_group_arn" {
  description = "ARN of the platform CloudWatch log group"
  value       = aws_cloudwatch_log_group.platform_logs.arn
}

# Environment Summary
output "environment_summary" {
  description = "Summary of all environments"
  value = {
    project_name = var.project_name
    organization = var.organization
    region       = var.region

    environments = {
      dev = {
        vpc_id = module.dev_environment.vpc_id
        vpc_cidr = module.dev_environment.vpc_cidr_block
        private_subnets = module.dev_environment.private_subnets
        public_subnets = module.dev_environment.public_subnets
        config = local.environments.dev
      }
      staging = {
        vpc_id = module.staging_environment.vpc_id
        vpc_cidr = module.staging_environment.vpc_cidr_block
        private_subnets = module.staging_environment.private_subnets
        public_subnets = module.staging_environment.public_subnets
        config = local.environments.staging
      }
      prod = {
        vpc_id = module.prod_environment.vpc_id
        vpc_cidr = module.prod_environment.vpc_cidr_block
        private_subnets = module.prod_environment.private_subnets
        public_subnets = module.prod_environment.public_subnets
        config = local.environments.prod
      }
    }

    shared_services = {
      vpc_id = module.shared_services_vpc.vpc_id
      kms_key_id = aws_kms_key.shared_key.key_id
      cloudtrail_name = aws_cloudtrail.main.name
    }
  }
}

# Security and Compliance
output "security_summary" {
  description = "Summary of security and compliance features"
  value = {
    encryption = {
      kms_key_id = aws_kms_key.shared_key.key_id
      key_rotation_enabled = local.kms_key_rotation_enabled
    }

    audit_logging = {
      cloudtrail_enabled = true
      cloudtrail_bucket = aws_s3_bucket.cloudtrail_logs.bucket
      log_retention_days = var.cloudtrail_log_retention_days
    }

    compliance = {
      security_hub_enabled = true
      config_enabled = true
      cross_region_backup = local.enable_cross_region_backup
    }

    network_security = {
      vpc_flow_logs_enabled = true
      vpc_endpoints_enabled = true
      network_isolation = "complete"
    }
  }
}

# Cost Optimization
output "cost_optimization_summary" {
  description = "Summary of cost optimization features"
  value = {
    environments = {
      dev = {
        single_nat_gateway = local.environments.dev.single_nat_gateway
        instance_types = {
          bastion = local.environments.dev.bastion_instance_type
          kafka = local.environments.dev.kafka_instance_type
        }
      }
      staging = {
        single_nat_gateway = local.environments.staging.single_nat_gateway
        instance_types = {
          bastion = local.environments.staging.bastion_instance_type
          kafka = local.environments.staging.kafka_instance_type
        }
      }
      prod = {
        single_nat_gateway = local.environments.prod.single_nat_gateway
        instance_types = {
          bastion = local.environments.prod.bastion_instance_type
          kafka = local.environments.prod.kafka_instance_type
        }
      }
    }

    storage_lifecycle = {
      cloudtrail_logs = "30d IA, 90d Glacier, 365d Deep Archive"
      data_retention = "environment-specific"
    }
  }
}

# Useful Commands
output "useful_commands" {
  description = "Useful commands for managing the platform"
  value = {
    # Security and Compliance
    view_cloudtrail_logs = "aws s3 ls s3://${aws_s3_bucket.cloudtrail_logs.bucket}/ --recursive"

    check_security_hub = "aws securityhub get-findings --region ${var.region}"

    view_config_status = "aws configservice describe-configuration-recorders --region ${var.region}"

    # VPC Information
    list_vpcs = "aws ec2 describe-vpcs --region ${var.region} --query 'Vpcs[?Tags[?Key==`Project` && Value==`${var.project_name}`]]'"

    # KMS Key Management
    describe_kms_key = "aws kms describe-key --key-id ${aws_kms_key.shared_key.key_id} --region ${var.region}"

    # Logging
    view_platform_logs = "aws logs describe-log-streams --log-group-name ${aws_cloudwatch_log_group.platform_logs.name} --region ${var.region}"

    # Environment-specific commands
    dev_vpc_info = "aws ec2 describe-vpcs --vpc-ids ${module.dev_environment.vpc_id} --region ${var.region}"
    staging_vpc_info = "aws ec2 describe-vpcs --vpc-ids ${module.staging_environment.vpc_id} --region ${var.region}"
    prod_vpc_info = "aws ec2 describe-vpcs --vpc-ids ${module.prod_environment.vpc_id} --region ${var.region}"
  }
}
