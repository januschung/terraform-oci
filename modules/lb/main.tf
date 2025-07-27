resource "oci_load_balancer" "this" {
  compartment_id = var.compartment_ocid
  display_name   = var.name
  shape          = "flexible"
  subnet_ids     = [var.subnet_id]

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  is_private = false
}

resource "oci_load_balancer_backend_set" "http" {
  name             = "http-backend"
  load_balancer_id = oci_load_balancer.this.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "HTTP"
    url_path          = "/"
    port              = var.backend_http_port
    return_code       = 200
    retries           = 3
    timeout_in_millis = 3000
    interval_ms       = 10000
  }
}

resource "oci_load_balancer_backend_set" "https" {
  name             = "https-backend"
  load_balancer_id = oci_load_balancer.this.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = var.backend_https_port
  }
}

resource "oci_load_balancer_backend" "http_backend" {
  load_balancer_id = oci_load_balancer.this.id
  backendset_name  = oci_load_balancer_backend_set.http.name
  ip_address       = var.backend_ip
  port             = var.backend_http_port
  weight           = 1
}

resource "oci_load_balancer_backend" "https_backend" {
  load_balancer_id = oci_load_balancer.this.id
  backendset_name  = oci_load_balancer_backend_set.https.name
  ip_address       = var.backend_ip
  port             = var.backend_https_port
  weight           = 1
}

resource "oci_load_balancer_listener" "http" {
  name                        = "http"
  load_balancer_id            = oci_load_balancer.this.id
  default_backend_set_name    = oci_load_balancer_backend_set.http.name
  port                        = 80
  protocol                    = "TCP"
}

resource "oci_load_balancer_listener" "https" {
  name                        = "https"
  load_balancer_id            = oci_load_balancer.this.id
  default_backend_set_name    = oci_load_balancer_backend_set.https.name
  port                        = 443
  protocol                    = "TCP"
}
