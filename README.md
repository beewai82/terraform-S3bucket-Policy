# S3 Bucket Policy Terraform Module

This module creates an AWS S3 bucket with a security-focused IAM policy that enforces multiple security controls.

## Security Features

- **Encrypted Transport Only**: Denies all S3 operations over unencrypted connections (non-HTTPS)
- **Network Isolation**: Restricts access to specific IP ranges (10.0.0.0/8, 192.168.0.0/16) or VPC endpoints
- **IAM Role Whitelist**: Allows only specific IAM roles from the AWS account
- **Service Access**: Permits AWS S3 logging service to write logs

## Usage

```hcl
module "s3_bucket_policy" {
  source = "github.com/beewai82/terraform-S3bucket-Policy"

  bucket_name = "my-secure-bucket"
  account_id  = "123456789012"
  vpce_id     = "vpce-1234567890abcdef0"
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| bucket_name | Name of the S3 bucket | `string` | yes |
| account_id | AWS Account ID | `string` | yes |
| vpce_id | VPC Endpoint ID for S3 access | `string` | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the S3 bucket |
| bucket_policy | The S3 bucket policy JSON |

## Requirements

- Terraform >= 1.0
- AWS Provider >= 3.0

## Policy Statements

### DenyUnencryptedTransport
Denies all S3 operations that don't use HTTPS (aws:SecureTransport = false).
This ensures all traffic to the bucket is encrypted in transit.

### DenyAccessOutsideCorpNetworkOrVPCE
Denies access from sources outside of:
- Corporate IP ranges (10.0.0.0/8, 192.168.0.0/16)
- Specified VPC endpoint
- IAM roles within the AWS account
- AWS services accessing via VPC endpoints

### AllowS3LoggingWrite
Allows AWS S3 logging service to write objects for bucket logging.
Limited to the source AWS account to prevent cross-account access.

## Example

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "secure_bucket" {
  source = "github.com/beewai82/terraform-S3bucket-Policy"

  bucket_name = "my-company-data-bucket"
  account_id  = "123456789012"
  vpce_id     = "vpce-0123456789abcdef0"
}

output "bucket_name" {
  value = module.secure_bucket.bucket_id
}
```

## Security Considerations

- **IP Ranges**: Update the IP ranges in `s3_policy.tf` to match your organization's network
- **VPCE**: Ensure the VPC endpoint ID is correct for your environment
- **IAM Roles**: Only roles matching the pattern `arn:aws:iam::ACCOUNT_ID:role/*` can access the bucket
- **Logging**: S3 logging service is explicitly allowed for CloudTrail and access logging

## License

MIT
