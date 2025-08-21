resource "kubernetes_service_v1" "flask_app" {
  metadata {
    name = "flask-app"
    labels = {
      app = "flask-app"
    }
  }

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