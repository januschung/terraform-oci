# OCI Compute Provisioning with Terraform + Ansible Automation

This project provisions an Oracle Cloud Infrastructure (OCI) compute instance using Terraform, and configures it with Docker using Ansible. It provides a reproducible infrastructure-as-code setup for deploying and preparing lightweight OCI hosts.

---

## What This Project Does

- **Creates a virtual machine (VM) on OCI**
  - Customizable shape (e.g., Ampere-based)
  - User-provided image OCID
  - Injects SSH key for remote access
  - Attaches public IP and security rules

- **Provisions related OCI networking components**
  - VNIC, subnet, and optionally NSG/security lists
  - Defines security ingress for SSH, HTTP, and HTTPS

- **Bootstraps the instance using Ansible**
  - Updates packages, installs Docker, configures firewall
  - Organized into reusable Ansible roles
  - Optionally extensible to support Kubernetes (K3s)

---

## 📁 Project Structure

```
├── ansible
│   ├── playbooks
│   │   └── setup-docker.yml
│   └── roles
│       ├── common
│       └── docker
├── job-winner.tf
├── main.tf
├── modules
│   └── docker-server
│       ├── cloud-init.sh.tftpl # optional configure if not using ansible
│       ├── main.tf
│       ├── output.tf
│       ├── README.md
│       └── variables.tf
├── README.md
└── variables.tf
```
## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- OCI storage bucket to store terraform state

## How to Use

### 1. Provision OCI Compute with Terraform

From the project root:

```bash
terraform init
terraform apply
```

### 2. Configure the Host with Ansible
Once the instance is ready, configure it using Ansible:

```bash
cd ansible

ansible-playbook \
  -i 'YOUR_PUBLIC_IP,' \
  -u opc \
  --private-key /path/to/your/private-key \
  playbooks/setup-docker.yml
```

Note: The trailing comma in -i `'IP,'` is important for Ansible to treat it as a host list.

## Current Capabilities

- Terraform module to create OCI compute with public IP
- Automatically configure firewall and SSH access
- Ansible workflow to install Docker and dependencies
- Cleanly organized roles for reusability

This setup is ideal for spinning up quick dev/test environments or bootstrap nodes with Docker, and is easily extendable to Kubernetes or other configurations.