# K3s Worker Module

This Terraform module creates K3s worker nodes that automatically join an existing K3s cluster.

## Features

- **Automatic Cluster Joining**: Workers automatically retrieve the node token from the master and join the cluster
- **No Public IPs**: Workers are configured with private IPs only for security
- **Cloud-Init Setup**: Uses cloud-init for automated configuration
- **Shared Network**: Workers use the same subnet as the master node for internal communication
- **Health Monitoring**: Built-in health checks and logging

## Usage

```hcl
module "k3s_workers" {
  source             = "./modules/k3s-worker"
  compartment_ocid   = var.compartment_ocid
  ssh_public_key     = file("~/.ssh/id_rsa.pub")
  shape              = "VM.Standard.A1.Flex"
  ocpus              = 2
  memory_gb          = 8
  worker_count       = 3
  subnet_id          = module.k3s_master.subnet_id
  master_private_ip  = module.k3s_master.instance_private_ip
  internal_cidr      = "10.0.0.0/16"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_ocid | OCI compartment OCID | `string` | n/a | yes |
| ssh_public_key | SSH public key for instance access | `string` | n/a | yes |
| shape | Instance shape | `string` | `"VM.Standard.A1.Flex"` | no |
| ocpus | Number of OCPUs | `number` | `2` | no |
| memory_gb | Memory in GB | `number` | `8` | no |
| name_prefix | Name prefix for instances | `string` | `"k3s-worker"` | no |
| ocid_image_id | OCI image OCID | `string` | Oracle Linux 9 image | no |
| worker_count | Number of worker instances | `number` | `2` | no |
| subnet_id | Subnet OCID for worker placement | `string` | n/a | yes |
| master_private_ip | Master node private IP | `string` | n/a | yes |
| internal_cidr | Internal CIDR for communication | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| worker_private_ips | List of worker private IP addresses |
| worker_instance_ids | List of worker instance OCIDs |
| worker_count | Number of workers created |

## Requirements

- Terraform >= 1.5.0
- OCI provider
- Existing K3s master node
- Shared subnet between master and workers

## Dependencies

- K3s master node must be running and accessible
- Workers must be able to SSH to the master node
- Master's Kubernetes API must be accessible on port 6443

## Security

- Workers have no public IP addresses
- SSH access limited to internal network
- Firewall configured for minimal required ports
- Node token retrieved securely via SSH

## Monitoring

Workers provide logs and health checks:
- `/var/log/k3s-worker-setup.log` - Setup completion
- `/var/log/k3s-worker-install.log` - Installation process
- Health check script runs every 5 minutes
- Systemd service monitoring for k3s-agent
