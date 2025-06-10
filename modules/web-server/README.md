# Docker Server Module for Oracle Cloud Infrastructure

This Terraform module deploys a Docker-ready Oracle Linux server on OCI.

## Variables

| Name             | Description                                                      | Type   | Default     | Required |
|------------------|------------------------------------------------------------------|--------|-------------|----------|
| compartment_ocid | OCI compartment OCID                                             | string | n/a         | yes      |
| availability_domain | OCI availability domain                                       | string | "bMkp:PHX-AD-3" | no   |
| ssh_public_key   | SSH public key to access instance                                | string | n/a         | yes      |
| shape            | Shape of the compute instance                                    | string | "VM.Standard.A1.Flex" | no |
| ocpus            | Number of OCPUs if shape supports flexible config                | number | 1           | no       |
| memory_gb        | Memory in GB if shape supports flexible config                   | number | 6           | no       |
| name_prefix      | Prefix to add to resource names                                  | string | "my-app"    | no       |
| **ocid_image_id**| **OCID of the image to use for the compute instance**            | string | "ocid1.image.oc1.phx.aaaaaaaaeqdefxlbovrp5uafn6gp5kxmesjdmkk7e7lhqcfgfy67zckwynlq" | no |

## Example Usage

```hcl
module "docker_server" {
  source              = "./modules/web-server"
  compartment_ocid    = "ocid1.compartment.oc1..exampleuniqueID"
  availability_domain = "bMkp:PHX-AD-3"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  shape               = "VM.Standard.A1.Flex"
  ocpus               = 1
  memory_gb           = 6
  name_prefix         = "myapp"
  ocid_image_id       = "ocid1.image.oc1.phx.aaaaaaaaexampleid"
}
```

## Outputs

- `instance_public_ip`: Public IP address of the compute instance
- `source_image_id`: ID of the latest source image used

## Notes

- The `ocid_image_id` variable allows you to specify a custom image OCID for the compute instance. By default, it uses a recent Oracle Linux 9 image.
