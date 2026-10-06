#!/bin/bash
# Run on the EC2 instance to pull the latest commit and replace the container.
set -euo pipefail
cd /opt/ssw-590-group1
sudo git pull --ff-only
cd website/color-buttons-app
sudo docker build -t color-buttons-app:2.0 .
sudo docker rm -f color-buttons-app || true
sudo docker run -d --name color-buttons-app --restart unless-stopped -p 80:3000 color-buttons-app:2.0
curl -s http://localhost/health
