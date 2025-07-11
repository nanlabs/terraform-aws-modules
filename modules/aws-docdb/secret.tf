# Create a random initial password for the DocumentDB cluster
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

locals {
  # if var.master_password is not set, use the random password
  password      = var.master_password != "" ? var.master_password : random_password.rds_password.result
  username      = var.master_username
  secret_prefix = var.secret_prefix != "" ? var.secret_prefix : "${var.name}/docdb"
}

resource "aws_secretsmanager_secret" "secret" {
  count = var.create_secret ? 1 : 0

  description = "DocumentDB Credentials for ${var.db_name} cluster"
  name        = "${local.secret_prefix}-credentials"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret" {
  count = var.create_secret ? 1 : 0

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
  secret_id = aws_secretsmanager_secret.secret[0].id
  secret_string = jsonencode({
    username = local.username
    password = local.password
  })
}
