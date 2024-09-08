# Kubernetes Automation Scripts


## Overview

This project contains a set of shell scripts to automate operations on a bare Kubernetes cluster, including:
- Cluster initialization
- Deployment creation using a YAML template
- Health status retrieval

## Prerequisites

- Kubernetes installed on the master and worker nodes
- `kubectl` configured on the master node
- Docker installed on all nodes
- Internet access to download network plugins and Docker images

## Setup Instructions

1. **Deploy a Bare Kubernetes Cluster**

   This section contains instructions on how to spin up a bare kubernetes cluster
   
   - Spin up 3 Ubuntu VMs (I used AWS EC2. Master node requires min 2 CPU codes and 1700 MB, so deploy it on t2.medium. Worked nodes can run on t2.micro)

   - Run the commands below on all 3 VMs to install docker, kubelet, kubeadm, kubectl

   ```bash
   echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
   sudo apt-get update
   sudo apt-get install -y docker.io
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo apt-get install -y kubelet kubeadm kubectl

2. **Cluster Initialization**

   Run the following command on the master node to initialize the Kubernetes cluster:

   ```bash
   sudo ./scripts/cluster_init.sh

3. **Create a Deployment**

   Run the following command on the master node to create the deployment

   ```bash
   sudo ./scripts/create_deployment.sh test-namespace test-deployment nginx:latest 100m 500m 128Mi 512Mi 80 50

4. **Get Health Status for a given deployment**

   Run the following command on the master node to get the health status for a given deployment

   ```bash
   sudo ./scripts/get_health_status.sh test-namespace test-deployment
