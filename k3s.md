# K3s Master Node Setup with Ansible

You can provision a lightweight Kubernetes (K3s) master node on OCI using Ansible.

## Usage

From the `ansible` directory:

```bash
ansible-playbook \
  -i 'YOUR_PUBLIC_IP,' \
  -u opc \
  --private-key /path/to/your/private-key \
  playbooks/setup-k3s.yml
```

**Note:** The trailing comma in `-i 'IP,'` is important for Ansible to treat it as a host list.

## What This Playbook Does

- Disables swap (required by Kubernetes)
- Loads and configures kernel modules and sysctl for Kubernetes networking
- Installs and initializes K3s as a master node
- Waits for the node to be Ready
- Installs and enables chrony for time synchronization
- Copies kubeconfig to the `opc` user and sets up the environment

See the `ansible/roles/k3s` role for details.
