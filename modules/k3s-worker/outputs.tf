output "worker_private_ips" {
  description = "Private IP addresses of the worker instances"
  value       = oci_core_instance.worker[*].private_ip
}

output "worker_instance_ids" {
  description = "Instance IDs of the worker instances"
  value       = oci_core_instance.worker[*].id
}

output "worker_count" {
  description = "Number of worker instances created"
  value       = var.worker_count
}
