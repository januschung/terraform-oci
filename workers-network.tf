# Reuse the master’s VCN + security lists
data "oci_core_subnet" "master_subnet" {
  subnet_id = module.k3s_master.subnet_id
}

# Step 1: base route table (no rules)
resource "oci_core_nat_gateway" "workers_nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-nat"
}

# Route table sending 0.0.0.0/0 through the NAT Gateway

resource "oci_core_route_table" "workers_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.master_subnet.vcn_id
  display_name   = "k3s-workers-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.workers_nat.id
  }
}

# Private workers subnet (no public IPs), reuse master's security lists
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

# Helpful outputs
output "workers_subnet_id" {
  value       = oci_core_subnet.workers_subnet.id
  description = "Private workers subnet ID"
}

output "workers_nat_gateway_id" {
  value       = oci_core_nat_gateway.workers_nat.id
  description = "NAT Gateway ID for workers subnet"
}