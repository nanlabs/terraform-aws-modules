output "configuration_recorder_name" {
  description = "The name of the configuration recorder"
  value       = aws_config_configuration_recorder.recorder.name
}

output "delivery_channel_name" {
  description = "The name of the delivery channel"
  value       = aws_config_delivery_channel.channel.name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.config.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.config.arn
}

output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.config.arn
}
