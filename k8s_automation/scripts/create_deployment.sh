#!/bin/bash

# Validate arguments
if [ "$#" -ne 10 ]; then
  echo "Usage: $0 <namespace> <deployment_name> <image> <cpu_request> <cpu_limit> <memory_request> <memory_limit> <port> <cpu_target> <memory_target>"
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
MEMORY_TARGET=${10}

# Create the namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Create the Deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $DEPLOYMENT_NAME
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $DEPLOYMENT_NAME
  template:
    metadata:
      labels:
        app: $DEPLOYMENT_NAME
    spec:
      containers:
      - name: $DEPLOYMENT_NAME
        image: $IMAGE
        resources:
          requests:
            cpu: $CPU_REQUEST
            memory: $MEMORY_REQUEST
          limits:
            cpu: $CPU_LIMIT
            memory: $MEMORY_LIMIT
        ports:
        - containerPort: $PORT
EOF

# Expose the Deployment as a Service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: $DEPLOYMENT_NAME-service
  namespace: $NAMESPACE
spec:
  selector:
    app: $DEPLOYMENT_NAME
  ports:
  - protocol: TCP
    port: $PORT
    targetPort: $PORT
  type: NodePort
EOF

# Create Horizontal Pod Autoscaler
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: $DEPLOYMENT_NAME-hpa
  namespace: $NAMESPACE
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: $DEPLOYMENT_NAME
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: $CPU_TARGET
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: $MEMORY_TARGET
EOF

echo "Deployment, Service, and HPA created in namespace: $NAMESPACE"
