# Assignment 9: Implement Servicedesk Control (Zammad) (course Chapter 7)

Group 1: Brahmi Dalvi (BD) and Sakshi Deshpande (SD). Course manual: `dosManual-V1.53.pdf` (Chapter 7, "Support Ticket Management with Zammad", PDF pages 51-59; read it first).
Canvas: **#9 Implement Servicedesk Control (Zammad) -- Group, due Tue Dec 8, 2026, 11:59 pm.** The Final Project Demo is due the day before (Mon Dec 7, 11:59 pm), so the real working deadline for this assignment is earlier (see the timeline).
This is a **draft layout** written Nov 17, 2026 by BD's assistant for SD to review; rows and owners are a proposal until SD agrees.

## In one paragraph
Install the **official Zammad Docker Compose stack** (a separate Compose project, about ten containers) on our existing server, behind our **existing Caddy** on the `gitea_web` network, at its own HTTPS hostname.
Create a small support workflow (a group, a student agent, a synthetic customer, a separate **TA agent** with limited rights, three synthetic tickets, an internal note and a customer-visible reply, a customer who cannot see internal notes or other customers' tickets).
Link one ticket to a **Gitea issue in both directions**. Add the Zammad URL to the **existing Prometheus HTTPS probe job**, add **three Zammad panels** to the existing Grafana dashboard, do a **controlled outage** (stop `zammad-nginx`, see the probe fall to 0 and return to 1, confirm the ticket survives) and check the upstream backup service.
Keep Gitea, Jenkins, monitoring and the Assignment 8 application (staging and production) working. The IT manual gets a new chapter, *Support Desk (Zammad)*; the TA's username and password go in the **Canvas submission text, never in the PDF or the repository**.

## Rubric and owners (100 points, split 50/50)

| # | Criterion (course sec. 7.6) | Pts | Owner |
|---|---|---|---|
| 1 | Deployment and continuity: official versioned Compose stack, capacity check, healthy services, storage inventory, backup evidence, earlier services retained | 20 | **SD** |
| 2 | HTTPS and exposure: valid hostname and certificate, existing proxy reused, correct scheme, cloud/host rules, externally blocked internal ports | 20 | **BD** |
| 3 | Support workflow and access: three tickets (priority, owner, resolution), customer visibility check, least-privilege working TA account and checklist | 20 | **SD** |
| 4 | Engineering traceability: ticket linked to a Gitea issue in both directions, acceptance criterion, verified resolution | 10 | **SD** |
| 5 | Monitoring and recovery: three Zammad panels, reused host panels, failed and successful probes in a controlled outage, ticket retained after restart | 20 | **BD** |
| 6 | Operational documentation: readable deployment diagram, numbered runbook, sanitized configuration/evidence links, current manual history and Hosts/Passwords tables | 10 | **BD** |

Why this split: SD owns the Zammad installation and everything inside Zammad (rows 1, 3, 4 = 50). BD owns what sits around it: DNS and the Caddy route, the certificate, the AWS security group and external exposure tests (row 2), Prometheus and Grafana and the outage test (row 5), and the manual chapter with the diagram, history and tables (row 6) = 50.
The final PDF build stays a joint step (as in Assignments 6 to 8). A missing or stale **Hosts or Passwords table costs 10 points** from the whole assignment (course sec. 1.3): BD owns both tables and SD checks them at the end.

## Gates (decisions before anything is installed)

| Gate | Decision | Who |
|---|---|---|
| G1 | **Capacity and cost.** Zammad's guide recommends at least 2 CPU cores and 6 GB RAM, plus 4 GB when Elasticsearch runs on the same host. The server is a t3.medium: 2 vCPU, 3,835 MiB RAM of which 1,837 MiB are available, 2 GB swap (246 MiB used), **disk 20 GB with 3.5 GB free (83 % used)** (baseline, evidence 280). The Jenkins container is at 94 % of its limit. **A resize of the instance and a larger disk are needed before the stack starts**; the course says to compare plans and record the recurring cost. Options and approximate prices are in the section below; they must be verified in the AWS console. The AI assistant does not stop, resize or change AWS resources unless BD authorizes that step; BD does the disk resize and the growth commands. | BD decides, with SD |
| G2 | **Hostname and DNS.** Proposed `support.ssw590-g1.tech` A record to 52.73.254.36 (TTL 300) at Name.com. | BD |
| G3 | **Elasticsearch prerequisite** on the host: `vm.max_map_count=262144` (now 65530), through `/etc/sysctl.d/99-zammad.conf`. Needs `sudo`, so a person runs it. | SD or BD |
| G4 | **Compose and scenario check.** Docker 25.0.14 and Compose v5.6.0 are installed (`!reset` syntax is supported). Record the exact `zammad-docker-compose` commit and its fixed image versions (no `latest`). | SD |
| G5 | **Proxy route.** Our proxy is the Caddy container on network `gitea_web`; the block is `support.ssw590-g1.tech { reverse_proxy zammad-nginx:8080 }`. Keep the scheme `https` in `.env`. SD drafts the block, BD applies it after the stack is healthy (backup, validate, reload, as in Assignment 8). | SD drafts, BD applies |
| G6 | **Secrets.** Unique generated credentials for the database and search; the real `.env` stays on the server and out of Git and the PDF (a sanitized example in the repo). The Zammad administrator and the TA password are set and typed by a person, never by the AI assistant, and the TA username and password are given **only in the Canvas submission text**. The manual's Passwords table holds hints only. | SD (Zammad accounts), BD (Hosts/Passwords tables) |
| G7 | **Firewall.** Security group `sg-0415c75429368eb85` today admits 80 and 443 from the world and SSH only from team addresses. No new public rule for Zammad. Test from outside that 8080, 5432, 9200, 6379 and 11211 are unreachable, for IPv4 and (if enabled) IPv6. | BD |
| G8 | **Backups.** Keep the upstream backup service enabled; identify its volume, confirm a backup was produced without exposing its contents, and document the matching release's restore guide (not a restore test). Do not delete any volume; never `docker compose down -v`. | SD |
| G9 | **TA access and evaluation window.** Role without administrator rights, group access to a Startup Support group, a checklist in the manual, and the service kept available through grading; revoke temporary access afterwards and record costs. | SD (account), BD (checklist/tables) |

## Capacity and cost options (to decide in G1; prices approximate, us-east-1 Linux on demand, verify in the AWS console before deciding)

| Option | Instance | Memory | Approximate cost | Comment |
|---|---|---|---|---|
| Stay | t3.medium (now) | 4 GB | already paid | does not meet Zammad's own guidance and has 1.8 GB available; not recommended |
| A | t3.large | 8 GB | about $0.083 per hour, about $61 per month | minimum we would try; Elasticsearch heap must be kept small; risk of memory pressure with Jenkins and Gitea |
| B | t3.xlarge | 16 GB | about $0.166 per hour, about $121 per month | meets the guidance of about 10 GB with room for Jenkins and monitoring; 4 vCPU |
| Disk | gp3 volume 20 GB to 60 GB | | about $0.08 per GB-month, about $3 per month extra | the stack's images and volumes need several GB; the current 3.5 GB free is not enough |

The instance runs around the clock; the assignment runs about two to three weeks, so option B costs roughly $60 to $90 and option A roughly $30 to $45 for that period. The resize needs a reboot (about 25 seconds of downtime for everything, as in Assignment 8); do it after Assignment 8 is submitted.
Do not disable earlier assignments to make room (course step 1).

## Timeline (proposal; all dates New York, 2026)
- **Nov 18-24:** finish and submit Assignment 8 (due Nov 24). Meanwhile only read-only work for Assignment 9: decide G1 and G2 on paper, SD reads Chapter 7 and drafts the Caddy block and the `.env` example, BD prepares the manual chapter skeleton.
- **Nov 25-27:** G1 resize and disk growth, DNS, `vm.max_map_count`, official stack up and healthy (rows 1, 2).
- **Nov 28-Dec 1:** Caddy route and certificate, external exposure tests, Zammad setup, TA account, three tickets, Gitea issue link (rows 2, 3, 4).
- **Dec 2-4:** Prometheus target, Grafana panels, controlled outage, persistence and backup checks (rows 1, 5).
- **Dec 5-6:** manual chapter, diagram, Hosts and Passwords tables, history; joint PDF build and read-through (row 6).
- **Dec 7:** Final Project Demo is due: do not leave Assignment 9 for the last two days.
- **Dec 8, 11:59 pm:** upload the PDF to Canvas with the TA username and password in the submission text.

## Working agreement (same as Assignments 6 to 8)
- Gitea is the source of truth; GitHub `assignment-9/` is the backup. Pull (`--rebase`) before every push; edit only your own regions. Non-secret deployment files (sanitized `.env` example, compose override notes, the Caddy block, Prometheus change, dashboard JSON) go into the `infra` repository through issue, branch and PR.
- No fabricated output, dates or screenshots. No tokens, passwords, keys, TA credentials or reset links in chat, Git, logs or the PDF. Use synthetic customer data only.
- No paid cloud change, firewall, DNS or AWS change by the AI assistant without the owner's explicit authorization for that step; BD does those. Never `docker compose down -v`, never prune volumes.
- Keep Gitea, Jenkins, Caddy, the monitoring stack and the Assignment 8 staging and production application working; Assignments 7 and 8 evidence stays valid. Re-test them after the install (step 11).
- Evidence numbering: **SD 250-279, BD 280-309**. Index in `evidence/README.md`.
- Hosts and Passwords tables are updated and named in the document-history entry (10-point deduction if missing).
