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

1. **Cluster Initialization**

   Run the following command on the master node to initialize the Kubernetes cluster:

   ```bash
   sudo ./scripts/cluster_init.sh
