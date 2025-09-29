# Data Processing Pipeline Variables

# Required variables
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "data-pipeline"
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
    Project   = "DataProcessingPipeline"
  }
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
}

variable "database_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.201.0/24", "10.20.202.0/24", "10.20.203.0/24"]
}

variable "single_nat_gateway" {
  description = "Should be true to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

# S3 Configuration
variable "s3_transition_standard_ia_days" {
  description = "Number of days after which to transition objects to Standard-IA storage class"
  type        = number
  default     = 30
}

variable "s3_transition_glacier_days" {
  description = "Number of days after which to transition objects to Glacier storage class"
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
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs"
  type        = number
  default     = 10
}

variable "glue_max_retries" {
  description = "The maximum number of times to retry this job if it fails"
  type        = number
  default     = 1
}

variable "glue_timeout_minutes" {
  description = "The job timeout in minutes"
  type        = number
  default     = 2880 # 48 hours
}

variable "glue_notification_delay" {
  description = "After a job run starts, the number of minutes to wait before sending a job run delay notification"
  type        = number
  default     = 10
}

variable "glue_job_schedule" {
  description = "Cron expression for Glue job schedule"
  type        = string
  default     = "cron(0 2 * * ? *)" # Daily at 2 AM UTC
}

variable "crawler_schedule" {
  description = "Cron expression for Glue crawler schedule"
  type        = string
  default     = "cron(0 1 * * ? *)" # Daily at 1 AM UTC
}

variable "start_workflow_on_creation" {
  description = "Whether to start the workflow on creation"
  type        = bool
  default     = false
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
  default     = "t3.micro"
}

variable "bastion_key_name" {
  description = "Key pair name for bastion host (optional)"
  type        = string
  default     = null
}

variable "bastion_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Lambda Configuration
variable "enable_lambda_processing" {
  description = "Enable Lambda functions for event processing"
  type        = bool
  default     = false
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

# Cost Optimization
variable "enable_cost_optimization" {
  description = "Enable cost optimization features"
  type        = bool
  default     = true
}

variable "enable_spot_instances" {
  description = "Enable spot instances for cost savings"
  type        = bool
  default     = false
}
