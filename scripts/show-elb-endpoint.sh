#!/usr/bin/env bash
set -euo pipefail

# Prints the external ELB endpoint (hostname or IP) for the Kubernetes Service.
# It tries Terraform outputs first, then falls back to kubectl.
#
# Usage:
#   scripts/show-elb-endpoint.sh            # auto (terraform -> kubectl)
#   scripts/show-elb-endpoint.sh terraform  # force terraform method
#   scripts/show-elb-endpoint.sh kubectl    # force kubectl method
#
# Environment overrides for kubectl mode:
#   NAMESPACE (default: "default")
#   APP_NAME  (default: "flask-app")
#
# Requirements:
#   - For terraform mode: terraform installed and terraform/ initialized, with outputs service_hostname/service_ip
#   - For kubectl mode: kubectl configured to talk to the cluster with access to the namespace/service

MODE="${1:-auto}"

# Helper to print and exit when we have an endpoint
print_endpoint() {
  local ep="$1"
  if [[ -n "$ep" ]]; then
    echo "$ep"
    exit 0
  fi
}

# Try using Terraform outputs
from_terraform() {
  if ! command -v terraform >/dev/null 2>&1; then
    return 1
  fi
  local tfdir="terraform"
  if [[ ! -d "$tfdir" ]]; then
    return 1
  fi

  # Capture without failing the whole script
  local host
  host=$(terraform -chdir="$tfdir" output -raw service_hostname 2>/dev/null || true)
  if [[ -n "${host}" ]]; then
    print_endpoint "$host"
  fi

  local ip
  ip=$(terraform -chdir="$tfdir" output -raw service_ip 2>/dev/null || true)
  if [[ -n "${ip}" ]]; then
    print_endpoint "$ip"
  fi

  return 1
}

# Try using kubectl
from_kubectl() {
  if ! command -v kubectl >/dev/null 2>&1; then
    return 1
  fi
  local namespace="${NAMESPACE:-default}"
  local app_name="${APP_NAME:-flask-app}"

  # Try hostname first
  local host
  host=$(kubectl -n "$namespace" get svc "$app_name" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
  if [[ -n "${host}" ]]; then
    print_endpoint "$host"
  fi

  # Fallback to IP
  local ip
  ip=$(kubectl -n "$namespace" get svc "$app_name" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
  if [[ -n "${ip}" ]]; then
    print_endpoint "$ip"
  fi

  return 1
}

case "$MODE" in
  terraform)
    from_terraform || { echo "ERROR: Could not retrieve endpoint via Terraform." >&2; exit 1; } ;;
  kubectl)
    from_kubectl || { echo "ERROR: Could not retrieve endpoint via kubectl." >&2; exit 1; } ;;
  auto|*)
    from_terraform || from_kubectl || { echo "ERROR: Could not determine ELB endpoint (neither Terraform outputs nor kubectl succeeded)." >&2; exit 1; } ;;
 esac
