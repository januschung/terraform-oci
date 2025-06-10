output "instance_public_ip" {
  description = "Public IP address of the compute instance"
  value       = oci_core_instance.instance.public_ip
}

output "source_image_id" {
  description = "value of the latest source image of the compute instance for future update"
  value       = data.oci_core_images.oracle_linux.images[0].id
}
