#!/bin/bash
# EC2 user data for Amazon Linux 2023: installs Docker, clones the group
# repository, builds the two-button website image, and serves it on port 80.
set -euxo pipefail

dnf update -y
dnf install -y docker git
systemctl enable --now docker
usermod -aG docker ec2-user

git clone https://github.com/brahmi9811/ssw-590-group1.git /opt/ssw-590-group1
cd /opt/ssw-590-group1/website/color-buttons-app

docker build -t color-buttons-app:2.0 .
docker run -d --name color-buttons-app --restart unless-stopped -p 80:3000 color-buttons-app:2.0
