# OCI Compute Provisioning with Terraform + Ansible Automation

This project provisions an Oracle Cloud Infrastructure (OCI) compute instance using Terraform, and configures it with Ansible. It provides a reproducible infrastructure-as-code setup for deploying and preparing lightweight OCI hosts.

---

## What This Project Does

- **Creates a virtual machine (VM) on OCI**
- **Provisions related OCI networking components**
- **Bootstraps the instance using Ansible**

---

## 📁 Project Structure

```
├── ansible
│   ├── playbooks
│   │   ├── setup-docker.yml
│   │   └── setup-k3s.yml
│   └── roles
│       ├── common
│       ├── docker
│       └── k3s
├── modules
│   └── web-server
│       ├── cloud-init.sh.tftpl
│       ├── main.tf
│       ├── output.tf
│       ├── README.md
│       └── variables.tf
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
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

---

## Current Capabilities

- Terraform module to create OCI compute with public IP
- Automatically configure firewall and SSH access
- Ansible workflow to install Docker and dependencies
- Ansible workflow to install K3s and configure a Kubernetes master node
- Cleanly organized roles for reusability

This setup is ideal for spinning up quick dev/test environments or bootstrap nodes with Docker or Kubernetes, and is easily extendable to other configurations.