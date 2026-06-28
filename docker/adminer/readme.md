#change listen network for access
## localhost and docker gateway
sudo nano /etc/postgresql/15/main/postgresql.conf
listen_addresses = '127.0.0.1,172.17.0.1'

#change allow from network bride docker
## from docker gateway to internal docker subnet
sudo nano /etc/postgresql/15/main/pg_hba.conf

# Allow Docker containers on devops network
host    all    all    172.30.0.0/24    md5
host    all    all    ip public/16     md5

