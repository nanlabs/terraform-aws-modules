data "aws_availability_zones" "available" {}

locals {
  azs = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, var.azs_count)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  # Core VPC Configuration
  name                  = var.name
  create_vpc            = var.create_vpc
  cidr                  = var.cidr
  secondary_cidr_blocks = var.secondary_cidr_blocks
  instance_tenancy      = var.instance_tenancy
  azs                   = local.azs

  # DNS Configuration
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  # IPv6 Configuration
  enable_ipv6                          = var.enable_ipv6
  ipv6_cidr                            = var.ipv6_cidr
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group

  # IPAM Configuration
  use_ipam_pool       = var.use_ipam_pool
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  # Public Subnets
  public_subnets                                               = var.public_subnets
  public_subnet_assign_ipv6_address_on_creation                = var.public_subnet_assign_ipv6_address_on_creation
  public_subnet_enable_dns64                                   = var.public_subnet_enable_dns64
  public_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
  public_subnet_enable_resource_name_dns_a_record_on_launch    = var.public_subnet_enable_resource_name_dns_a_record_on_launch
  create_multiple_public_route_tables                          = var.create_multiple_public_route_tables
  public_subnet_ipv6_prefixes                                  = var.public_subnet_ipv6_prefixes
  public_subnet_ipv6_native                                    = var.public_subnet_ipv6_native
  map_public_ip_on_launch                                      = var.map_public_ip_on_launch
  public_subnet_private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
  public_subnet_names                                          = var.public_subnet_names
  public_subnet_suffix                                         = var.public_subnet_suffix
  public_subnet_tags                                           = var.public_subnet_tags
  public_subnet_tags_per_az                                    = var.public_subnet_tags_per_az
  public_route_table_tags                                      = var.public_route_table_tags

  # Private Subnets
  private_subnets                                               = var.private_subnets
  private_subnet_assign_ipv6_address_on_creation                = var.private_subnet_assign_ipv6_address_on_creation
  private_subnet_enable_dns64                                   = var.private_subnet_enable_dns64
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.private_subnet_enable_resource_name_dns_aaaa_record_on_launch
  private_subnet_enable_resource_name_dns_a_record_on_launch    = var.private_subnet_enable_resource_name_dns_a_record_on_launch
  private_subnet_ipv6_prefixes                                  = var.private_subnet_ipv6_prefixes
  private_subnet_ipv6_native                                    = var.private_subnet_ipv6_native
  private_subnet_private_dns_hostname_type_on_launch            = var.private_subnet_private_dns_hostname_type_on_launch
  private_subnet_names                                          = var.private_subnet_names
  private_subnet_suffix                                         = var.private_subnet_suffix
  create_private_nat_gateway_route                              = var.create_private_nat_gateway_route
  private_subnet_tags                                           = var.private_subnet_tags
  private_subnet_tags_per_az                                    = var.private_subnet_tags_per_az
  private_route_table_tags                                      = var.private_route_table_tags

  # Database Subnets
  database_subnets                                               = var.database_subnets
  database_subnet_assign_ipv6_address_on_creation                = var.database_subnet_assign_ipv6_address_on_creation
  database_subnet_enable_dns64                                   = var.database_subnet_enable_dns64
  database_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.database_subnet_enable_resource_name_dns_aaaa_record_on_launch
  database_subnet_enable_resource_name_dns_a_record_on_launch    = var.database_subnet_enable_resource_name_dns_a_record_on_launch
  database_subnet_ipv6_prefixes                                  = var.database_subnet_ipv6_prefixes
  database_subnet_ipv6_native                                    = var.database_subnet_ipv6_native
  database_subnet_private_dns_hostname_type_on_launch            = var.database_subnet_private_dns_hostname_type_on_launch
  database_subnet_names                                          = var.database_subnet_names
  database_subnet_suffix                                         = var.database_subnet_suffix
  create_database_subnet_route_table                             = var.create_database_subnet_route_table
  create_database_internet_gateway_route                         = var.create_database_internet_gateway_route
  create_database_nat_gateway_route                              = var.create_database_nat_gateway_route
  database_route_table_tags                                      = var.database_route_table_tags
  database_subnet_tags                                           = var.database_subnet_tags
  create_database_subnet_group                                   = var.create_database_subnet_group
  database_subnet_group_name                                     = var.database_subnet_group_name
  database_subnet_group_tags                                     = var.database_subnet_group_tags

  # NAT Gateway Configuration
  enable_nat_gateway                 = var.enable_nat_gateway
  nat_gateway_destination_cidr_block = var.nat_gateway_destination_cidr_block
  single_nat_gateway                 = var.single_nat_gateway
  one_nat_gateway_per_az             = var.one_nat_gateway_per_az
  reuse_nat_ips                      = var.reuse_nat_ips
  external_nat_ip_ids                = var.external_nat_ip_ids
  external_nat_ips                   = var.external_nat_ips
  nat_gateway_tags                   = var.nat_gateway_tags
  nat_eip_tags                       = var.nat_eip_tags

  # Internet Gateway Configuration
  create_igw             = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw
  igw_tags               = var.igw_tags

  # VPC Flow Logs Configuration
  enable_flow_log                                 = var.enable_flow_log
  vpc_flow_log_iam_role_name                      = var.vpc_flow_log_iam_role_name
  vpc_flow_log_iam_role_use_name_prefix           = var.vpc_flow_log_iam_role_use_name_prefix
  vpc_flow_log_permissions_boundary               = var.vpc_flow_log_permissions_boundary
  vpc_flow_log_iam_policy_name                    = var.vpc_flow_log_iam_policy_name
  vpc_flow_log_iam_policy_use_name_prefix         = var.vpc_flow_log_iam_policy_use_name_prefix
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_traffic_type                           = var.flow_log_traffic_type
  flow_log_destination_type                       = var.flow_log_destination_type
  flow_log_log_format                             = var.flow_log_log_format
  flow_log_destination_arn                        = var.flow_log_destination_arn
  flow_log_deliver_cross_account_role             = var.flow_log_deliver_cross_account_role
  flow_log_file_format                            = var.flow_log_file_format
  flow_log_hive_compatible_partitions             = var.flow_log_hive_compatible_partitions
  flow_log_per_hour_partition                     = var.flow_log_per_hour_partition
  vpc_flow_log_tags                               = var.vpc_flow_log_tags
  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  flow_log_cloudwatch_iam_role_conditions         = var.flow_log_cloudwatch_iam_role_conditions
  flow_log_cloudwatch_iam_role_arn                = var.flow_log_cloudwatch_iam_role_arn
  flow_log_cloudwatch_log_group_name_prefix       = var.flow_log_cloudwatch_log_group_name_prefix
  flow_log_cloudwatch_log_group_name_suffix       = var.flow_log_cloudwatch_log_group_name_suffix
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id
  flow_log_cloudwatch_log_group_skip_destroy      = var.flow_log_cloudwatch_log_group_skip_destroy
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class

  # Tags
  tags                               = var.tags
  vpc_tags                           = var.vpc_tags
  vpc_block_public_access_options    = var.vpc_block_public_access_options
  vpc_block_public_access_exclusions = var.vpc_block_public_access_exclusions

  # DHCP Options
  enable_dhcp_options                            = var.enable_dhcp_options
  dhcp_options_domain_name                       = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers               = var.dhcp_options_domain_name_servers
  dhcp_options_ntp_servers                       = var.dhcp_options_ntp_servers
  dhcp_options_netbios_name_servers              = var.dhcp_options_netbios_name_servers
  dhcp_options_netbios_node_type                 = var.dhcp_options_netbios_node_type
  dhcp_options_ipv6_address_preferred_lease_time = var.dhcp_options_ipv6_address_preferred_lease_time
  dhcp_options_tags                              = var.dhcp_options_tags
  putin_khuylo                                   = var.putin_khuylo
}
