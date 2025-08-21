output "service_hostname" {
  # Support both primary (k8s.tf) and legacy (service.tf) service resources
  # Return an empty string if hostname not available yet (keeps `terraform output -raw` happy)
  value = try(
    kubernetes_service_v1.svc[0].status[0].load_balancer[0].ingress[0].hostname,
    kubernetes_service_v1.flask_app[0].status[0].load_balancer[0].ingress[0].hostname,
    ""
  )
  description = "External hostname of the Service (if provisioned)."
}

output "service_ip" {
  # Prefer external LB IP, fallback to cluster IP, else empty string.
  # Support both primary (k8s.tf) and legacy (service.tf) resources.
  value = try(
    kubernetes_service_v1.svc[0].status[0].load_balancer[0].ingress[0].ip,
    kubernetes_service_v1.flask_app[0].status[0].load_balancer[0].ingress[0].ip,
    kubernetes_service_v1.svc[0].spec[0].cluster_ip,
    kubernetes_service_v1.flask_app[0].spec[0].cluster_ip,
    ""
  )
  description = "External IP of the Service (if provisioned)."
}