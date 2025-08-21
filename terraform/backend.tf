terraform {
  backend "s3" {
    bucket = "502768277707-terraform-state-bucket"
    key    = "state/terraform.tfstate" # no s3:// here
    region = "ca-central-1"
    # Recommended: use a DynamoDB table for reliable state locking across builds.
    # You can pass it at init time via: -backend-config="dynamodb_table=<your-table>"
  }
}