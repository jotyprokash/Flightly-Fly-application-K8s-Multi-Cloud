#!/bin/bash
set -e

echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Patching Argo CD server to use generic ingress/LoadBalancer (or port-forward manually) later"
# Wait for Argo CD to become ready
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

echo "k3s and Argo CD installed."
