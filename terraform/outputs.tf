output "service_hostname" {
  # Return an empty string if hostname not available yet (keeps `terraform output -raw` happy)
  value       = try(kubernetes_service_v1.svc.status[0].load_balancer[0].ingress[0].hostname, "")
  description = "External hostname of the Service (if provisioned)."
}

output "service_ip" {
  # Prefer external LB IP, fallback to cluster IP, else empty string
  value       = try(kubernetes_service_v1.svc.status[0].load_balancer[0].ingress[0].ip, try(kubernetes_service_v1.svc.spec[0].cluster_ip, ""))
  description = "External IP of the Service (if provisioned)."
}