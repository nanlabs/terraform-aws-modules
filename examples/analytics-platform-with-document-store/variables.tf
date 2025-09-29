# Analytics Platform with Document Store Variables

# Required variables
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "analytics-platform"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Common tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Platform  = "AnalyticsPlatform"
  }
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.40.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.40.101.0/24", "10.40.102.0/24", "10.40.103.0/24"]
}

variable "database_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.40.201.0/24", "10.40.202.0/24", "10.40.203.0/24"]
}

variable "single_nat_gateway" {
  description = "Should be true to provision a single shared NAT Gateway"
  type        = bool
  default     = false
}

# DocumentDB Configuration
variable "docdb_engine_version" {
  description = "DocumentDB engine version"
  type        = string
  default     = "4.0.0"
}

variable "docdb_instance_class" {
  description = "DocumentDB instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "docdb_cluster_size" {
  description = "Number of DocumentDB instances in the cluster"
  type        = number
  default     = 2
}

variable "docdb_backup_retention_period" {
  description = "DocumentDB backup retention period in days"
  type        = number
  default     = 7
}

variable "docdb_preferred_backup_window" {
  description = "DocumentDB preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "docdb_preferred_maintenance_window" {
  description = "DocumentDB preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "docdb_enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["audit"]
}

variable "docdb_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access DocumentDB"
  type        = list(string)
  default     = []
}

variable "docdb_kms_key_id" {
  description = "KMS key ID for DocumentDB encryption"
  type        = string
  default     = null
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights for DocumentDB"
  type        = bool
  default     = true
}

# S3 Configuration
variable "s3_transition_standard_ia_days" {
  description = "Number of days after which to transition objects to Standard-IA"
  type        = number
  default     = 30
}

variable "s3_transition_glacier_days" {
  description = "Number of days after which to transition objects to Glacier"
  type        = number
  default     = 90
}

variable "s3_expiration_days" {
  description = "Number of days after which to expire objects"
  type        = number
  default     = 365
}

# Glue Configuration
variable "glue_version" {
  description = "The version of Glue to use"
  type        = string
  default     = "4.0"
}

variable "glue_max_capacity" {
  description = "The maximum number of AWS Glue data processing units (DPUs)"
  type        = number
  default     = 10
}

variable "glue_max_retries" {
  description = "The maximum number of times to retry a failed job"
  type        = number
  default     = 1
}

variable "glue_timeout_minutes" {
  description = "The job timeout in minutes"
  type        = number
  default     = 2880 # 48 hours
}

variable "crawler_schedule" {
  description = "Cron expression for Glue crawler schedule"
  type        = string
  default     = "cron(0 2 * * ? *)" # Daily at 2 AM UTC
}

# Kafka/MSK Configuration
variable "enable_streaming" {
  description = "Enable Kafka streaming with MSK"
  type        = bool
  default     = true
}

variable "kafka_version" {
  description = "Kafka version"
  type        = string
  default     = "2.8.1"
}

variable "kafka_broker_count" {
  description = "Number of Kafka broker nodes"
  type        = number
  default     = 2
}

variable "kafka_instance_type" {
  description = "Instance type for Kafka brokers"
  type        = string
  default     = "kafka.m5.large"
}

variable "kafka_ebs_volume_size" {
  description = "EBS volume size for Kafka brokers in GB"
  type        = number
  default     = 100
}

# Bastion Configuration
variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.small"
}

variable "bastion_key_name" {
  description = "Key pair name for bastion host"
  type        = string
  default     = null
}

variable "bastion_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Monitoring Configuration
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for instances"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

# Feature Flags
variable "enable_document_search" {
  description = "Enable full-text search capabilities"
  type        = bool
  default     = true
}

variable "enable_ml_integration" {
  description = "Enable machine learning feature extraction"
  type        = bool
  default     = true
}

variable "enable_real_time_sync" {
  description = "Enable real-time sync between document store and data lake"
  type        = bool
  default     = true
}

# Cost Optimization
variable "enable_cost_optimization" {
  description = "Enable cost optimization features"
  type        = bool
  default     = true
}

variable "enable_spot_instances" {
  description = "Enable spot instances for cost savings (non-production)"
  type        = bool
  default     = false
}

# Kafka (MSK) Configuration
variable "kafka_broker_instance_type" {
  description = "Instance type for Kafka brokers"
  type        = string
  default     = "kafka.t3.small"
}

variable "kafka_broker_per_zone" {
  description = "Number of Kafka brokers per availability zone"
  type        = number
  default     = 1
}

variable "kafka_broker_volume_size" {
  description = "Size of the EBS volume for Kafka brokers (GB)"
  type        = number
  default     = 100
}

variable "kafka_storage_autoscaling_target" {
  description = "Target utilization percentage for Kafka storage autoscaling"
  type        = number
  default     = 70
}
