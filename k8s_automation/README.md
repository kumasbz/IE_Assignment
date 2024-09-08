# Kubernetes Automation

This project provides a CLI and API to automate Kubernetes operations including cluster initialization, deployment creation, and health status retrieval.

## Prerequisites

- AWS EC2 instances running Ubuntu 20.04 or 22.04.
- Docker installed on EC2 instances.
- Kubernetes tools (`kubeadm`, `kubectl`, `kubelet`) installed.

## Setup Instructions

1. **Cluster Initialization:**

   Run the `scripts/cluster_init.sh` script on the master node:

   ```bash
   ./scripts/cluster_init.sh
