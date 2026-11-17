# Row 7 draft: monitoring the release (BD). NOT YET APPLIED.

Plan, written Nov 16, 2026 before the first successful release.

## What to add (after production exists)
The Chapter 5 Prometheus already probes two public URLs with the Blackbox Exporter (job `https`, module `http_2xx`).
Add the production health URL to the same target list in `~/monitoring/prometheus/prometheus.yml`:

```yaml
      - targets:
          - https://git.ssw590-g1.tech/user/login
          - https://ci.ssw590-g1.tech/login
          - https://app.ssw590-g1.tech/health        # added for Assignment 8 (production)
```

Then `docker compose up -d` is not needed; reload Prometheus (`curl -X POST http://localhost:9090/-/reload` from the server if the lifecycle flag is enabled, otherwise restart the container) and check `probe_success{instance="https://app.ssw590-g1.tech/health"} == 1`.

- **Staging is deliberately NOT probed**: the failed-deployment exercise breaks it on purpose; probing it would fire the existing `https-service-down` alert for a planned test. The limit is stated in the manual (staging health is checked by the pipeline's own Ansible checks, not by Prometheus).
- The existing alert rule `https-service-down` (any `https` target down for the 1-minute pending period) then also covers production with no new rule.
- Do the change in the infrastructure repository through a pull request (the file there is the Assignment 7 copy), then apply on the server; the live file and the repository copy must match (record the diff in evidence).

## What the rollback and the failed deploy look like in the monitoring (to measure, not to assume)
For each recovery run, record with timestamps: the moment the bad release starts (Jenkins/Ansible log), the first Prometheus sample where `probe_success` is 0 or the response body shows the wrong version, the moment recovery finishes, and the first sample back to 1 with the expected version. Sources: Prometheus query `probe_success`, `probe_http_status_code`, `probe_duration_seconds` for the production URL; Jenkins console times; Discord alert times if the alert fires.

## Limitations to state in the manual (honest list)
- A health probe answers 200 for v2 as well as v1: monitoring shows availability, not correctness of the price. Version and price are checked by the Ansible smoke test (`/`, `/price?quantity=3`).
- The scrape interval is 30 s and the alert needs a 1-minute pending period: a rollback that takes 20 s may not appear at all in the metrics.
- Staging is not monitored by Prometheus.
- The server is a single host: monitoring runs on the machine it watches (a host outage silences both).
