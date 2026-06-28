#!/usr/bin/env bash
set -e

docker compose \
  --env-file /home/developer/docker/redis/.env \
  up -d
