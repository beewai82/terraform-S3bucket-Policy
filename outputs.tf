output "bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_policy" {
  description = "The S3 bucket policy"
  value       = aws_s3_bucket_policy.this.policy
}
