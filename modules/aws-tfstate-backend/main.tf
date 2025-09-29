locals {
  enabled = var.enabled != null ? var.enabled : true

  bucket_enabled = local.enabled && var.bucket_enabled

  # Simple naming convention compatible with CloudPosse
  id_parts = compact([
    var.namespace,
    var.environment,
    var.stage,
    var.name,
  ])
  id_with_attributes = compact(concat(local.id_parts, var.attributes))
  id                 = join(coalesce(var.delimiter, "-"), local.id_with_attributes)

  # Bucket naming
  bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : local.id

  prevent_unencrypted_uploads = local.enabled && var.prevent_unencrypted_uploads

  policy = one(data.aws_iam_policy_document.aggregated_policy[*].json)

  terraform_backend_config_file = format(
    "%s/%s",
    var.terraform_backend_config_file_path,
    var.terraform_backend_config_file_name
  )

  terraform_backend_config_template_file = var.terraform_backend_config_template_file != "" ? var.terraform_backend_config_template_file : "${path.module}/templates/terraform.tf.tpl"

  terraform_backend_config_content = templatefile(local.terraform_backend_config_template_file, {
    region = data.aws_region.current.id
    # Template file inputs cannot be null, so we use empty string if the variable is null
    bucket = try(aws_s3_bucket.default[0].id, "")

    encrypt              = "true"
    use_lockfile         = "true"
    role_arn             = var.role_arn == null ? "" : var.role_arn
    profile              = var.profile == null ? "" : var.profile
    terraform_version    = var.terraform_version == null ? "" : var.terraform_version
    terraform_state_file = var.terraform_state_file == null ? "" : var.terraform_state_file
    namespace            = var.namespace == null ? "" : var.namespace
    stage                = var.stage == null ? "" : var.stage
    environment          = var.environment == null ? "" : var.environment
    name                 = var.name == null ? "" : var.name
  })

  # Tags
  tags = merge(
    var.tags,
    var.additional_tag_map,
    {
      "Name"       = local.id
      "Attributes" = join(coalesce(var.delimiter, "-"), var.attributes)
    }
  )
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "aggregated_policy" {
  count = local.enabled ? 1 : 0

  source_policy_documents   = [one(data.aws_iam_policy_document.bucket_policy[*].json)]
  override_policy_documents = var.source_policy_documents
}

data "aws_iam_policy_document" "bucket_policy" {
  count = local.enabled ? 1 : 0

  dynamic "statement" {
    for_each = local.prevent_unencrypted_uploads ? ["true"] : []

    content {
      sid = "DenyIncorrectEncryptionHeader"

      effect = "Deny"

      principals {
        identifiers = ["*"]
        type        = "AWS"
      }

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "${var.arn_format}:s3:::${local.bucket_name}/*",
      ]

      condition {
        test     = "StringNotEquals"
        variable = "s3:x-amz-server-side-encryption"

        values = [
          "AES256",
          "aws:kms"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = local.prevent_unencrypted_uploads ? ["true"] : []

    content {
      sid = "DenyUnEncryptedObjectUploads"

      effect = "Deny"

      principals {
        identifiers = ["*"]
        type        = "AWS"
      }

      actions = [
        "s3:PutObject"
      ]

      resources = [
        "${var.arn_format}:s3:::${local.bucket_name}/*",
      ]

      condition {
        test     = "Null"
        variable = "s3:x-amz-server-side-encryption"

        values = [
          "true"
        ]
      }
    }
  }

  statement {
    sid = "EnforceTlsRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "${var.arn_format}:s3:::${local.bucket_name}",
      "${var.arn_format}:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

#S3 access controls, policies and logging are defined as seperate terraform resources below
#tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "default" {
  count = local.bucket_enabled ? 1 : 0

  #bridgecrew:skip=BC_AWS_S3_13:Skipping `Enable S3 Bucket Logging` check until Bridgecrew will support dynamic blocks (https://github.com/bridgecrewio/checkov/issues/776).
  #bridgecrew:skip=CKV_AWS_52:Skipping `Ensure S3 bucket has MFA delete enabled` check due to issues operating with `mfa_delete` in terraform
  bucket        = substr(local.bucket_name, 0, 63)
  force_destroy = var.force_destroy

  tags = local.tags
}

resource "aws_s3_bucket_policy" "default" {
  count = local.bucket_enabled ? 1 : 0

  bucket     = one(aws_s3_bucket.default[*].id)
  policy     = local.policy
  depends_on = [aws_s3_bucket_public_access_block.default]
}

resource "aws_s3_bucket_acl" "default" {
  count = local.bucket_enabled && !var.bucket_ownership_enforced_enabled ? 1 : 0

  bucket = one(aws_s3_bucket.default[*].id)
  acl    = var.acl

  # Default "bucket ownership controls" for new S3 buckets is "BucketOwnerEnforced", which disables ACLs.
  # So, we need to wait until we change bucket ownership to "BucketOwnerPreferred" before we can set ACLs.
  depends_on = [aws_s3_bucket_ownership_controls.default]
}

resource "aws_s3_bucket_versioning" "default" {
  count = local.bucket_enabled ? 1 : 0

  bucket = one(aws_s3_bucket.default[*].id)

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = var.mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count = local.bucket_enabled ? 1 : 0

  bucket = one(aws_s3_bucket.default[*].id)

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_encryption
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_logging" "default" {
  count = local.bucket_enabled && length(var.logging) > 0 ? 1 : 0

  bucket = one(aws_s3_bucket.default[*].id)

  target_bucket = var.logging[0].target_bucket
  target_prefix = var.logging[0].target_prefix
}

resource "aws_s3_bucket_public_access_block" "default" {
  count = local.bucket_enabled && var.enable_public_access_block ? 1 : 0

  bucket                  = one(aws_s3_bucket.default[*].id)
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

# After you apply the bucket owner enforced setting for Object Ownership, ACLs are disabled for the bucket.
# See https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "default" {
  count  = local.bucket_enabled ? 1 : 0
  bucket = one(aws_s3_bucket.default[*].id)

  rule {
    object_ownership = var.bucket_ownership_enforced_enabled ? "BucketOwnerEnforced" : "BucketOwnerPreferred"
  }
  depends_on = [time_sleep.wait_for_aws_s3_bucket_settings]
}

# Workaround S3 eventual consistency for settings objects
resource "time_sleep" "wait_for_aws_s3_bucket_settings" {
  count = local.enabled ? 1 : 0

  depends_on       = [aws_s3_bucket_public_access_block.default, aws_s3_bucket_policy.default]
  create_duration  = "30s"
  destroy_duration = "30s"
}

resource "local_file" "terraform_backend_config" {
  count           = local.enabled && var.terraform_backend_config_file_path != "" ? 1 : 0
  content         = local.terraform_backend_config_content
  filename        = local.terraform_backend_config_file
  file_permission = "0644"
}
