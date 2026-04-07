# Ansible Automation Documentation

## Prerequisites

- Ansible installed on control node
- SSH access to target servers
- Python 3 on target servers

### Installation

```bash
# Install Ansible (Ubuntu/Debian)
sudo apt update
sudo apt install ansible

# Or via pip
pip install ansible
```

## Quick Start

```bash
# Run all setup
make all

# Dry run first (no changes)
make dry-run
```

## Directory Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── inventory/
│   └── hosts.ini        # Target servers inventory
├── playbooks/
│   └── main.yml         # Main playbook
├── roles/
│   ├── ssh-users/       # SSH user management
│   ├── ubuntu-base/     # Base server setup
│   ├── ntopng/          # Network monitoring
│   ├── laravel-go/      # Laravel + Go stack
│   └── postgresql/      # PostgreSQL database
└── group_vars/          # Variables per group
```

## Inventory Configuration

Edit `ansible/inventory/hosts.ini`:

```ini
[servers]
your-server ansible_host=192.168.1.100 ansible_user=your-user
```

For key-based auth:
```ini
[servers]
your-server ansible_host=192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make all` | Run complete setup |
| `make ssh-users` | Create SSH users with certificate auth |
| `make base` | Ubuntu base setup only |
| `make ntopng` | ntopng monitoring only |
| `make laravel-go` | Laravel + Go + Nginx only |
| `make postgresql` | PostgreSQL database only |
| `make check` | Validate syntax |
| `make dry-run` | Preview changes |

## Roles Overview

### ssh-users

SSH user management with certificate-based authentication:
- Creates system users
- Deploys SSH public keys
- Configures certificate authentication
- Disables password authentication

### ubuntu-base

Base Ubuntu server configuration:
- Package updates
- Firewall (UFW)
- fail2ban
- Docker & Docker Compose
- Basic tools (git, curl, vim, etc.)

### ntopng

Network monitoring tool:
- Installs ntopng from official repo
- Configures monitoring interface
- Opens firewall port 3000

### laravel-go

Full web stack with Nginx:
- PHP-FPM with extensions
- Nginx web server
- Composer
- Node.js 20
- Bun
- Go
- Supervisor

### postgresql

PostgreSQL database server:
- PostgreSQL 16
- Creates databases and users
- Remote access via password auth
- Listens on port 5432

## SSH Users Configuration

Edit `ansible/group_vars/servers.yml`:

```yaml
ssh_users:
  - name: deploy
    comment: "Deployment user"
    groups: sudo
    key: "ssh-rsa AAAA... user@host"
```

Or use key files:
```yaml
ssh_users:
  - name: developer
    key_file: "files/keys/developer.pub"
```

### Certificate-Based Authentication

For SSH certificate authentication:

1. Generate CA key pair:
```bash
ssh-keygen -t ed25519 -f ssh_user_ca
```

2. Add CA public key to group_vars:
```yaml
ssh_certificate_auth: true
ssh_ca_key: |
  ssh-ed25519 AAAAC3... your-ca-key
```

3. Sign user keys:
```bash
ssh-keygen -s ssh_user_ca -I "user@host" -n username user-key.pub
```

## PostgreSQL Configuration

Edit `ansible/group_vars/servers.yml`:

```yaml
postgresql_databases:
  - name: myapp_db
    encoding: UTF8

postgresql_users:
  - name: myapp_user
    password: "secure_password"
    priv: ALL
```

### PostgreSQL Connection

```bash
# Connect to PostgreSQL
psql -h localhost -U myapp_user -d myapp_db

# Default connection info
Host: <server_ip>
Port: 5432
Database: myapp_db
User: myapp_user
Password: (as configured)
```

## Custom Variables

Override defaults in `group_vars/servers.yml`:

```yaml
# PHP version
php_version: "8.3"

# Node version
node_version: "20"

# Nginx web root
nginx_web_root: "/var/www/html"

# ntopng settings
ntopng_interface: "eth0"
ntopng_http_port: "3000"

# PostgreSQL settings
postgresql_version: "16"
postgresql_port: 5432
```

## Running Specific Tags

```bash
cd ansible
ansible-playbook playbooks/main.yml --tags ssh-users
ansible-playbook playbooks/main.yml --tags postgresql
```

## Troubleshooting

### SSH Connection Issues

```bash
# Test connectivity
ansible all -m ping -i inventory/hosts.ini

# Check SSH key permissions
chmod 600 ~/.ssh/id_rsa
```

### Dry Run Mode

```bash
cd ansible
ansible-playbook playbooks/main.yml --check
```

### Verbose Output

```bash
cd ansible
ansible-playbook playbooks/main.yml -v     # Basic
ansible-playbook playbooks/main.yml -vv    # More detail
ansible-playbook playbooks/main.yml -vvv   # Connection debugging
```

### PostgreSQL Issues

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Check PostgreSQL logs
sudo tail -f /var/log/postgresql/postgresql-16-main.log
```
