#!/bin/bash

set -e

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Initialize Kubernetes master node
echo "[INFO] Initializing Kubernetes cluster using kubeadm..."
kubeadm init --pod-network-cidr=10.244.0.0/16

# Setup kubectl for non-root user
echo "[INFO] Setting up kubectl for user $USER..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel network plugin
echo "[INFO] Installing Flannel network plugin..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Display join command for worker nodes
echo "[INFO] Cluster initialized. To join worker nodes, run the following command on each worker node:"
kubeadm token create --print-join-command
