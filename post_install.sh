#!/bin/sh
# Run this script in a Alpine Docker LXC.
# https://community-scripts.github.io/ProxmoxVE/scripts?id=docker
set -eu

echo "👷 Updating and upgrading alpine"
apk update
apk upgrade

echo "🐳 Enabling docker on startup and starting docker"
rc-update add docker default >/dev/null 2>&1 || true
rc-service docker start >/dev/null 2>&1 || true

echo "🕰️ Waiting on docker service to be ready"
i=0
until docker info >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -ge 30 ]; then
    echo "❌ ERROR: Docker daemon not ready after 30 seconds" >&2
    exit 1
  fi
  sleep 1
done

echo "🏫 Adding watchtower"
docker rm -f watchtower >/dev/null 2>&1 || true
docker pull containrrr/watchtower:latest

docker run -d \
  --name watchtower \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower:latest \
  --cleanup \
  --interval 21600

echo "✅ Done!"
docker ps --filter "name=watchtower" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
