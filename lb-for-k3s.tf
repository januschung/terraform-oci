module "lb" {
  source             = "./modules/lb"
  name               = "k3s-lb"
  compartment_ocid   = var.compartment_ocid
  subnet_id          = module.k3s_master.subnet_id
  backend_ip         = module.k3s_master.instance_private_ip
  backend_http_port  = 30080
  backend_https_port = 30443
}

output "lb_public_ip" {
  value = module.lb.public_ip
}
