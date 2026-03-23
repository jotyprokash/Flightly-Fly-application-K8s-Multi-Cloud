#!/bin/bash
set -e

CLUSTER_NAME=$1
REGION=$2
FRONTEND_ECR=$3
BACKEND_ECR=$4
DB_ENDPOINT=$5
DB_USER=${DB_USER:-flightlyadmin}
DB_PASSWORD=${DB_PASSWORD:-SecureFlightlyPassword123!}

echo "🚀 [1/7] Authenticating Docker with AWS ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $(echo $FRONTEND_ECR | cut -d'/' -f1)

export REGISTRY_URL=$(echo $FRONTEND_ECR | cut -d'/' -f1)

echo "🏗️ [2/7] Building and Pushing Backend Docker Image..."
cd ../backend
docker build -t flightly-backend .
docker tag flightly-backend:latest $BACKEND_ECR:latest
docker push $BACKEND_ECR:latest

echo "🏗️ [3/7] Building and Pushing Frontend Docker Image..."
cd ../frontend
docker build -t flightly-frontend .
docker tag flightly-frontend:latest $FRONTEND_ECR:latest
docker push $FRONTEND_ECR:latest
cd ../terraform

echo "🔐 [4/7] Updating local Kubeconfig..."
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

echo "🔑 [5/7] Re-seeding DocumentDB Credentials safely into EKS..."
kubectl create secret generic flightly-db-secret \
  --from-literal=MONGO_URI="mongodb://${DB_USER}:${DB_PASSWORD}@${DB_ENDPOINT}:27017/?tls=false&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "⚖️ [6/7] Installing AWS Load Balancer Controller (Ingress requirement)..."
eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve --region $REGION

eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRolePoC3" \
  --attach-policy-arn=arn:aws:iam::434562741459:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve --override-existing-serviceaccounts --region $REGION || true

helm repo add eks https://aws.github.io/eks-charts
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=$REGION \
  --set vpcId=$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION --query "cluster.resourcesVpcConfig.vpcId" --output text)

echo "⏳ Waiting for ALB Controller pods to be ready..."
kubectl rollout status deployment aws-load-balancer-controller -n kube-system --timeout=120s

echo "🎯 [7/7] Applying application via Kustomize Overlays..."
cd ../
kubectl apply -k k8s/overlays/production

echo "✅ Deployment Process Finished! The Load Balancer and Domain are waking up..."
