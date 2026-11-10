# Assignment 7 — Introduction to SRE: Monitoring and Reliability (course manual Chapter 5)

Group 1: Brahmi Dalvi (BD), Sakshi Deshpande (SD). **Due: see Canvas** (fill in the date here when known).

Source of truth: **Chapter 5 of the DOS manual V1.42** (`assignment-7/dosManual-V1.42.pdf`, manual pages 23–39; PDF pages 37–53),
plus the common rules in Chapter 1 and Appendix A. If anything here conflicts with the course manual, the manual wins.

**Submit only the compiled PDF** of the IT manual (version increased to **1.3**), taken from a green Gitea Actions run, as in Assignments 5 and 6.

## The assignment in short
Add **monitoring and a first SRE practice** to the platform we already run (Gitea, Jenkins, the manual build), on the same server:
1. **Four new containers** from project-published images, with Docker Compose: **Prometheus**, **Grafana OSS**, **Node Exporter**,
   **Blackbox Exporter**. Pinned tags + recorded digests (never `latest`), persistent volumes, private ports only, no Docker socket.
2. **Metrics and probes:** Prometheus scrapes itself, Node Exporter (whole-host CPU / memory / root disk) and Blackbox Exporter;
   Blackbox probes the real **Gitea and Jenkins HTTPS login URLs** every 30 s.
3. **Grafana** behind the existing Caddy with its own HTTPS hostname (e.g. `metrics.ssw590-g1.tech`), login required, no anonymous access.
4. **One team dashboard with six panels** (CPU %, available memory, root-disk free %, Gitea probe, Jenkins probe, probe duration),
   versioned in Gitea, plus host metrics before/during/after one normal Jenkins build.
5. **SLI / SLO / SLA:** explain the manual's worked example (2,880 probes, 99 % target) and evaluate a real short window around the outage.
6. **Two Grafana-managed alerts** (service unavailable; root disk < 15 % free) to a team contact point, each actually fired, delivered and resolved.
7. **Controlled incident:** stop only Jenkins for about 3 minutes, record detection and recovery times, verify recovery, blameless review,
   two improvement issues with owners.
8. **Manual:** new chapter *Introduction to SRE: Monitoring and Reliability* with 8 evidence sections in rubric order, version, history,
   Hosts/Passwords hints, glossary, citations, AI attribution, link to the green PDF build and reviewed final commit.

## Rubric (100 points) and owners (50 / 50)
| # | Rubric row (V1.42, section 5.5) | Pts | Owner |
|---|---|---|---|
| 1 | **Deployment:** baseline/versions/capacity/retention (4); accurate diagram (4); repeatable configuration and persistent storage (4); verified restart persistence (3) | 15 | **SD** |
| 2 | **Metrics/probes:** private host/exporter/self scrapes and collection health (6); HTTPS probes for both services with defined success (5); inventory and host verification (4) | 15 | **SD** |
| 3 | **Access control:** authenticated Grafana and retained Gitea/Jenkins HTTPS (4); private ports/routes, secret handling, external exposure evidence (6) | 10 | **SD** |
| 4 | **Dashboard:** six required panels with correct queries, labels, units (8); versioned dashboard definition (3); explained normal-build comparison (4) | 15 | BD |
| 5 | **SLI/SLO:** SLI/SLO/SLA definitions (3); explained worked-example arithmetic (3); reproducible short-window evidence, sample coverage, missing-data interpretation, limits (4) | 10 | **SD** |
| 6 | **Alerts:** two meaningful rules with owners, response steps, timing/no-data policy (6); actual firing, delivery, resolution of both (7); safe capacity test and restored settings (2) | 15 | BD |
| 7 | **Incident:** safe execution and correlated timeline (4); measured response and verified service/CI recovery (3); blameless review, build-failure distinction, owned improvements (3) | 10 | BD |
| 8 | **Manual:** coherent instructions and current history/tables (4); reviewed source and successful PDF-build links (3); clear evidence, glossary, citations, attribution (3) | 10 | BD |

**SD = 50 (rows 1, 2, 3, 5). BD = 50 (rows 4, 6, 7, 8).**
Why this split: SD was asked to take the first half. Rows 1–3 are 40 points and row 4 is 15, so an exact 50 is rows 1, 2, 3 plus row 5
(the SLI/SLO row, which is built directly on SD's probe data). BD takes the dashboard, alerts, incident and the final manual pass.
Rows 1–3 touch the server, DNS and firewall that BD administers, so those specific actions are **hand-offs** (see below).

## Decisions and gates
| Gate | What | Who | Notes |
|---|---|---|---|
| **G1** | **Capacity.** Read-only check on Nov 10, 2026: EC2 **t3.micro** (2 vCPU, **913 MB RAM**), **about 207 MB available**, **423 MB already in swap**, root disk 20 GB with 8.4 GB free. Running containers: gitea 113 MB, jenkins 272 MB (640 MB limit), caddy 21 MB, gitea-runner 14 MB. Prometheus + Grafana + two exporters need roughly 250–400 MB more. Options: (A) resize to `t3.small` (2 GB; **check the current price first**), (B) stop the Assignment 5 Actions runner only while not needed and tune retention/memory limits, (C) both. Any resize, stop or start is **BD's manual step** (paid / AWS). The manual says: if capacity requires a different deployment, document and justify it, including cost. | **BD decides** | blocks deploying the stack (row 1) |
| G2 | DNS `A` record for the Grafana hostname (e.g. `metrics.ssw590-g1.tech`) at Name.com | BD (registrar account) | free; same pattern as `git` and `ci` |
| G3 | Caddy site block for the Grafana hostname → `127.0.0.1:3001` (or `grafana:3000` on the proxy network); certificate issued | SD drafts the block, BD reviews/applies (Caddy is shared by Gitea and Jenkins) | do not break Gitea/Jenkins routing |
| G4 | Security group stays as is: no new public ports (9090, 9100, 9115, 3001 stay private) | BD verifies | row 3 external tests |
| G5 | Contact point for alerts (webhook or email); secret kept out of Git | BD (row 6) | SD needs nothing from it |
| G6 | Maintenance window for the Jenkins outage (row 7) | BD + SD agree | no build running |

## Image candidates (looked up Nov 10, 2026; re-check and record digests when pulling)
| Container | Image repository (project-published) | Newest stable tag seen |
|---|---|---|
| Prometheus | `prom/prometheus` (Docker Hub) | `v3.16.0` |
| Grafana OSS | `grafana/grafana` (Docker Hub; not the old `grafana/grafana-oss`) | `13.3.1` |
| Node Exporter | `quay.io/prometheus/node-exporter` | `v1.12.1` |
| Blackbox Exporter | `quay.io/prometheus/blackbox-exporter` | `v0.29.1` |
Server architecture is `x86_64` (amd64). Record each image's `RepoDigests` after `docker compose pull`.

## Evidence numbering
`assignment-7/evidence/`: **SD 110–139, BD 140–169**, each with a row in `evidence/README.md`. Copy the files used by the PDF into the
Gitea manual repo's `evidence/` folder so it builds on its own.

## Working agreement (same as Assignments 4–6)
1. `git pull --rebase` before you start and before you push. The manual's source of truth is the Gitea repo `group1-startup/manual`
   (`assignment-5/manual-repo/` here is only its mirror). Monitoring configuration goes in Gitea (e.g. `group1-startup/infra`, `monitoring/`),
   through an issue, a branch and a reviewed pull request.
2. Edit only your own rows/regions of the new chapter; for the other person's area, send a message.
3. Never fabricate output, screenshots, dates or results. Unrun = `\StatusPending`. Failed attempts are documented.
4. Never put passwords, tokens, webhook URLs with secrets, SMTP credentials or private keys in chat, Git, logs or the PDF.
5. No paid cloud change, firewall change, DNS change, or stop/start/resize of AWS resources by the AI assistant; BD does those manually.
6. Never `docker compose down -v` on the server (it deletes named volumes). Use `stop`/`start`.
7. Keep Gitea, Jenkins and the manual build working throughout; the earlier assignments must stay gradable.
