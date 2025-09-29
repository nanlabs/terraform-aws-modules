# Secure Multi-Environment Data Platform Variables

# Core Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "secure-data-platform"
}

variable "organization" {
  description = "Organization name"
  type        = string
  default     = "company"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Common Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Platform    = "SecureDataPlatform"
    Compliance  = "required"
  }
}

# Network Configuration
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Shared Services VPC
variable "shared_services_vpc_cidr" {
  description = "CIDR block for shared services VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "shared_services_private_subnets" {
  description = "Private subnets for shared services VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "shared_services_public_subnets" {
  description = "Public subnets for shared services VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "shared_services_single_nat_gateway" {
  description = "Use single NAT gateway for shared services"
  type        = bool
  default     = false
}

# Environment Configurations
variable "environments" {
  description = "Configuration for each environment"
  type = map(object({
    vpc_cidr = string
    private_subnets = list(string)
    public_subnets = list(string)
    database_subnets = list(string)

    # Instance configurations
    bastion_instance_type = string
    kafka_instance_type = string

    # Feature flags
    enable_streaming = bool
    enable_detailed_monitoring = bool

    # Data retention
    data_retention_days = number
    log_retention_days = number

    # Cost optimization
    single_nat_gateway = bool

    # Glue configuration
    glue_max_capacity = number

    # Kafka configuration
    kafka_broker_count = number
    kafka_ebs_volume_size = number
  }))

  default = {
    dev = {
      vpc_cidr = "10.10.0.0/16"
      private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
      public_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
      database_subnets = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]

      bastion_instance_type = "t3.nano"
      kafka_instance_type = "kafka.t3.small"

      enable_streaming = false
      enable_detailed_monitoring = false

      data_retention_days = 30
      log_retention_days = 7

      single_nat_gateway = true

      glue_max_capacity = 5

      kafka_broker_count = 1
      kafka_ebs_volume_size = 50
    }

    staging = {
      vpc_cidr = "10.20.0.0/16"
      private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
      public_subnets = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
      database_subnets = ["10.20.201.0/24", "10.20.202.0/24", "10.20.203.0/24"]

      bastion_instance_type = "t3.small"
      kafka_instance_type = "kafka.m5.large"

      enable_streaming = true
      enable_detailed_monitoring = true

      data_retention_days = 90
      log_retention_days = 14

      single_nat_gateway = false

      glue_max_capacity = 10

      kafka_broker_count = 2
      kafka_ebs_volume_size = 100
    }

    prod = {
      vpc_cidr = "10.30.0.0/16"
      private_subnets = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
      public_subnets = ["10.30.101.0/24", "10.30.102.0/24", "10.30.103.0/24"]
      database_subnets = ["10.30.201.0/24", "10.30.202.0/24", "10.30.203.0/24"]

      bastion_instance_type = "t3.medium"
      kafka_instance_type = "kafka.m5.xlarge"

      enable_streaming = true
      enable_detailed_monitoring = true

      data_retention_days = 2555  # 7 years
      log_retention_days = 365

      single_nat_gateway = false

      glue_max_capacity = 20

      kafka_broker_count = 3
      kafka_ebs_volume_size = 200
    }
  }
}

# Security Configuration
variable "enable_cross_region_backup" {
  description = "Enable cross-region backup for critical data"
  type        = bool
  default     = true
}

variable "kms_deletion_window_days" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 30
}

# Logging and Monitoring
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 90
}

variable "cloudtrail_log_retention_days" {
  description = "Number of days to retain CloudTrail logs"
  type        = number
  default     = 2555  # 7 years
}

# Compliance Configuration
variable "enable_security_hub" {
  description = "Enable AWS Security Hub"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable AWS GuardDuty"
  type        = bool
  default     = true
}

# Bastion Configuration
variable "bastion_key_name" {
  description = "Key pair name for bastion hosts"
  type        = string
  default     = null
}

variable "bastion_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access bastion hosts"
  type        = list(string)
  default = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]
}

# Data Processing Configuration
variable "glue_version" {
  description = "AWS Glue version"
  type        = string
  default     = "4.0"
}

variable "kafka_version" {
  description = "Kafka version for MSK"
  type        = string
  default     = "2.8.1"
}

# Cost Optimization
variable "enable_cost_optimization" {
  description = "Enable cost optimization features"
  type        = bool
  default     = true
}

variable "enable_spot_instances" {
  description = "Enable spot instances where appropriate"
  type        = bool
  default     = false
}

# Environment Management
variable "environment_promotion_enabled" {
  description = "Enable automated environment promotion"
  type        = bool
  default     = false
}

variable "enable_blue_green_deployment" {
  description = "Enable blue-green deployment capabilities"
  type        = bool
  default     = false
}
