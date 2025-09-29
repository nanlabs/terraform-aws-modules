# AWS Data Lake Infrastructure Module
# Creates S3 buckets and directory structure for medallion architecture with Apache Iceberg support

resource "aws_s3_bucket" "storage" {
  bucket = "${var.name}-storage"

  tags = merge(var.tags, {
    Name      = "${var.name}-storage"
    Purpose   = "Data Lake Storage"
    Component = "Storage"
    DataTier  = "All"
  })
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "storage" {
  bucket = aws_s3_bucket.storage.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# S3 bucket server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
    }
    bucket_key_enabled = var.kms_key_arn != null ? true : false
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforce TLS-only access to the storage bucket
resource "aws_s3_bucket_policy" "storage_tls_only" {
  bucket = aws_s3_bucket.storage.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          aws_s3_bucket.storage.arn,
          "${aws_s3_bucket.storage.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# S3 bucket lifecycle configuration for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "storage" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.storage.id

  # Raw zone - transition to IA after 30 days, Glacier after 60 days (cost optimization for raw files)
  rule {
    id     = "raw_zone_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.data_lake_layers.raw_zone}/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }

  # Bronze layer - transition to IA after 30 days, Glacier after 90 days
  rule {
    id     = "bronze_layer_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.data_lake_layers.bronze}/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
  }

  # Silver layer - transition to IA after 60 days
  rule {
    id     = "silver_layer_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.data_lake_layers.silver}/"
    }

    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }
  }

  # Gold layer - keep in Standard for faster access
  rule {
    id     = "gold_layer_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.data_lake_layers.gold}/"
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }

  # Export layer - delete after retention period
  rule {
    id     = "export_layer_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.data_lake_layers.export}/"
    }

    expiration {
      days = var.export_retention_days
    }
  }

  # Spark event logs - delete after retention period
  rule {
    id     = "spark_logs_lifecycle"
    status = "Enabled"

    filter {
      prefix = "${var.spark_event_logs_path}/"
    }

    expiration {
      days = var.spark_logs_retention_days
    }
  }
}

# Optional: Separate bucket for temporary/working data
resource "aws_s3_bucket" "temp" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = "${var.name}-temp"

  tags = merge(var.tags, {
    Name      = "${var.name}-temp"
    Purpose   = "Temporary Data Storage"
    Component = "Storage"
    DataTier  = "Temporary"
  })
}

resource "aws_s3_bucket_versioning" "temp" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = aws_s3_bucket.temp[0].id
  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "temp" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = aws_s3_bucket.temp[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
    }
    bucket_key_enabled = var.kms_key_arn != null ? true : false
  }
}

resource "aws_s3_bucket_public_access_block" "temp" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = aws_s3_bucket.temp[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforce TLS-only access to the temp bucket (used for Athena results)
locals {
  temp_bucket_base_policy_statements = [
    {
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        aws_s3_bucket.temp[0].arn,
        "${aws_s3_bucket.temp[0].arn}/*"
      ]
      Condition = {
        Bool = {
          "aws:SecureTransport" = "false"
        }
      }
    }
  ]

  temp_bucket_quicksight_statement = var.quicksight_role_arn != null ? [{
    Sid    = "AllowQuickSightAccess"
    Effect = "Allow"
    Principal = {
      AWS = var.quicksight_role_arn
    }
    Action = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    Resource = [
      aws_s3_bucket.temp[0].arn,
      "${aws_s3_bucket.temp[0].arn}/*"
    ]
  }] : []
}

resource "aws_s3_bucket_policy" "temp_tls_only" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = aws_s3_bucket.temp[0].id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = concat(local.temp_bucket_base_policy_statements, local.temp_bucket_quicksight_statement)
  })
}

# Lifecycle rule for temp bucket - auto-delete after 7 days
resource "aws_s3_bucket_lifecycle_configuration" "temp" {
  count  = var.create_temp_bucket ? 1 : 0
  bucket = aws_s3_bucket.temp[0].id

  rule {
    id     = "temp_auto_cleanup"
    status = "Enabled"

    filter {}

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}
