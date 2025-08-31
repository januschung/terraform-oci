# Reuse the master’s VCN + security lists
data "oci_core_subnet" "master_subnet" {
  subnet_id = module.k3s_master.subnet_id
}

# Step 1: base route table (no rules)
resource "oci_core_route_table" "workers_rt_base" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt-base"
}

# Variable is empty on step 1, set on step 2
variable "nat_target_private_ip_ocid" {
  description = "OCID of the master's NAT VNIC Private IP (filled after Step 1)"
  type        = string
  default     = ""
}

# Base RT (no rules) used in Step 1
resource "oci_core_route_table" "workers_rt_base" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt-base"
}

# NAT RT appears only when the OCID is provided (Step 2)
resource "oci_core_route_table" "workers_rt_nat" {
  count          = var.nat_target_private_ip_ocid != "" ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt-nat"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.nat_target_private_ip_ocid
  }
}

# Decide which RT the subnet uses
locals {
  # If NAT RT exists, pick its id; otherwise fall back to base RT id
  workers_route_table_id = element(
    concat(oci_core_route_table.workers_rt_nat[*].id, [oci_core_route_table.workers_rt_base.id]),
    0
  )
}

# Private workers subnet (no public IPs), points to base on step 1, NAT RT on step 2
resource "oci_core_subnet" "workers_subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = data.oci_core_subnet.master_subnet.vcn_id
  cidr_block                 = var.worker_subnet_cidr
  display_name               = "k3s-workers-subnet"
  dns_label                  = var.worker_dns_label
  prohibit_public_ip_on_vnic = true
  security_list_ids          = data.oci_core_subnet.master_subnet.security_list_ids
  route_table_id             = local.workers_route_table_id
}

# Attach a secondary VNIC on the master into the workers subnet (NAT-facing)
resource "oci_core_vnic_attachment" "master_nat_vnic" {
  instance_id = module.k3s_master.instance_id
  create_vnic_details {
    subnet_id              = oci_core_subnet.workers_subnet.id
    display_name           = "master-nat-vnic"
    skip_source_dest_check = true
  }
}

# Look up the VNIC's Private IP (for output; used to feed step 2 var)
data "oci_core_private_ips" "master_nat_vnic_ip" {
  vnic_id = oci_core_vnic_attachment.master_nat_vnic.vnic_id
}

# Step 2: NAT route table (created only when var is set)
resource "oci_core_route_table" "workers_rt_nat" {
  count          = local.nat_enabled ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt-nat"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.nat_target_private_ip_ocid
  }
}

# Helpful outputs
output "workers_subnet_id" {
  value       = oci_core_subnet.workers_subnet.id
  description = "Private workers subnet ID"
}

output "master_nat_private_ip_ocid" {
  value       = data.oci_core_private_ips.master_nat_vnic_ip.private_ips[0].id
  description = "OCID of the master's NAT VNIC Private IP (feed into var for step 2)"
}

output "master_nat_private_ip_addr" {
  value       = data.oci_core_private_ips.master_nat_vnic_ip.private_ips[0].ip_address
  description = "IP address of the master's NAT VNIC"
}
