# Imports disabled: importing non-existent remote objects causes failures on fresh environments.
# The buildspec performs a pre-cleanup (kubectl delete) to avoid "already exists" errors, so
# we avoid using Terraform import blocks here. If you need to adopt pre-existing resources
# into state, run `terraform import` manually or create a temporary imports file explicitly.
