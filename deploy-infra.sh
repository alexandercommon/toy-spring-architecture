#!/bin/bash
set -e

# Define operational variables - CHANGE THESE to match your AWS context
CLUSTER_NAME="toy-eks-cluster"
AWS_REGION="us-east-1" 

echo "========================================================="
echo "STARTING EPHEMERAL AWS EKS PROVISIONING SEQUENCE"
echo "========================================================="

# 1. Verify/Install eksctl utility tool
if ! command -v eksctl &> /dev/null; then
    echo ">>> Installing eksctl utility..."
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
fi

# 2. Provision serverless EKS Cluster on Fargate
echo ">>> Initializing automated EKS control plane and default Fargate Profile..."
eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --fargate \
  --zones "${AWS_REGION}a,${AWS_REGION}b"

# 3. Configure local cluster kubeconfig map handles
echo ">>> Updating cluster credentials context mapping..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"

# 4. Create an extra Fargate profile explicitly for our application namespace
echo ">>> Establishing serverless Fargate application scheduler boundaries..."
eksctl create fargateprofile \
  --cluster "$CLUSTER_NAME" \
  --name "toy-apps-profile" \
  --namespace "toy-apps"

# 5. Inject Kubernetes Application Manifest Blueprints
echo ">>> Committing microservice deployment blueprints..."
kubectl apply -f k8s/common.yaml
kubectl apply -f k8s/order-service.yaml
kubectl apply -f k8s/bid-service.yaml

echo "========================================================="
echo "DEPLOYMENT COMPLETE! RUN 'kubectl get pods -n toy-apps' TO TRACK POD BOOT"
echo "========================================================="
