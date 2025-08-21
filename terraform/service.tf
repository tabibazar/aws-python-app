resource "kubernetes_service_v1" "flask_app" {
  count = var.enable_legacy_manifests ? 1 : 0
  metadata {
    name = "flask-app"
    labels = {
      app = "flask-app"
    }
    annotations = {
      # Use an internet-facing Network Load Balancer on AWS/EKS
      "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  # Do not block terraform apply waiting for external LB; it can be slow on some clusters
  wait_for_load_balancer = false

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