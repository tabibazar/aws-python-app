resource "kubernetes_service_v1" "flask_app" {
  count = var.enable_legacy_manifests ? 1 : 0
  metadata {
    name = "flask-app"
    labels = {
      app = "flask-app"
    }
  }

  wait_for_load_balancer = true

  spec {
    selector = {
      app = "flask-app"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8000
    }

    type = "LoadBalancer"
  }
}