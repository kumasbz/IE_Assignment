# Kubernetes Automation Scripts


## Overview

This project contains a set of shell scripts to automate operations on a bare Kubernetes cluster, including:
- Cluster initialization
- Deployment creation
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

2. **Fetch the Automation script**

   Run the follwoing command on the master node to fetch the automation scripts and provide execute permissions
   
   ```bash
   git clone https://github.com/kumasbz/IE_Assignment.git
   cd IE_Assignment/k8s_automation/
   chmod +x ./scripts/*


3. **Cluster Initialization**

   Run the following command on the master node to initialize the Kubernetes cluster:

   ```bash
   sudo ./scripts/cluster_init.sh

4. **Join the Worker nodes to the cluster**

   - Copy the `kubeadm join` command displayed after initiating the cluster in previous step and run it on each of the worker nodes
   - To check if the nodes were successfully attached to the cluster, run the command below

   ```bash
   sudo kubectl get nodes


5. **Create a Deployment**

   Run the following command on the master node to create and verify the deployment

   ```bash
   sudo ./scripts/create_deployment.sh test-namespace test-deployment nginx:latest 100m 500m 128Mi 512Mi 80 50
   sudo kubectl get deployments -n test-namespace


6. **Get Health Status for a given deployment**

   Run the following command on the master node to get the health status for a given deployment

   ```bash
   sudo ./scripts/get_health_status.sh test-namespace test-deployment

## Test Cases

1. **Test Case 1: Basic cluster initialization on EC2 instances**

   - Expected Result: Master and worker nodes should join successfully, and Kubernetes should report Ready nodes.
   - Run:
      ```bash
      sudo kubectl get nodes
   - Result:

   ![image](https://github.com/user-attachments/assets/c8f14ba7-1f73-4624-86b5-77d90901c326)

2. **Test Case 2: Create a simple deployment with a Docker image (e.g., nginx) and specific resource limits**

   - Expected Result: Deployment should be successfully created, and pods should run as expected.
   - Run:
        ```bash
        sudo ./scripts/create_deployment.sh test-ns test-deployment nginx:latest 100m 500m 128Mi 512Mi 80 50
        sudo kubectl get pods -n test-ns
        sudo kubectl get deployment test-deployment -n test-ns
   - Result:

   ![image](https://github.com/user-attachments/assets/8767e1d3-b515-4fa6-830b-b6d2511f1a4e)

   ![image](https://github.com/user-attachments/assets/2ea2b736-479e-4ccf-abbc-d1af50826f1f)

3. **Test Case 3: Retrieve health status of an existing deployment**

   - Expected Result: The health check script should return the status of pods and related resources.
   - Run:
        ```bash
        sudo ./scripts/get_health_status.sh test-namespace test-deployment
   - Result: 

   ![image](https://github.com/user-attachments/assets/2aaa3607-2394-46c3-b4d7-dd548c076618)



