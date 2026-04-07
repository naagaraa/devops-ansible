# PostgreSQL Role

PostgreSQL database server setup.

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `postgresql_version` | `16` | PostgreSQL version |
| `postgresql_port` | `5432` | Listen port |
| `postgresql_databases` | `[]` | Databases to create |
| `postgresql_users` | `[]` | Users to create |

## Example

```yaml
postgresql_databases:
  - name: myapp_db
    encoding: UTF8

postgresql_users:
  - name: myapp_user
    password: secret
    priv: ALL
```
