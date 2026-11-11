# BD draft: controlled Jenkins outage (row 7) and recovery

Status: DRAFT. Run only after the alert rules and contact point are tested, and with the window agreed with Sakshi.
The server owner stops and starts the container herself.

## Before
1. Agree the window with SD in writing (time, about 3 minutes, no builds running). Check Jenkins' Build Executor Status is idle.
2. Start the timestamped incident record (UTC and one local zone). Recovery command: `docker start jenkins` (data stays in volume `jenkins_jenkins_home`; never `down -v`, never touch volumes).
3. Confirm Gitea and monitoring are healthy (dashboard green).

## During
```
date -u '+%F %T UTC'; docker stop jenkins      # injection
# dashboard panel 5 turns 0; alert Pending, then Firing; notification arrives; acknowledge it
date -u '+%F %T UTC'; docker start jenkins     # after about 3 minutes (at most 5)
```
Record: injection, first failing probe, alert firing, notification receipt, acknowledgement, restart, first successful probe, resolved notification.
Detection time = injection to notification receipt; restoration time = injection to first successful probe (name the start and end events).
Compare with the settings: scrape 30 s, evaluation 30 s, pending 60 s, group wait 30 s.

## After (verification)
- Jenkins `/login` returns 200; a passing pipeline (re-run `main` or a PR job); Gitea returns 200; webhook delivery and the `twintrack/pipeline/pr-main` and `head` statuses still reach Gitea; the manual build on the Gitea Actions runner.
- Restart Prometheus and Grafana one at a time (`docker restart prometheus`, then `docker restart grafana`). Earlier time series, dashboard, data source and alert rules must still be there; note the collection gap. This shows persistence, not a backup restore.
- Compare in the manual with Assignment 6: that failure was a bad commit stopped by the merge gate (evidence 96 to 101); this one is an outage of the CI service itself, found by monitoring.

## Blameless review outline
Impact (Jenkins unavailable for N minutes; team users only) · timeline · evidence · cause (deliberate injection) · response · measurement gaps (30 s scrape; the only probe runs on the same host, so a host outage would also take monitoring down) · two prioritized improvement issues in Gitea with owners: one is the shared-server limitation (monitoring on the monitored host; add an off-host probe), the other a backup of the Grafana and Prometheus volumes or a scheduled notification test.
