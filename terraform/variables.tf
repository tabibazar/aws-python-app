variable "app_name"    { type = string  default = "flask-app" }
variable "app_image"   { type = string } # e.g., 5027....amazonaws.com/aws_python_app:latest
variable "svc_port"    { type = number  default = 80 }
variable "app_port"    { type = number  default = 8000 }
variable "replicas"    { type = number  default = 2 }
variable "namespace"   { type = string  default = "default" }
variable "region"      { type = string  default = "ca-central-1" }
variable "cluster_name"{ type = string  default = "curious-rock-crab" }
variable "ecr_name"    { type = string  default = "aws_python_app" } # existing repo name