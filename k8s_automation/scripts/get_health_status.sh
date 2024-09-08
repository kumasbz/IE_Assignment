#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <namespace> <deployment_name>"
  exit 1
fi

NAMESPACE=$1
DEPLOYMENT_NAME=$2

# Check deployment status
kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.conditions[*].status}' | grep -q True
if [ $? -eq 0 ]; then
  echo "[INFO] Deployment $DEPLOYMENT_NAME in namespace $NAMESPACE is healthy."
else
  echo "[ERROR] Deployment $DEPLOYMENT_NAME in namespace $NAMESPACE is not healthy."
fi