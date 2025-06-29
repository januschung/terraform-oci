# Docker Host Setup with Ansible

Once your OCI instance is provisioned, you can configure it as a Docker host using Ansible.

## Usage

From the `ansible` directory:

```bash
ansible-playbook \
  -i 'YOUR_PUBLIC_IP,' \
  -u opc \
  --private-key /path/to/your/private-key \
  playbooks/setup-docker.yml
```

**Note:** The trailing comma in `-i 'IP,'` is important for Ansible to treat it as a host list.

## What This Playbook Does

- Updates packages
- Installs Docker and dependencies
- Configures firewall for HTTP/HTTPS
- Adds the `opc` user to the Docker group

See the `ansible/roles/docker` role for details.
