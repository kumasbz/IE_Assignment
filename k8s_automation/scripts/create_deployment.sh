#!/bin/bash

set -e

if [ "$#" -ne 9 ]; then
  echo "Usage: $0 <namespace> <deployment_name> <docker_image> <cpu_request> <cpu_limit> <memory_request> <memory_limit> <port> <cpu_target>"
  exit 1
fi

NAMESPACE=$1
DEPLOYMENT_NAME=$2
IMAGE=$3
CPU_REQUEST=$4
CPU_LIMIT=$5
MEMORY_REQUEST=$6
MEMORY_LIMIT=$7
PORT=$8
CPU_TARGET=$9

TEMPLATE_FILE=./config/deployment_template.yaml

# Check if the template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "[ERROR] Template file not found at $TEMPLATE_FILE"
  exit 1
fi

# Create namespace if it doesn't exist
kubectl get ns $NAMESPACE || kubectl create namespace $NAMESPACE

# Use sed to replace placeholders in the template
cat $TEMPLATE_FILE | sed \
  -e "s|{{DEPLOYMENT_NAME}}|$DEPLOYMENT_NAME|g" \
  -e "s|{{DOCKER_IMAGE}}|$IMAGE|g" \
  -e "s|{{CPU_REQUEST}}|$CPU_REQUEST|g" \
  -e "s|{{CPU_LIMIT}}|$CPU_LIMIT|g" \
  -e "s|{{MEMORY_REQUEST}}|$MEMORY_REQUEST|g" \
  -e "s|{{MEMORY_LIMIT}}|$MEMORY_LIMIT|g" \
  -e "s|{{PORT}}|$PORT|g" \
  -e "s|{{CPU_TARGET}}|$CPU_TARGET|g" | kubectl apply -n $NAMESPACE -f -
