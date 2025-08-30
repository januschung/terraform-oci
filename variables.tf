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
