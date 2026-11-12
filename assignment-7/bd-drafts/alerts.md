# BD draft: Grafana-managed alert rules (row 6) and contact point

Status: DRAFT. Rule queries need the label selectors verified in queries.md. Secrets (webhook URL, SMTP password) never go into Git or screenshots.

## Rule 1: service unavailable (one rule, one alert per service)
- Name `https-service-down`; owner Brahmi Dalvi; severity label `critical`; folder `Group 1`; group `availability`, evaluation interval 30 s.
- Query A: `probe_success{job="https"}` (one series per URL, so Grafana raises one alert per `instance`).
- Condition: reduce A (last), IS BELOW 1.
- Pending period 1 m (the course asks for failing at least one minute). Expected detection: up to one scrape (30 s) plus one evaluation (30 s) plus the pending period (60 s), so about 1.5 to 2.5 minutes after the service stops.
- No data: NoData. Error: Error. (Set in Grafana as the states `NoData` and `Error`, not `Alerting`: Grafana then raises its own `DatasourceNoData` / `DatasourceError` alert instance through the same contact point, so a missing series or failed evaluation is reported as a monitoring failure, separate from a real service outage, and never treated as healthy. Verified on the saved rule, evidence 152.)
- Summary: `{{ $labels.instance }} failed its HTTPS probe for at least 1 minute`.
- Runbook link: the Jenkins outage runbook section of the manual (label set in row 7).
- Notification: contact point `team-alerts`.

## Rule 2: host root disk low
- Name `root-disk-below-15-percent`; owner Brahmi Dalvi; severity `warning`; group `capacity`, interval 1 m.
- Query A: `100 * node_filesystem_avail_bytes{mountpoint="/",fstype!~"tmpfs|overlay|squashfs"} / node_filesystem_size_bytes{mountpoint="/",fstype!~"tmpfs|overlay|squashfs"}` (selector verified in Explore first).
- Condition: IS BELOW 15 on A. Pending period 5 m. No data: NoData. Error: Error (as rule 1).
- Summary: `Root filesystem has less than 15% free`.
- Operator response (for the manual): `docker system df`; remove unused images only after checking they are not the runner's image (5.8 GB reclaimable, evidence 110); check Prometheus (1 GB cap) and Docker logs; never delete volumes.
- Test: temporarily set the threshold above the current free percentage (about 42% free now, since `df` shows 58% used, so use 55), wait through the 5 m pending period, record firing and delivery, then set it back to 15 and record resolution. Never fill the disk. Record the temporary change and the restore in the same evidence file.

## Contact point `team-alerts`
- Type: webhook (decided by BD, no SMTP needed). The receiver must be team-controlled and its URL is a secret: a private team chat channel with Grafana's dedicated integration for that service (for example Discord or Slack), not a generic webhook with a guessed JSON format. Both team members must be able to see the channel. Resolved notifications ON. The URL or SMTP credentials are entered only in the Grafana UI (stored in the grafana_data volume) and shown in the manual as a placeholder; the hint goes into the Hosts and Passwords table.
- Notification policy: default policy routes to `team-alerts`; group by `alertname` and `instance`; group wait 30 s, group interval 1 m, repeat interval 4 h (record the values actually set).
- Order: contact-point Test first, then the real rule runs.

## Timeline template for each real run (UTC and one local zone)
| Event | Time | Source |
|-------|------|--------|
| Condition injected / threshold changed | | command output or Grafana change history |
| First failing probe / evaluation | | Prometheus query or dashboard |
| Alert Pending, then Firing | | Grafana alert history |
| Notification received | | destination message |
| Fix (restart / threshold restored) | | command output |
| First successful probe / state Normal | | |
| Resolved notification | | |
