# Reuse the master’s VCN + security lists
data "oci_core_subnet" "master_subnet" {
  subnet_id = module.k3s_master.subnet_id
}

# Workers route table (we add the default route after the VNIC exists)
resource "oci_core_route_table" "workers_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt"
}

# Private workers subnet (no public IPs), reusing the master's security lists
resource "oci_core_subnet" "workers_subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = data.oci_core_subnet.master_subnet.vcn_id
  cidr_block                 = var.worker_subnet_cidr
  display_name               = "k3s-workers-subnet"
  dns_label                  = var.worker_dns_label
  prohibit_public_ip_on_vnic = true
  security_list_ids          = data.oci_core_subnet.master_subnet.security_list_ids
  route_table_id             = oci_core_route_table.workers_rt.id
}

# Attach a secondary VNIC on the master into the workers subnet (NAT-facing)
resource "oci_core_vnic_attachment" "master_nat_vnic" {
  instance_id = module.k3s_master.instance_id
  create_vnic_details {
    subnet_id              = oci_core_subnet.workers_subnet.id
    display_name           = "master-nat-vnic"
    skip_source_dest_check = true # required for NAT/forwarding
  }
}

# Get the Private IP object for the NAT VNIC
data "oci_core_private_ips" "master_nat_vnic_ip" {
  vnic_id = oci_core_vnic_attachment.master_nat_vnic.vnic_id
}

# Default route for workers -> NAT instance (master's NAT VNIC Private IP)
resource "oci_core_route_table_route_rule" "workers_default_to_nat_instance" {
  route_table_id    = oci_core_route_table.workers_rt.id
  destination       = "0.0.0.0/0"
  destination_type  = "CIDR_BLOCK"
  network_entity_id = data.oci_core_private_ips.master_nat_vnic_ip.private_ips[0].id
}

# Add this block *after* the first apply, then apply again
# resource "oci_core_route_table" "workers_rt" {
#   compartment_id = var.compartment_ocid
#   vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
#   display_name   = "k3s-workers-rt"

#   # Default route -> master NAT VNIC's Private IP
#   route_rules {
#     destination       = "0.0.0.0/0"
#     destination_type  = "CIDR_BLOCK"
#     network_entity_id = data.oci_core_private_ips.master_nat_vnic_ip.private_ips[0].id
#   }
# }

output "workers_subnet_id" {
  value       = oci_core_subnet.workers_subnet.id
  description = "Private workers subnet ID"
}
output "master_nat_vnic_ip" {
  value       = data.oci_core_private_ips.master_nat_vnic_ip.private_ips[0].ip_address
  description = "Master's NAT VNIC private IP"
}
