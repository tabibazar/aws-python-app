data "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket."
  value       = data.aws_s3_bucket.state.arn
}
