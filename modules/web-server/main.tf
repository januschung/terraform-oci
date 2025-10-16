resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "${var.name_prefix}-vcn"
  dns_label      = lower("${var.dns_label}")
  is_ipv6enabled = false
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-igw"
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_security_list" "http_https" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.name_prefix}-sec-list"

  dynamic "ingress_security_rules" {
    for_each = var.ingress_security_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      description = lookup(ingress_security_rules.value, "description", null)
      dynamic "tcp_options" {
        for_each = lookup(ingress_security_rules.value, "tcp_options", null) != null ? [1] : []
        content {
          min = ingress_security_rules.value.tcp_options.min
          max = ingress_security_rules.value.tcp_options.max
        }
      }
      dynamic "udp_options" {
        for_each = lookup(ingress_security_rules.value, "udp_options", null) != null ? [1] : []
        content {
          min = ingress_security_rules.value.udp_options.min
          max = ingress_security_rules.value.udp_options.max
        }
      }
      dynamic "icmp_options" {
        for_each = lookup(ingress_security_rules.value, "icmp_options", null) != null ? [1] : []
        content {
          type = ingress_security_rules.value.icmp_options.type
          code = lookup(ingress_security_rules.value.icmp_options, "code", null)
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.egress_security_rules
    content {
      protocol    = egress_security_rules.value.protocol
      destination = egress_security_rules.value.destination
      description = lookup(egress_security_rules.value, "description", null)
      dynamic "tcp_options" {
        for_each = lookup(egress_security_rules.value, "tcp_options", null) != null ? [1] : []
        content {
          min = egress_security_rules.value.tcp_options.min
          max = egress_security_rules.value.tcp_options.max
        }
      }
      dynamic "udp_options" {
        for_each = lookup(egress_security_rules.value, "udp_options", null) != null ? [1] : []
        content {
          min = egress_security_rules.value.udp_options.min
          max = egress_security_rules.value.udp_options.max
        }
      }
      dynamic "icmp_options" {
        for_each = lookup(egress_security_rules.value, "icmp_options", null) != null ? [1] : []
        content {
          type = egress_security_rules.value.icmp_options.type
          code = lookup(egress_security_rules.value.icmp_options, "code", null)
        }
      }
    }
  }
}

resource "oci_core_subnet" "subnet" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  cidr_block     = "10.0.1.0/24"
  display_name   = "${var.name_prefix}-subnet"
  security_list_ids = [oci_core_security_list.http_https.id,
  oci_core_virtual_network.vcn.default_security_list_id, ]
  route_table_id = oci_core_route_table.public_rt.id
  dns_label      = lower("${var.dns_label}")
}

data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "instance" {
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
    # Uncomment the following line to use a cloud-init script
    # user_data           = base64encode(templatefile("${path.module}/cloud-init.sh.tftpl", {}))
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.subnet.id
    assign_public_ip       = true
    skip_source_dest_check = true
  }

  preserve_boot_volume = false

  display_name = "${var.name_prefix}-instance"
}
