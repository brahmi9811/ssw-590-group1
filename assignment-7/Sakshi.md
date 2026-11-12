# SAKSHI (SD) — Assignment 7 scope and plan

Read `README.md` first. Course manual V1.42 Chapter 5 is the source of truth.

## SD owns: rows 1, 2, 3, 5 (50 points)
- **Row 1 — Deployment (15).** Baseline of the server (CPU, RAM, disk, OS, services, versions; one normal Jenkins build observed);
  pinned images and digests; capacity and retention rationale (7 days if it fits); the **adapted deployment diagram** (course Figure 5.1)
  showing the four new containers, Gitea, Jenkins, Caddy, networks and volumes; Compose + config in Gitea through issue/branch/PR;
  startup/update/recovery instructions; persistent paths; **restart test** of Prometheus and Grafana (persistence, not a backup).
- **Row 2 — Metrics and probes (15).** Scrape config (prometheus, node, blackbox, https jobs; 30 s); target health (`up`);
  HTTPS probes of `https://git.ssw590-g1.tech/user/login` and `https://ci.ssw590-g1.tech/login` with **defined success**
  (DNS, valid TLS, allowed redirects, final 2xx); `probe_success` and `probe_duration_seconds` for both; small metric inventory
  (name, type, unit, labels, meaning, limitation); **verify host values** against `free -b` and `df -B1 /` and identify the real root
  filesystem labels (mountpoint/device/fstype under `/host`).
- **Row 3 — Access control (10).** Grafana behind Caddy at its own HTTPS hostname, login required, anonymous off, sign-up off, initial
  admin password replaced (hint only in Passwords table); Gitea/Jenkins HTTPS still working; raw ports 9090/9100/9115/3001 private;
  **external exposure tests** from outside the server (and a second network) over IPv4; secret handling explained.
- **Row 5 — SLI / SLO / SLA (10).** Definitions; the manual's **worked example** explained in our own words (2,880 probes; Gitea 100 %;
  Jenkins 2,850/2,880 = 98.96 % misses 99 %; budget 28.8 samples = 14.4 min; 30 failures exceed it by 1.2 samples); then the **real short
  window** around BD's Jenkins outage: exact start/end, time zone, scrape interval, evaluation time, `avg_over_time(probe_success[..])`
  and `count_over_time` vs. the expected ~20 samples per 10 min, missing-data interpretation, limits (a short window is not the 24 h SLO).

## Hand-offs with BD
1. **G1 capacity decision** (BD) before anything is deployed. Until then SD only prepares files and baseline evidence.
2. **DNS record** for the Grafana hostname (BD, Name.com) and **review of the Caddy block** (Caddy is shared).
3. Row 5's real window needs **BD's controlled Jenkins outage** (row 7): agree a time; SD records the window and queries.
4. SD's rows 1–3 are inputs to BD's dashboard and alerts (rows 4, 6): tell BD the exact metric names and root-filesystem labels.

## Can start now (no server change)
1. Baseline evidence (read-only on the server) — evidence 110+.
2. Choose and verify the four image tags (see `README.md`), record why.
3. Draft `monitoring/compose.yaml`, `.env`, `prometheus/prometheus.yml`, `blackbox/blackbox.yml` from the course manual, adapted to our
   hostnames, with memory limits suitable for a 1 GB host; validate locally (`docker compose config`, `promtool check config`).
4. Draft the Caddy site block for Grafana and the adapted deployment diagram (TikZ).
5. Create the Gitea issue and branch for the monitoring work (issue-linked PR, BD reviews).
6. Write the row 5 worked-example explanation (needs no measurements).

## Progress (Nov 10, 2026)
- Baseline collected read-only (evidence 110). **Capacity is the blocker (G1):** 200 MiB available, 425 MiB swapped; BD decides.
- Tags chosen and amd64 digests recorded (evidence 111).
- Drafts in `assignment-7/monitoring/`: `compose.yaml` (no published ports; Grafana on `monitoring` + existing `gitea_web`;
  memory caps 256/256/64/64 MiB; Prometheus retention 7d and 1 GB), `.env.example`, `prometheus/prometheus.yml`,
  `blackbox/blackbox.yml` (TLS verification on, IPv4, https only), `caddy-metrics-block.txt` for BD's review.
  All validated locally (evidence 111). Nothing deployed.
- Row 5 worked example drafted with checked arithmetic: `sd-drafts/row5-sli-slo-draft.tex`.

### Update (Nov 10, ~22:20 EST)
- G1 resolved by BD (t3.small, evidence 140); DNS + Caddy block applied by BD (evidence 141).
- Stack deployed from `~/monitoring` (evidence 112): four containers Up, no host ports, digests match 111, all targets up, both probes 1/200,
  host values match `free -b` / `df -B1 /`.
- Two changes to the reviewed compose, both recorded in 112: (1) Grafana's first admin password comes from a random server-only
  secret file, so `admin/admin` was never active on the public login page; BD replaces it with `grafana cli admin reset-admin-password`;
  (2) Grafana memory cap 256m -> 384m (216 MiB at idle).
- Access control tested (evidence 113): non-team sees only the login page and its assets, everything else 403; monitoring ports closed.
  Still to do: phone test on mobile data, then sign-in with own account after BD sets the admin password.

## Checklist
- [x] baseline evidence · [x] image tags chosen · [x] monitoring files drafted and validated locally · [ ] Gitea issue + branch + PR
- [x] G1 decided by BD · [x] stack deployed, digests recorded · [x] targets up, probes defined, host values verified
- [x] Grafana HTTPS, external exposure tests (phone test + own login pending) · [ ] restart persistence test · [x] deployment diagram drafted (sd-drafts/TikZ)
- [x] row 5 worked example · [ ] row 5 real window (after BD's outage) · [ ] rows 1, 2, 3, 5 written in the chapter with inline evidence
