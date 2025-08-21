terraform {
  backend "s3" {
    bucket = "502768277707-terraform-state-bucket"
    key    = "state/terraform.tfstate" # no s3:// here
    region = "ca-central-1"
    # Optional locking approaches:
    # dynamodb_table = "tf-locks"
    use_lockfile = true
  }
}