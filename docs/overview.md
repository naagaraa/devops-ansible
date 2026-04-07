# Automation Overview

This repository provides automated server provisioning using Ansible.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│           ansible/                                       │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐         │
│  │ssh-users │  │  ubuntu  │  │    ntopng    │         │
│  │          │  │   base   │  │              │         │
│  └────┬─────┘  └────┬─────┘  └──────┬───────┘         │
│       │             │                │                   │
│       └─────────────┴────────────────┘                   │
│                         │                                │
│              ┌──────────┴──────────┐                    │
│              │    laravel-go       │                    │
│              │    + Nginx          │                    │
│              └──────────┬──────────┘                    │
│                         │                                │
│              ┌──────────┴──────────┐                    │
│              │    postgresql        │                    │
│              └─────────────────────┘                    │
│                                                           │
│              playbooks/main.yml                          │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Target Servers                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐         │
│  │  Ubuntu  │  │ Ubuntu   │  │   Ubuntu     │         │
│  │ Server 1 │  │ Server 2 │  │   Server N   │         │
│  └──────────┘  └──────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────┘
```

## Execution Flow

1. **Inventory Check** - Read server list from `inventory/hosts.ini`
2. **SSH Connection** - Establish connection to target servers
3. **Role Execution** - Apply roles in order:
   - `ssh-users` → SSH user management
   - `ubuntu-base` → Base configuration
   - `ntopng` → Monitoring
   - `laravel-go` → Web stack
   - `postgresql` → Database
4. **Verification** - Report success/failure

## SSH Certificate Authentication

The `ssh-users` role provides secure SSH access using public key and optional certificate-based authentication:

```
┌────────────────┐     ┌────────────────┐
│  Control Node  │────▶│  Target Server │
│                │     │                │
│  User Key      │     │  authorized_   │
│  (signed by CA)│     │  keys file     │
└────────────────┘     └────────────────┘
```

## Idempotency

All roles are idempotent - running them multiple times produces the same result without side effects.

## Extending

To add a new role:

```bash
mkdir -p ansible/roles/myrole/{tasks,handlers,defaults,templates}
```

Reference existing roles for structure.
