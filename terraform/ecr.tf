data "aws_ecr_repository" "app" {
  name = var.ecr_name
}

output "ecr_repo_url" {
  value = data.aws_ecr_repository.app.repository_url
}