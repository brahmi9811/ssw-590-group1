# Brahmi (BD): rows 2, 5, 6 = 50 points

## Scope
- **Row 2 (20) HTTPS and exposure.** DNS record for the support hostname; apply SD's Caddy block to the existing Caddy (backup, validate, graceful reload); trusted certificate that matches the hostname; HTTP redirects to HTTPS; `NGINX_SERVER_SCHEME=https` verified (login and CSRF work, no `-k`); security group unchanged (80 and 443 public, SSH limited); **external tests** that 8080, 5432, 9200, 6379 and 11211 are unreachable on the public address (IPv4 and, if enabled, IPv6), and which controls enforce it; resolved Compose config shows no published internal ports.
- **Row 5 (20) Monitoring and recovery.** Append the Zammad URL to the existing `https` job in Prometheus (`/probe`, `http_2xx`, relabeling unchanged), validate with `promtool`, restart Prometheus (single-file bind mount: restart, not reload); three new panels in the existing Grafana dashboard with the exact titles *Zammad HTTPS reachable (0/1)*, *Zammad probe duration (seconds)*, *TLS certificate remaining lifetime (days)*; reuse the Node Exporter panels to compare capacity before and after; **controlled outage**: `docker compose stop zammad-nginx` from the Zammad directory, at least two failed probes (so about 70 seconds or more at the 30-second scrape), start it again, ticket and conversation still there; distinguish exporter `up` from `probe_success`. Dashboard JSON exported into the `infra` repository.
- **Row 6 (10) Operational documentation.** The manual chapter *Support Desk (Zammad)*: deployment diagram (adapted from course Figure 7.1), numbered runbook, service inventory, storage and backup locations, start/recovery commands, links to non-secret files in Gitea, TA checklist; **Hosts table and Passwords hints-only table updated** (10-point deduction if stale); document-history entry that names the table changes; capacity and cost record; limitations without claiming untested things. SD's regions are cited, not rewritten.
- **Gate G1** capacity and cost decision with SD; **G2** DNS; **G5** applying the Caddy block; **G7** firewall.

## What the AI assistant does and does not do (BD's standing rules)
- It prepares drafts, reads the server (read-only) and records evidence; commits for this assignment need BD's explicit authorization (given per assignment).
- BD does or explicitly authorizes: instance resize, disk growth, DNS records, security group changes, `sudo` changes (`vm.max_map_count`), stopping or starting containers for the outage test, any password, token or key.

## Inputs from SD I need
- The stack up and healthy (`docker compose ps -a`) and the container name and port of the nginx service (expected `zammad-nginx:8080`).
- The Caddy block draft in `sd-work/` and the chosen hostname.
- Example ticket numbers (for the persistence check) and the TA account name and role (for the checklist).

## Baseline already taken (read-only, Nov 17, 2026 evening New York)
t3.medium, 2 vCPU, 3,835 MiB RAM (1,837 MiB available), swap 2,047 MiB (246 MiB used), disk 20 GB with 3.5 GB free (83 %), `vm.max_map_count` 65530, Docker 25.0.14, Compose v5.6.0, Caddy on `gitea_web`, no internal service ports published. Evidence 280.

## Checklist
- [ ] G1 capacity and cost decided and recorded (resize, disk to 60 GB, cost table) · [ ] G2 DNS `support.ssw590-g1.tech` · [ ] G7 SG reviewed
- [ ] Caddy block applied, certificate trusted, redirect, scheme https (row 2) · [ ] external port tests, IPv4 and IPv6 (row 2)
- [ ] Prometheus target added and promtool-checked · [ ] three panels with exact titles · [ ] host panels before/after (row 5)
- [ ] controlled outage: probe 0 then 1, ticket kept (row 5) · [ ] dashboard JSON in infra repo
- [ ] manual chapter skeleton · [ ] diagram · [ ] runbook · [ ] Hosts table · [ ] Passwords hints table · [ ] history entry · [ ] TA checklist (row 6)
- [ ] earlier services re-tested (Gitea, Jenkins, Grafana, Assignment 8 application) · [ ] joint PDF build and upload with TA credentials in the Canvas text only
