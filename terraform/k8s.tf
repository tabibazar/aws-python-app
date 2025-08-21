resource "kubernetes_namespace_v1" "ns" {
  metadata { name = var.namespace }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.ns.metadata[0].name
    labels    = { app = var.app_name }
  }

  spec {
    replicas = 2
    selector { match_labels = { app = var.app_name } }

    template {
      metadata { labels = { app = var.app_name } }

      spec {
        container {
          name  = var.app_name
          image = var.image

          port { container_port = var.container_port }

          liveness_probe {
            http_get { path = "/healthz" port = var.container_port }
            initial_delay_seconds = 30
            period_seconds        = 20
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get { path = "/healthz" port = var.container_port }
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
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.ns.metadata[0].name
    labels    = { app = var.app_name }
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