locals {
  deploy_ns = (var.enable_k8s && var.namespace != "default") ? kubernetes_namespace_v1.ns[0].metadata[0].name : var.namespace
}

resource "kubernetes_namespace_v1" "ns" {
  count    = (var.enable_k8s && var.namespace != "default") ? 1 : 0
  metadata { name = var.namespace }
}

resource "kubernetes_deployment_v1" "app" {
  count = var.enable_k8s ? 1 : 0
  metadata {
    name      = var.app_name
    namespace = local.deploy_ns
    labels    = { app = var.app_name }
  }

  spec {
    replicas = var.replicas
    selector { match_labels = { app = var.app_name } }

    template {
      metadata { labels = { app = var.app_name } }

      spec {
        container {
          name  = var.app_name
          image = var.image

          port { container_port = var.container_port }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = var.container_port
            }
            initial_delay_seconds = 30
            period_seconds        = 20
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = var.container_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 1
          }

          resources {
            requests = { cpu = "100m", memory = "128Mi" }
            limits   = { cpu = "500m", memory = "512Mi" }
          }

          env {
            name  = "FLASK_ENV"
            value = "production"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "svc" {
  count = var.enable_k8s ? 1 : 0
  metadata {
    name      = var.app_name
    namespace = local.deploy_ns
    labels    = { app = var.app_name }
    annotations = {
      # Use an internet-facing Network Load Balancer on AWS/EKS
      "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  # Do not block terraform apply waiting for external LB; it can be slow on some clusters
  wait_for_load_balancer = false

  timeouts {
    create = "20m"
  }

  spec {
    selector = { app = var.app_name }
    port {
      port        = var.service_port
      target_port = var.container_port
    }
    type = "LoadBalancer"
  }
}