#!/usr/bin/env bash
# List pods with most restarts across all namespaces
set -euo pipefail

kubectl get pods --all-namespaces -o json | jq -r '
  .items[] |
  {ns: .metadata.namespace, name: .metadata.name, restarts: ([.status.containerStatuses[]? | .restartCount] | add // 0)} |
  select(.restarts > 0) |
  "\(.restarts)\t\(.ns)\t\(.name)"
' | sort -rn
