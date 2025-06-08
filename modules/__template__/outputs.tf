output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website"
  value       = aws_s3_bucket.this.website_endpoint
}

output "bucket_website_domain" {
  description = "The website domain, if the bucket is configured with a website"
  value       = aws_s3_bucket.this.website_domain
}

output "logging_bucket" {
  description = "The logging bucket for the S3 bucket"
  value       = aws_s3_bucket_logging.bucket_logging.target_bucket
}
