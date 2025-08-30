module "k3s_workers" {
  source            = "./modules/k3s-worker"
  compartment_ocid  = var.compartment_ocid
  ssh_public_key    = file("~/.ssh/id_rsa.pub")
  subnet_id         = module.k3s_master.subnet_id
  master_private_ip = module.k3s_master.instance_private_ip
  internal_cidr     = var.internal_cidr
  worker_count      = 1
}

# Outputs for worker nodes
output "k3s_worker_private_ips" {
  value       = module.k3s_workers.worker_private_ips
  description = "Private IP addresses of the K3s worker instances"
}

output "k3s_worker_instance_ids" {
  value       = module.k3s_workers.worker_instance_ids
  description = "Instance IDs of the K3s worker instances"
}

output "worker_count" {
  value       = module.k3s_workers.worker_count
  description = "Number of worker nodes created"
}
