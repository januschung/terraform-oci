variable "compartment_ocid" {
  description = "The OCID of the compartment where the instance will be created"
  type        = string
  sensitive   = true
}

module "job_winner" {
  source           = "./modules/web-server"
  compartment_ocid = var.compartment_ocid
  ssh_public_key   = file("~/.ssh/id_rsa.pub")
  shape            = "VM.Standard.A1.Flex"
  ocpus            = 1
  memory_gb        = 6
  name_prefix      = "job-winner"
}

output "instance_ip" {
  value       = module.job_winner.instance_public_ip
  description = "Public IP address of the Docker instance"
}

output "latest_image_id" {
  value       = module.job_winner.source_image_id
  description = "ID of the latest source image as a reference for future updates"
}
