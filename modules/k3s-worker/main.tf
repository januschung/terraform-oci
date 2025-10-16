resource "oci_core_instance" "worker" {
  count               = var.worker_count
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  shape               = var.shape

  dynamic "shape_config" {
    for_each = var.shape == "VM.Standard.A1.Flex" ? [1] : []
    content {
      ocpus         = var.ocpus
      memory_in_gbs = var.memory_gb
    }
  }

  source_details {
    source_type = "image"
    source_id   = var.ocid_image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.sh.tftpl", {
      master_private_ip    = var.master_private_ip
      k3s_token            = var.k3s_token
      cluster_pod_cidr     = var.cluster_pod_cidr
      cluster_service_cidr = var.cluster_service_cidr
    }))
  }

  create_vnic_details {
    subnet_id              = var.subnet_id
    assign_public_ip       = false
    skip_source_dest_check = true
  }

  preserve_boot_volume = false

  display_name = "${var.name_prefix}-${count.index + 1}"
}
