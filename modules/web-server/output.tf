output "instance_public_ip" {
  description = "Public IP address of the compute instance"
  value       = oci_core_instance.instance.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the K3s instance"
  value       = oci_core_instance.instance.private_ip
}

output "subnet_id" {
  description = "The OCID of the subnet where the instance is launched"
  value       = oci_core_subnet.subnet.id
}

output "source_image_id" {
  description = "value of the latest source image of the compute instance for future update"
  value       = data.oci_core_images.oracle_linux.images[0].id
}

output "instance_id" {
  description = "The OCID of the compute instance"
  value       = oci_core_instance.instance.id
}
