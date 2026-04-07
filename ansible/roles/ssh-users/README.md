# SSH Users Role

Manages SSH users with certificate-based authentication.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_users` | `[]` | List of users to create |
| `ssh_port` | `22` | SSH port |
| `ssh_password_auth` | `false` | Enable password auth |
| `ssh_certificate_auth` | `true` | Enable certificate auth |
| `ssh_ca_key` | - | CA public key content |

## Example

```yaml
ssh_users:
  - name: deploy
    groups: sudo
    key: "ssh-rsa AAAA..."
```
