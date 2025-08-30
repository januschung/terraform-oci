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
  default     = "my-app"
}

variable "ocid_image_id" {
  description = "OCID of the image to use for the compute instance"
  type        = string
  default     = "ocid1.image.oc1.phx.aaaaaaaaeqdefxlbovrp5uafn6gp5kxmesjdmkk7e7lhqcfgfy67zckwynlq"
}

variable "dns_label" {
  description = "DNS label for the subnet"
  type        = string
  default     = "myappdns"
}

variable "ingress_security_rules" {
  description = "List of ingress security rules for the security list"
  type = list(object({
    protocol = string
    source   = string
    tcp_options = optional(object({
      min = number
      max = number
    }))
    udp_options = optional(object({
      min = number
      max = number
    }))
    icmp_options = optional(object({
      type = number
      code = optional(number)
    }))
    description = optional(string)
  }))
  default = []
}

variable "egress_security_rules" {
  description = "List of egress security rules for the security list"
  type = list(object({
    protocol    = string
    destination = string
    tcp_options = optional(object({
      min = number
      max = number
    }))
    udp_options = optional(object({
      min = number
      max = number
    }))
    icmp_options = optional(object({
      type = number
      code = optional(number)
    }))
    description = optional(string)
  }))
  default = []
}
