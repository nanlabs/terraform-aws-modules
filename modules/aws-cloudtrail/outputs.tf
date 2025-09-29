output "cloudtrail_arn" {
  description = "The Amazon Resource Name of the trail"
  value       = aws_cloudtrail.trail.arn
}

output "cloudtrail_id" {
  description = "The name of the trail"
  value       = aws_cloudtrail.trail.id
}

output "cloudtrail_home_region" {
  description = "The region in which the trail was created"
  value       = aws_cloudtrail.trail.home_region
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for CloudTrail logs"
  value       = local.bucket_name
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket for CloudTrail logs"
  value       = local.bucket_arn
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Logs group"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch Logs group"
  value       = aws_cloudwatch_log_group.cloudtrail.arn
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for CloudTrail"
  value       = aws_iam_role.cloudtrail_logs.arn
}

output "iam_role_name" {
  description = "The name of the IAM role for CloudTrail"
  value       = aws_iam_role.cloudtrail_logs.name
}
