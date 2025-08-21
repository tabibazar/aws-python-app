variable "app_name" {
  description = "Name of the Kubernetes app"
  type        = string
  default     = "flask-app"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
  default     = "default"
}

variable "replicas" {
  description = "Number of replicas for the Deployment"
  type        = number
  default     = 2
}

variable "container_image" {
  description = "ECR image for the app"
  type        = string
  default     = "502768277707.dkr.ecr.ca-central-1.amazonaws.com/aws_python_app:latest"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "service_port" {
  description = "Service port exposed by the LoadBalancer"
  type        = number
  default     = 80
}

variable "region" {
  description = "AWS region where resources are deployed"
  type        = string
  default     = "ca-central-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "curious-rock-crab"
}