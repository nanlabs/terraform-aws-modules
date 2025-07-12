terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC for testing
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.21.0"

  name = "bastion-test-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "test"
  }
}

# Create bastion host
module "bastion" {
  source = "../.."

  name            = "test-bastion"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  # Enable SSM parameter storage
  create_ssm_parameters = true
  ssm_parameter_prefix  = "/test/bastion"

  # Create VPC endpoints for secure connectivity
  create_vpc_endpoints = true

  # Enable CloudWatch logs
  enable_cloudwatch_logs = true

  tags = {
    Environment = "test"
    Module      = "aws-bastion"
  }
}

# Outputs
output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.bastion.instance_id
}

output "bastion_private_ip" {
  description = "Private IP of the bastion host"
  value       = module.bastion.instance_private_ip
}

output "ssm_parameters" {
  description = "SSM parameter names for bastion details"
  value       = module.bastion.ssm_parameter_names
}
