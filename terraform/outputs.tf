output "service_hostname" {
  value       = try(kubernetes_service_v1.svc.status[0].load_balancer[0].ingress[0].hostname, null)
  description = "External hostname of the Service (if provisioned)."
}

output "service_ip" {
  value       = try(kubernetes_service_v1.svc.status[0].load_balancer[0].ingress[0].ip, null)
  description = "External IP of the Service (if provisioned)."
}