#!/bin/bash
set -e

echo "Installing Harbor via Helm..."
# Ensure helm is installed
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
bash get_helm.sh

helm repo add harbor https://helm.goharbor.io
helm repo update

kubectl create namespace harbor
helm install harbor harbor/harbor \
  --namespace harbor \
  --set expose.type=nodePort \
  --set expose.tls.enabled=false \
  --set externalURL=http://localhost:30002 \
  --set persistence.persistentVolumeClaim.registry.size=10Gi

echo "Harbor installation initiated."
