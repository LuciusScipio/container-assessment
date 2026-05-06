#!/bin/bash

# Move to the root directory (container-assessment/)
cd "$(dirname "$0")/.." || exit

echo "Cleaning up Kubernetes resources..."

# Delete by directory using relative paths from root
kubectl delete -f kubernetes/ingress.yaml --ignore-not-found
kubectl delete -f kubernetes/backend/ --ignore-not-found
kubectl delete -f kubernetes/mongodb/ --ignore-not-found
kubectl delete -f kubernetes/namespace.yaml --ignore-not-found



echo "Deleting the Kind cluster..."
kind delete cluster --name muchtodo-cluster

echo "Cleanup complete!"