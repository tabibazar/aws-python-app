# Attempt to automatically adopt existing Kubernetes resources into Terraform state
# to avoid "already exists" errors on apply when resources were created previously.
# These import blocks use the current namespace and app_name variables.
# Terraform v1.5+ executes these imports before planning resource changes.

import {
  to = kubernetes_deployment_v1.app
  id = "${var.namespace}/${var.app_name}"
}

import {
  to = kubernetes_service_v1.svc
  id = "${var.namespace}/${var.app_name}"
}
