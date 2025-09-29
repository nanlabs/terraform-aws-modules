# ==============================================================================
# SHARED SERVICES VPC PARAMETERS
# Store Shared Services VPC information in SSM Parameter Store for cross-account access
# ==============================================================================

resource "aws_ssm_parameter" "shared_services_vpc_id" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-vpc-id"
  type  = "String"
  value = var.shared_services_vpc_id

  description = "Shared Services VPC ID for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-vpc-id"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

resource "aws_ssm_parameter" "shared_services_vpc_cidr" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-vpc-cidr"
  type  = "String"
  value = var.shared_services_vpc_cidr

  description = "Shared Services VPC CIDR block for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-vpc-cidr"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

# ==============================================================================
# EGRESS VPC PARAMETERS
# Store Egress VPC information in SSM Parameter Store for cross-account access
# ==============================================================================

resource "aws_ssm_parameter" "egress_vpc_id" {
  name  = "/${var.name_prefix}/shared-networking/egress-vpc-id"
  type  = "String"
  value = var.egress_vpc_id

  description = "Egress VPC ID for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-egress-vpc-id"
    Purpose = "cross-account-networking"
    VPCType = "egress"
  })
}

resource "aws_ssm_parameter" "egress_vpc_cidr" {
  name  = "/${var.name_prefix}/shared-networking/egress-vpc-cidr"
  type  = "String"
  value = var.egress_vpc_cidr

  description = "Egress VPC CIDR block for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-egress-vpc-cidr"
    Purpose = "cross-account-networking"
    VPCType = "egress"
  })
}

resource "aws_ssm_parameter" "egress_nat_gateway_ids" {
  name  = "/${var.name_prefix}/shared-networking/egress-nat-gateway-ids"
  type  = "StringList"
  value = join(",", var.egress_nat_gateway_ids)

  description = "Egress VPC NAT Gateway IDs for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-egress-nat-gateway-ids"
    Purpose = "cross-account-networking"
    VPCType = "egress"
  })
}

# ==============================================================================
# TRANSIT GATEWAY PARAMETERS
# Store Transit Gateway information in SSM Parameter Store for cross-account access
# ==============================================================================

resource "aws_ssm_parameter" "transit_gateway_id" {
  name  = "/${var.name_prefix}/shared-networking/transit-gateway-id"
  type  = "String"
  value = var.transit_gateway_id

  description = "Transit Gateway ID for cross-account networking"

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-transit-gateway-id"
    Purpose     = "cross-account-networking"
    NetworkType = "transit-gateway"
  })
}

resource "aws_ssm_parameter" "transit_gateway_route_table_id" {
  name  = "/${var.name_prefix}/shared-networking/transit-gateway-route-table-id"
  type  = "String"
  value = var.transit_gateway_route_table_id

  description = "Transit Gateway Route Table ID for cross-account networking"

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-transit-gateway-route-table-id"
    Purpose     = "cross-account-networking"
    NetworkType = "transit-gateway"
  })
}

# ==============================================================================
# SHARED SERVICES VPC SUBNETS AND ROUTING
# ==============================================================================

resource "aws_ssm_parameter" "shared_services_public_subnets" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-public-subnets"
  type  = "StringList"
  value = join(",", var.shared_services_public_subnets)

  description = "Shared Services VPC public subnet IDs for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-public-subnets"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

resource "aws_ssm_parameter" "shared_services_private_subnets" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-private-subnets"
  type  = "StringList"
  value = join(",", var.shared_services_private_subnets)

  description = "Shared Services VPC private subnet IDs for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-private-subnets"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

resource "aws_ssm_parameter" "shared_services_public_route_table_ids" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-public-route-tables"
  type  = "StringList"
  value = join(",", var.shared_services_public_route_table_ids)

  description = "Shared Services VPC public route table IDs for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-public-route-tables"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

resource "aws_ssm_parameter" "shared_services_private_route_table_ids" {
  name  = "/${var.name_prefix}/shared-networking/shared-services-private-route-tables"
  type  = "StringList"
  value = join(",", var.shared_services_private_route_table_ids)

  description = "Shared Services VPC private route table IDs for cross-account networking"

  tags = merge(var.tags, {
    Name    = "${var.name_prefix}-shared-services-private-route-tables"
    Purpose = "cross-account-networking"
    VPCType = "shared-services"
  })
}

# Cross-account IAM roles for accessing shared networking resources
resource "aws_iam_role" "cross_account_networking" {
  for_each = var.shared_accounts

  name = "${var.name_prefix}-cross-acct-net-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${each.value.account_id}:role/${each.value.role_name}"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "${var.name_prefix}-${each.key}-networking"
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-cross-acct-net-${each.key}"
    Purpose     = "cross-account-networking"
    PeerAccount = each.value.account_id
  })
}

# IAM policy for cross-account networking access
resource "aws_iam_policy" "cross_account_networking" {
  name        = "${var.name_prefix}-cross-acct-net-policy"
  description = "Policy for cross-account networking access to shared networking resources (AWS IA Hub-and-Spoke)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = [
          "arn:aws:ssm:*:*:parameter/${var.name_prefix}/shared-networking/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeRouteTables",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNatGateways",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeTransitGateways",
          "ec2:DescribeTransitGatewayAttachments",
          "ec2:DescribeTransitGatewayRouteTables",
          "ec2:DescribeTransitGatewayVpcAttachments"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:Region" = data.aws_region.current.id
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTransitGatewayVpcAttachment",
          "ec2:DeleteTransitGatewayVpcAttachment",
          "ec2:ModifyTransitGatewayVpcAttachment",
          "ec2:AcceptTransitGatewayVpcAttachment",
          "ec2:RejectTransitGatewayVpcAttachment"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:Region" = data.aws_region.current.id
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Attach policy to cross-account roles
resource "aws_iam_role_policy_attachment" "cross_account_networking" {
  for_each = aws_iam_role.cross_account_networking

  role       = each.value.name
  policy_arn = aws_iam_policy.cross_account_networking.arn
}

# Data source for current region
data "aws_region" "current" {}

# Store cross-account role ARNs for reference
resource "aws_ssm_parameter" "cross_account_role_arns" {
  for_each = aws_iam_role.cross_account_networking

  name  = "/${var.name_prefix}/shared-networking/cross-account-role-${each.key}"
  type  = "String"
  value = each.value.arn

  description = "Cross-account role ARN for ${each.key} networking access"

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-cross-account-role-${each.key}"
    Purpose     = "cross-account-networking"
    PeerAccount = var.shared_accounts[each.key].account_id
  })
}
