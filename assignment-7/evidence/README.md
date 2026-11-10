# Assignment 7 evidence index

Numbered files; **SD uses 110–139, BD uses 140–169**. Sanitized: no tokens, passwords, webhook secrets, admin IP or AWS account ID.

| # | File | What it shows | Rubric row | Date (local) |
|---|---|---|---|---|
| 110 | 110-server-baseline-before-monitoring-sd-2026-11-10.txt | Read-only baseline over SSH (SD's key): EC2 t3.micro (2 vCPU Xeon 8259CL, us-east-1c), Amazon Linux 2023 x86_64, **913 MiB RAM with 200 MiB available and 425 MiB in swap**, root `/dev/nvme0n1p1` 20 GB with 9,003,175,936 bytes free, Docker 25.0.16 / Compose v5.6.0, containers gitea (110 MiB), jenkins (271/640 MiB), caddy (21 MiB), gitea-runner (14 MiB), 5.8 GB reclaimable images, host listening only on 22/80/443 (+ a loopback port), Gitea 1.27.3 and Jenkins 2.580.2 login pages 200. | 1 (baseline/capacity); input to G1 | 2026-11-10 18:26 EST |
| 111 | 111-image-tags-digests-amd64-and-local-config-validation-sd-2026-11-10.txt | Chosen tags with registry index and linux/amd64 digests: prom/prometheus v3.16.0, grafana/grafana 13.3.1, quay.io/prometheus/node-exporter v1.12.1, quay.io/prometheus/blackbox-exporter v0.29.1; local validation of the drafts: `docker compose config` OK, `promtool check config` SUCCESS, blackbox `--config.check` OK. Not yet deployed. | 1, 2 | 2026-11-10 18:27 EST |
