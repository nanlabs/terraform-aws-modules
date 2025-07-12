# Bastion Host Specific Variables

variable "vpc_id" {
  description = "VPC id in which the EC2 instance is to be created."
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets in which the EC2 instance is to be created."
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnets for VPC endpoints (optional). If not provided, private_subnets will be used."
  type        = list(string)
  default     = []
}

variable "ami" {
  description = "AMI to use for the instance - will default to latest Ubuntu"
  type        = string
  default     = ""
}

// https://aws.amazon.com/ec2/instance-types/
variable "instance_type" {
  description = "EC2 instance type/size - the default is not part of free tier!"
  type        = string
  default     = "t3.nano"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "Allow these CIDR blocks to the bastion host"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "SSH key name to use for the instance"
  type        = string
  default     = ""
}

variable "create_ssh_key" {
  description = "Whether to create an SSH key pair and store it in SSM Parameter Store"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key content. If not provided and create_ssh_key is true, will generate a new key pair"
  type        = string
  default     = ""
}

# VPC Endpoints Configuration
variable "create_vpc_endpoints" {
  description = "Create VPC endpoints for SSM, EC2 Messages, and SSM Messages"
  type        = bool
  default     = true
}

variable "vpc_endpoints_subnet_ids" {
  description = "Subnet IDs for VPC endpoints. If not specified, will use private_subnets"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_route_table_ids" {
  description = "Route table IDs for VPC endpoints (for Gateway endpoints)"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_policy" {
  description = "Policy to apply to VPC endpoints"
  type        = string
  default     = null
}

# Monitoring and Logging
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for the bastion host"
  type        = bool
  default     = false
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs for the bastion host"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 7
}
