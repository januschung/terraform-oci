terraform {
  required_version = ">= 1.5.0, < 2.0"
  backend "oci" {
    bucket    = "terraform-state-janus"
    namespace = "axe1jrgylnqc"
    region    = "us-phoenix-1"
    key       = "envs/prod/terraform.tfstate"
  }
}
