variable "compartment_ocid" {
  description = "OCI compartment OCID"
  type        = string
  sensitive   = true
}

variable "availability_domain" {
  description = "OCI availability domain"
  type        = string
  default     = "bMkp:PHX-AD-3"
}

variable "ssh_public_key" {
  description = "SSH public key to access instance"
  type        = string
}

variable "shape" {
  description = "Shape of the compute instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  description = "Number of OCPUs if shape supports flexible config"
  type        = number
  default     = 1
}

variable "memory_gb" {
  description = "Memory in GB if shape supports flexible config"
  type        = number
  default     = 6
}

variable "name_prefix" {
  description = "Prefix to add to resource names"
  type        = string
  default     = "k3s-worker"
}

variable "ocid_image_id" {
  description = "OCID of the image to use for the compute instance"
  type        = string
  default     = "ocid1.image.oc1.phx.aaaaaaaa72cedjfaq5smtmwxpjwrhmcfpvcpqo2ppomzxlpfb72svn7vnapq"
}

variable "worker_count" {
  description = "Number of worker instances to create"
  type        = number
  default     = 1
}

variable "subnet_id" {
  description = "OCID of the subnet where workers will be placed"
  type        = string
}

variable "master_private_ip" {
  description = "Private IP address of the K3s master node"
  type        = string
}

variable "internal_cidr" {
  description = "Internal CIDR range for node communication"
  type        = string
  default     = "10.0.0.0/16"
}

variable "k3s_token" {
  description = "K3s node token"
  type        = string
  sensitive   = true
}

variable "cluster_pod_cidr" {
  type = string
}

variable "cluster_service_cidr" {
  type = string
}
