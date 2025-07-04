module "job_winner" {
  source           = "./modules/web-server"
  compartment_ocid = var.compartment_ocid
  ssh_public_key   = file("~/.ssh/id_rsa.pub")
  shape            = "VM.Standard.A1.Flex"
  ocpus            = 1
  memory_gb        = 6
  name_prefix      = "job-winner"
  dns_label        = "jobwinner"
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

output "jobwinnner_instance_ip" {
  value       = module.job_winner.instance_public_ip
  description = "Public IP address of the Docker instance"
}
