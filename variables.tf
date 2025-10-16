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
variable "cluster_pod_cidr" {
  description = "K3s pod network CIDR (default 10.42.0.0/16)"
  type        = string
  default     = "10.42.0.0/16"
}
variable "cluster_service_cidr" {
  description = "K3s service network CIDR (default 10.43.0.0/16)"
  type        = string
  default     = "10.43.0.0/16"
}
