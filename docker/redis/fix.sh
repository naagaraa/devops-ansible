#!/usr/bin/env bash
set -e

echo "== Fix Redis System Settings =="

# 1. Fix Redis warning (overcommit)
sudo sysctl -w vm.overcommit_memory=1
echo "vm.overcommit_memory=1" | sudo tee /etc/sysctl.conf > /dev/null

echo "== Fix RedisInsight Permissions =="

# 2. Fix permission RedisInsight data
sudo chown -R 1000:1000 /home/developer/docker/redisinsight/data
sudo chmod -R 755 /home/developer/docker/redisinsight/data

echo "== Restart Containers =="

# 3. Restart stack
docker restart redis || true
docker restart redisinsight || true

echo "== DONE =="
