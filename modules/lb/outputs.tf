output "public_ip" {
  description = "The public IP address of the OCI Flexible Load Balancer"
  value       = oci_load_balancer.this.ip_address_details[0]
}
