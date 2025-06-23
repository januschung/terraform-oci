variable "compartment_ocid" {
  description = "The OCID of the compartment where the instance will be created"
  type        = string
  sensitive   = true
}

variable "internal_cidr" {
  description = "Allowed internal CIDR range for Kubernetes node-to-node communication"
  type        = string
  default     = "10.0.0.0/16"
}

module "k3s_master" {
  source           = "./modules/web-server"
  compartment_ocid = var.compartment_ocid
  ssh_public_key   = file("~/.ssh/id_rsa.pub")
  shape            = "VM.Standard.A1.Flex"
  ocpus            = 2
  memory_gb        = 12
  name_prefix      = "k3s-master"
  dns_label        = "k3smaster"
  ingress_security_rules = [
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options = {
        min = 80
        max = 80
      }
      description = "Allow HTTP"
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options = {
        min = 443
        max = 443
      }
      description = "Allow HTTPS"
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options = {
        min = 6443
        max = 6443
      }
      description = "Kubernetes API server"
    },
    {
      protocol = "6"
      source   = var.internal_cidr
      tcp_options = {
        min = 10250
        max = 10250
      }
      description = "Kubelet API"
    },
    {
      protocol = "17"
      source   = var.internal_cidr
      udp_options = {
        min = 8472
        max = 8472
      }
      description = "Flannel VXLAN"
    }
  ]
  egress_security_rules = [
    {
      protocol    = "all"
      destination = "0.0.0.0/0"
      description = "Allow all egress"
    }
  ]
}

output "k3s_master_instance_ip" {
  value       = module.k3s_master.instance_public_ip
  description = "Public IP address of the K3s master instance"
}

output "latest_image_id" {
  value       = module.k3s_master.source_image_id
  description = "ID of the latest source image as a reference for future updates"
}
