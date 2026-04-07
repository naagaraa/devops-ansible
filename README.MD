# Automation

## Ansible Structure

This repository uses a role-based Ansible structure for server provisioning.

### Directory Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── inventory/
│   └── hosts.ini        # Inventory file
├── playbooks/
│   └── main.yml         # Main entry playbook
├── roles/
│   ├── ssh-users/       # SSH user + certificate auth
│   ├── ubuntu-base/     # Base Ubuntu server setup
│   ├── ntopng/          # ntopng monitoring
│   └── laravel-go/      # Laravel + Go + Nginx
└── group_vars/          # Group variables
```

### Roles

- **ssh-users**: SSH user management with certificate-based auth
- **ubuntu-base**: Base Ubuntu server with firewall, fail2ban, docker
- **ntopng**: Network monitoring tool
- **laravel-go**: PHP-FPM, Nginx, Composer, Node.js, Bun, Go, Supervisor

### Usage

```bash
# Run all roles
make all

# SSH users setup
make ssh-users

# Run specific role
make base
make ntopng
make laravel-go

# Dry run
make dry-run

# Check syntax
make check
```

## Documentation

See `docs/` directory for detailed documentation:

- [docs/usage.md](docs/usage.md) - How to use the automation
- [docs/overview.md](docs/overview.md) - Architecture and flow

## Desktop Scripts

Scripts for desktop environment setup are located in `scripts/desktop/`.

## Legacy Setup

Old playbooks are kept in `setup/server/ubuntu/` for reference.
