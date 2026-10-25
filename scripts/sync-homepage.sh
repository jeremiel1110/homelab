#!/usr/bin/env bash
# sync-homepage.sh — pull the homelab repo and re-apply the Homepage stack
# if its docker-compose.yml changed. Meant to run from cron on the Docker LXC.
#
# Usage:
#   bash /opt/homelab/scripts/sync-homepage.sh
#
# Prints nothing when there is nothing new to pull.

set -euo pipefail

REPO_DIR="/opt/homelab"
cd "$REPO_DIR"

old=$(git rev-parse HEAD)
git pull --ff-only --quiet
new=$(git rev-parse HEAD)

if [ "$old" = "$new" ]; then
  exit 0
fi

echo "$(date '+%F %T') pulled ${old:0:7} -> ${new:0:7}"

# Homepage reloads config/*.yaml on its own.
# Only a docker-compose.yml change needs the container to be re-created.
if ! git diff --quiet "$old" "$new" -- homepage/docker-compose.yml; then
  echo "docker-compose.yml changed, re-applying"
  (cd homepage && docker compose up -d)
fi