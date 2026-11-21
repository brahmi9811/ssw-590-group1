# T13 runbook: the new project server (draft, nothing executed)

Status: Nov 20, 2026. Assignment 8 is uploaded, so the server may be created when BD says so. Each step marked **[BD]** is done or explicitly approved by BD; the AI assistant prepares files and reads only. No secret is typed into chat, Git or the report.

## Step 0: cost guard (before anything else) [BD]
- [ ] AWS Billing, Budgets: monthly cost budget, 50 USD, alerts at 50% and 80% to BD's email.
- [ ] Write the date and the budget name in `evidence/` (screenshot, no account numbers visible).

## Step 1: network and instance [BD]
| Item | Value | Note |
|---|---|---|
| Region | us-east-1 | same account as the assignments, separate resources |
| Name tag | `g1-project` | tag every resource `project=ssw590-final` so the teardown finds them |
| AMI | Amazon Linux 2023 | |
| Type | t3.medium | about $0.042 per hour; stopped instances cost only the disk |
| Disk | gp3 30 GB | the assignments server runs at 84% of 20 GB; do not repeat that |
| Security group `g1-project-sg` | 80 and 443 from anywhere; 22 from the two team addresses only | no other public port; Grafana and Jenkins go through Caddy |
| Elastic IP | one, attached | an unattached Elastic IP is billed, so release it at teardown |
| Key pair | new key pair `g1-project`, private key stays on BD's PC | |

## Step 2: DNS [BD] (Name.com)
- `pipeline.ssw590-g1.tech` A record to the Elastic IP (Jenkins)
- `load.ssw590-g1.tech` A record to the Elastic IP (Grafana)
- Check with `nslookup` before Caddy asks for certificates.

## Step 3: base software (commands prepared by the AI, run by BD over SSH)
1. Docker Engine and the Compose plugin (as in `infra/aws/ec2-user-data.sh`).
2. Folder `/opt/project` with `deploy/` cloned from the project repository (needs T1).
3. `docker compose up -d` for: Caddy, Jenkins controller, Jenkins agent, Prometheus, Grafana, Node Exporter.
4. Secrets typed by BD into `.env` on the server (Jenkins admin password, Grafana admin password, webhook secret); `.env` is never committed.

## Step 4: files to prepare now (no cost)
Derived from the assignments `infra` repository, simplified for one purpose:
| New file | Based on | Change |
|---|---|---|
| `deploy/docker-compose.yml` | `infra/docker-compose.yml`, `infra/jenkins/docker-compose.yml`, `infra/monitoring/compose.yaml` | no Gitea, no act_runner, no pricing apps, one network |
| `deploy/Caddyfile` | `infra/Caddyfile` | two sites: `pipeline.` to Jenkins, `load.` to Grafana |
| `deploy/prometheus.yml` | `infra/monitoring/prometheus/prometheus.yml` | Node Exporter and cAdvisor-free; scrape interval decided with D9 |
| `deploy/grafana/dashboard.json` | `infra/monitoring/grafana/group1-sre-dashboard.json` | CPU, memory, disk, network panels only; short refresh |
| `deploy/jenkins/plugins.txt`, `Dockerfile` | `infra/jenkins/` | add the GitHub plugin; keep the TeX Live build on the agent |

## Step 5: checks (acceptance of T13)
- [ ] `https://pipeline.ssw590-g1.tech` and `https://load.ssw590-g1.tech` answer with valid certificates.
- [ ] Budget alert exists.
- [ ] `docker compose ps` all healthy; disk below 60% after the first TeX Live pull.
- [ ] Teardown procedure below written and reviewed by SD.

## Teardown (BD alone, only after all grading, never by the assistant)
1. Stop the instance (first), keep a snapshot only if the report needs more evidence.
2. Terminate the instance, delete the volume.
3. Release the Elastic IP.
4. Delete the DNS records at Name.com.
5. Delete the security group and the key pair; check the Billing page the next day and record the total cost in the report.

## Open
- D9 (scrape interval and what the live load looks like) stays open until the first rehearsal on this server.
- T1 (the repository) must exist before `deploy/` can be cloned onto the server.
