# AWS Terraform State Backend Module

This module provisions an S3 bucket to store `terraform.tfstate` file and uses S3 lockfile functionality for state locking to prevent concurrent modifications and state corruption.

## Features

1. **S3 Bucket for State Storage**
   - Forced server-side encryption at rest
   - Versioning enabled for state recovery
   - Public access blocked by default
   - Configurable bucket policies

2. **S3 Lockfile for State Locking**
   - Modern Terraform locking mechanism using S3 lockfile
   - No additional AWS services required
   - Improved reliability and performance

3. **Cross-Account Access Support**
   - Configurable S3 bucket policies via `source_policy_documents`
   - Support for external policy documents

4. **S3 Replication (Optional)**
   - Cross-region replication for disaster recovery
   - Configurable replication settings

## Usage

### Basic Example

```hcl
module "terraform_state_backend" {
  source = "./modules/aws/aws-tfstate-backend"

  # Naming configuration
  namespace  = "my-org"
  name       = "terraform"
  attributes = ["state"]

  # Backend configuration
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false

  tags = {
    Environment = "prod"
    Project     = "infrastructure"
  }
}
```

### Backend Usage

After creating the module, configure your backend with:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-org-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
```

> [!NOTE]
> The `use_lockfile = true` setting enables S3-based locking instead of DynamoDB.

### With Cross-Account Access

```hcl
data "aws_iam_policy_document" "cross_account_policy" {
  statement {
    sid    = "AllowCrossAccountAccess"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:role/terraform-execution-role",
        "arn:aws:iam::234567890123:role/terraform-execution-role",
      ]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::my-terraform-state-bucket",
      "arn:aws:s3:::my-terraform-state-bucket/*"
    ]
  }
}

module "terraform_state_backend" {
  source = "./modules/aws/aws-tfstate-backend"

  namespace  = "my-org"
  name       = "terraform"
  attributes = ["state"]

  # Cross-account policy
  source_policy_documents = [
    data.aws_iam_policy_document.cross_account_policy.json
  ]

  tags = {
    Environment = "prod"
    Project     = "infrastructure"
  }
}
```

## Module Documentation

The module documentation is generated with [terraform-docs](https://github.com/terraform-docs/terraform-docs)
by running `terraform-docs md . > ./docs/MODULE.md` from the module directory.

You can also view the latest version of the module documentation in the [MODULE.md](./docs/MODULE.md) file.
