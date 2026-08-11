#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${DD_API_KEY:-}" ]]; then
  echo "ERROR: DD_API_KEY is not set."
  exit 1
fi

CONTAINER_NAME="datadog-agent"

if docker ps --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  echo "Datadog Agent is already running."
  exit 0
fi

if docker ps -a --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  docker start "${CONTAINER_NAME}"
  exit 0
fi

docker run -d \
  --name "${CONTAINER_NAME}" \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -p 127.0.0.1:8126:8126/tcp \
  -e DD_API_KEY="${DD_API_KEY}" \
  -e DD_SITE="datadoghq.com" \
  datadog/agent:latest
