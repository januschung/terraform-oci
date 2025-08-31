# Shared variables for k3s-master.tf and k3s-workers.tf
variable "compartment_ocid" {
  description = "The OCID of the compartment where the instances will be created"
  type        = string
  sensitive   = true
}

variable "internal_cidr" {
  description = "Allowed internal CIDR range for Kubernetes node-to-node communication"
  type        = string
  default     = "10.0.0.0/16"
}

variable "k3s_token" {
  description = "K3s node token"
  type        = string
  sensitive   = true
}
# set subnet and dns label for workers
variable "worker_subnet_cidr" {
  description = "CIDR for private workers subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "worker_dns_label" {
  description = "DNS label for workers subnet"
  type        = string
  default     = "k3swrk"
}
variable "nat_target_private_ip_ocid" {
  description = "OCID of the master's NAT VNIC Private IP (from Step 1 output)"
  type        = string
  default     = "" # set via tfvars or env before Step 2 apply
}
