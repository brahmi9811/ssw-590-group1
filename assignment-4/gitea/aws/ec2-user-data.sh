#!/bin/bash
# First-boot setup for the Gitea host on Amazon Linux 2023 (x86_64). Runs once as root.
# No secrets in this file. Output goes to /var/log/user-data.log and the EC2 console.
# Installs: 2 GB swap (t3.micro has 1 GB RAM), Docker, git, and a pinned, checksummed
# Docker Compose plugin. Does NOT deploy Gitea: that is done by hand and documented.
set -euxo pipefail
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

COMPOSE_VERSION="v5.6.0"
# SHA-256 of docker-compose-linux-x86_64 for v5.6.0 (GitHub release asset digest and .sha256 file agree).
COMPOSE_SHA256="40343e21ca777173e69cff5dbafeb37c6f81f3b0d57d9e597f036e95eb63e76a"

# --- 2 GB swap file (idempotent) ---
if ! swapon --show | grep -q /swapfile; then
  dd if=/dev/zero of=/swapfile bs=1M count=2048
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
fi

# --- Docker + git from the Amazon Linux repositories ---
dnf install -y docker git
systemctl enable --now docker
usermod -aG docker ec2-user

# --- Docker Compose plugin, pinned and verified ---
PLUGIN_DIR=/usr/local/lib/docker/cli-plugins
mkdir -p "$PLUGIN_DIR"
curl -fsSL -o "$PLUGIN_DIR/docker-compose" \
  "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64"
echo "${COMPOSE_SHA256}  ${PLUGIN_DIR}/docker-compose" | sha256sum -c -
chmod +x "$PLUGIN_DIR/docker-compose"

# --- Record versions for the manual ---
docker --version
docker compose version
git --version
free -m
swapon --show
echo "user-data finished OK"
