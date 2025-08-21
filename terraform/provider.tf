terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.32" }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Kubernetes provider will work after you run:
# aws eks update-kubeconfig --name curious-rock-crab --region ca-central-1
provider "kubernetes" {
  config_path = "~/.kube/config"
}