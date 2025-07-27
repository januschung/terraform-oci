variable "compartment_ocid" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "backend_ip" {
  type = string
}

variable "backend_http_port" {
  type    = number
  default = 30080
}

variable "backend_https_port" {
  type    = number
  default = 30443
}

variable "name" {
  type    = string
  default = "k3s-lb"
}
