#!/bin/bash

# Validate arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <namespace> <deployment_name>"
  exit 1
fi

NAMESPACE=$1
DEPLOYMENT_NAME=$2

# Get Deployment status
echo "Deployment status:"
kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o=jsonpath='{.status.conditions[?(@.type=="Available")].status}'

# Get HPA status
echo "Horizontal Pod Autoscaler status:"
kubectl get hpa $DEPLOYMENT_NAME-hpa -n $NAMESPACE
