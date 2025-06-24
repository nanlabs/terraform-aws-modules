# AWS IAM Role Module

Terraform module that creates flexible IAM roles with custom trust policies, inline policies, and managed policy attachments. This is a **custom implementation** designed for complex IAM scenarios.

## Key Features

This custom module provides advanced IAM role capabilities:

- **🔐 Flexible Trust Policies**: Support for multiple principal types (AWS accounts, services, federated identities) with custom conditions
- **📋 Multiple Policy Types**: Supports both inline policies and managed policy attachments
- **🔧 Advanced Configuration**: Custom session duration, permissions boundary, and path configuration
- **⚙️ Condition Support**: Dynamic conditions for enhanced security (MFA, source IP, time-based access)
- **🏷️ Consistent Tagging**: Standardized tag structure with automatic name tagging

## Usage

This example creates a role with the name eg-prod-app with permission to grant read-write access to S3 bucket, and gives permission to the entities specified in principals_arns to assume the role.

```hcl
data "aws_iam_policy_document" "resource_full_access" {
  statement {
    sid       = "FullAccess"
    effect    = "Allow"
    resources = ["arn:aws:s3:::bucketname/path/*"]

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
  }
}

data "aws_iam_policy_document" "base" {
  statement {
    sid = "BaseAccess"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]

    resources = ["arn:aws:s3:::bucketname"]
    effect    = "Allow"
  }
}

module "role" {
  source = "../../modules/aws-iam-role"

  name      = "eg-prod-app"

  policy_description = "Allow S3 FullAccess"
  role_description   = "IAM role with permissions to perform actions on S3 resources"

  principals = {
    AWS = ["arn:aws:iam::123456789012:role/workers"]
  }

  policy_documents = [
    data.aws_iam_policy_document.resource_full_access.json,
    data.aws_iam_policy_document.base.json
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Module Documentation

The complete module documentation with detailed inputs and outputs is auto-generated using [terraform-docs](https://github.com/terraform-docs/terraform-docs) and available in the [module documentation](./docs/MODULE.md).
