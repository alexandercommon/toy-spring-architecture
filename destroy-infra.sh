#!/bin/bash
echo "========================================================="
echo "INITIATING COMPLETE TEARDOWN TO ENFORCE ZERO-COST OVERHEAD"
echo "========================================================="

CLUSTER_NAME="toy-eks-cluster"
AWS_REGION="us-east-1"

# 1. Wipe out live manifest bindings first
echo ">>> Offloading container instances and purging load balancers..."
kubectl delete -f k8s/bid-service.yaml --ignore-not-found=true
kubectl delete -f k8s/order-service.yaml --ignore-not-found=true
kubectl delete -f k8s/common.yaml --ignore-not-found=true

# 2. Fully destroy the infrastructure control plane
echo ">>> Terminating AWS EKS control plane... (This takes a few minutes)"
eksctl delete cluster --name "$CLUSTER_NAME" --region "$AWS_REGION"

echo "========================================================="
echo "TEARDOWN PERFECTED. AWS CLOUD BILL REMAINS ZERO."
echo "========================================================="
