variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "vpce_id" {
  description = "VPC Endpoint ID for S3 access"
  type        = string
}
