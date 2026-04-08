# OCI Compute Provisioning with Terraform + Ansible Automation 

This project provisions Oracle Cloud Infrastructure (OCI) compute instances using Terraform, and configures them with Ansible. It provides a reproducible infrastructure-as-code setup for deploying and preparing lightweight OCI hosts, including K3s Kubernetes clusters.

---

## What This Project Does

- **Creates virtual machines (VMs) on OCI**
- **Provisions related OCI networking components**
- **Bootstraps instances using Ansible or cloud-init**
- **Deploys K3s Kubernetes clusters with master and worker nodes**

---

## 📁 Project Structure

```
├── ansible
│   ├── playbooks
│   │   ├── deploy-jobwinner.yml
│   │   ├── setup-docker.yml
│   │   └── setup-k3s.yml
│   └── roles
│       ├── common
│       ├── deploy-jobwinner
│       ├── docker
│       └── k3s
├── modules
│   ├── k3s-worker
│   │   ├── cloud-init.sh.tftpl
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── README.md
│   │   └── variables.tf
│   ├── lb
│   └── web-server
│       ├── cloud-init.sh.tftpl
│       ├── main.tf
│       ├── output.tf
│       ├── README.md
│       └── variables.tf
├── k3s-master.tf
├── k3s-workers.tf
├── lb-for-k3s.tf
├── job-winner.tf
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (for master node setup)
- OCI storage bucket to store terraform state

---

## How to Use

### 1. Provision OCI Compute with Terraform

From the project root:

```bash
terraform init
terraform apply
```

### 2. Configure the Host

- [Set up Docker with Ansible](./docker.md)
- [Set up K3s master node with Ansible](./k3s.md)
- Deploy K3s worker nodes automatically with cloud-init

---

## Current Capabilities

- Terraform module to create OCI compute with public IP
- Automatically configure firewall and SSH access
- Ansible workflow to install Docker and dependencies
- Ansible workflow to install K3s and configure a Kubernetes master node
- Automated K3s worker node deployment using cloud-init
- Dedicated K3s worker module
- Automatic cluster joining without manual intervention
- Cleanly organized roles for reusability

## K3s Cluster Setup

### Master Node
- Deployed using `k3s-master.tf`
- Configured with Ansible for full K3s server setup
- Public IP for external access and management

### Worker Nodes
- Deployed using `k3s-workers.tf`
- Use cloud-init for automated setup (no Ansible required)
- No public IPs for enhanced security
- Automatically join the cluster by retrieving node token from master
- Shared network infrastructure with master node

### Load Balancer
- Optional load balancer configuration in `lb-for-k3s.tf`
- Routes traffic to worker nodes for high availability

This setup is ideal for spinning up quick dev/test environments or bootstrap nodes with Docker or Kubernetes, and is easily extendable to other configurations. The K3s workers provide a scalable, secure Kubernetes cluster suitable for production workloads.
