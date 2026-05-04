#!/bin/bash

echo "Cleaning up Kubernetes resources..."

# 1. Delete application resources from the namespace
kubectl delete -f kubernetes/ingress.yaml --ignore-not-found
kubectl delete -f kubernetes/backend/ --ignore-not-found
kubectl delete -f kubernetes/mongodb/ --ignore-not-found
kubectl delete -f kubernetes/namespace.yaml --ignore-not-found

# 2. Delete the Kind cluster
echo "Deleting the Kind cluster..."
kind delete cluster --name muchtodo-cluster

echo "Cleanup complete!"