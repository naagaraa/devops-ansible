#!/bin/bash

set -e

echo "=============================="
echo " FIX MONITORING STACK START"
echo "=============================="

BASE_DATA="/home/developer/docker/monitoring"
BASE_COMPOSE="/home/developer/devops/docker"

echo "[1/6] Create folders..."
mkdir -p $BASE_DATA/{grafana,prometheus,loki,chunks,rules,promtail}

echo "[2/6] Fix permissions..."

# Grafana (uid 472)
sudo chown -R 472:472 $BASE_DATA/grafana

# Prometheus (nobody)
sudo chown -R 65534:65534 $BASE_DATA/prometheus

# Loki (grafana uid)
sudo chown -R 10001:10001 $BASE_DATA/loki

# Promtail temp
sudo chown -R 10001:10001 $BASE_DATA/promtail

echo "[3/6] Fix chmod..."
sudo chmod -R 775 $BASE_DATA

echo "[4/6] Ensure Docker network exists..."
docker network inspect devops >/dev/null 2>&1 || docker network create devops

echo "[5/6] Restart stack..."
cd $BASE_COMPOSE
docker compose down
docker compose up -d

echo "[6/6] Status check..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "=============================="
echo " FIX COMPLETED"
echo "=============================="
