#!/bin/bash

# Define variables
CLUSTER_NAME="muchtodo-cluster"
IMAGE_NAME="container-assessment-backend:latest"

# Move to the root directory (container-assessment/) to access all files
cd "$(dirname "$0")/.." || exit

echo "Starting Deployment..."

# 1. Create Kind cluster if it does not exist
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "Creating Kind cluster..."
  kind create cluster --name "$CLUSTER_NAME"
fi

# 2. Build and Load Image
echo "Building Docker image from root..."
docker build -t "$IMAGE_NAME" .

echo "Loading image into Kind..."
kind load docker-image "$IMAGE_NAME" --name "$CLUSTER_NAME"

# 3. Apply Manifests using relative paths from root
echo "Applying Kubernetes manifests..."
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for pods to be ready..."
kubectl wait --namespace muchtodo-ns --for=condition=ready pod --selector=app=mongodb --timeout=90s
kubectl wait --namespace muchtodo-ns --for=condition=ready pod --selector=app=backend-api --timeout=90s

echo "Deployment Complete!"
kubectl get pods -n muchtodo-ns