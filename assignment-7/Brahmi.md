# BRAHMI (BD) — Assignment 7 scope and plan

Read `README.md` first. Course manual V1.42 Chapter 5 is the source of truth.

## BD owns: rows 4, 6, 7, 8 (50 points)
- **Row 4 — Dashboard (15).** One named team dashboard with explicit time zone, units, legends, thresholds and the six required panels:
  whole-host CPU % (rate-based, averaged across CPUs), available memory (state the unit), root-filesystem free % (avail / size of the
  verified filesystem), Gitea `probe_success`, Jenkins `probe_success`, probe duration for both (separate labeled lines). Explain each
  query. Export the dashboard JSON and version it in Gitea. Capture host metrics before/during/after one normal Jenkins build (build ID,
  commit, start/end, executed on the controller) and explain what changed or why nothing was visible.
- **Row 6 — Alerts (15).** Two Grafana-managed rules, each with owner, severity, query, threshold, evaluation interval, pending period,
  summary, runbook link, no-data/error policy: (1) service unavailable per service, probe failing ≥ 1 min; (2) root disk < 15 % free
  for 5 min. Contact point `team-alerts` (webhook or email; secret out of Git), grouping/delay settings recorded. Real firing, delivery
  and resolution for both; capacity alert tested by **temporarily raising the threshold above the current value**, then restoring 15 %.
- **Row 7 — Incident (10).** Agreed maintenance window; stop only Jenkins for about 3 minutes (no volumes touched); timeline of injection,
  first failing probe, alert firing, notification, acknowledgement, restart, first successful probe, resolved notification; detection and
  restoration times; verify Jenkins HTTPS, a passing pipeline, Gitea, webhook/status and the manual build; compare with Assignment 6's
  failed-build demo; blameless review; two improvement issues in Gitea with owners (include the shared-server limitation).
- **Row 8 — Manual (10).** Version 1.2 → **1.3**, dated history entry naming Hosts/Passwords changes (Grafana host/DNS, monitoring
  containers and private ports, Grafana admin hint, contact-point secret hint), glossary (SRE, SLI, SLO, SLA, error budget, Prometheus,
  Grafana, exporter, probe), citations, AI/reuse attribution, link to the successful PDF build and the reviewed final commit; final scan.

## Also BD's (server owner)
- **G1 capacity decision** and any resize/stop/start (paid); DNS record for the Grafana hostname; applying the Caddy block after review;
  security-group verification; Hosts and Passwords tables; final build and submission.

## Checklist
- [x] G1 decided (t3.small, evidence 140) · [x] DNS for Grafana (evidence 141) · [x] Caddy block applied (evidence 141; outside-access test pending) · [ ] dashboard (6 panels; JSON drafted in monitoring/grafana, to import and re-export) + JSON in Gitea · [ ] normal-build comparison
- [ ] two alert rules + contact point · [ ] both alerts fired, delivered, resolved · [ ] capacity test and restore
- [ ] controlled Jenkins outage + timeline · [ ] blameless review + 2 issues · [ ] row 8 pass, version 1.3 · [ ] final PDF from green run
