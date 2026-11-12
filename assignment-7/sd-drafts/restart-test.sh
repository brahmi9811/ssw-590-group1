#!/usr/bin/env bash
# Row 1 (and BD's row 7 verification): restart persistence test for Prometheus and Grafana.
# Run ON THE SERVER from ~/monitoring, after the Jenkins outage has recovered:
#   bash restart-test.sh | tee ~/monitoring/restart-test-$(date -u +%Y%m%dT%H%M%SZ).log
# Restarts the containers one at a time (docker restart). Volumes are never removed (no down -v, no volume rm).
# Shows: same volumes, the oldest stored sample unchanged, earlier probe samples still queryable, Grafana's
# dashboard / data source / alert rules / users still present (titles and counts only, read from a COPY of
# grafana.db; no passwords or tokens are read or printed), and the collection gap around the restart.
set -euo pipefail
ts() { date -u '+%F %T UTC'; }

pq() {  # Prometheus instant query -> "labels value" lines
  python3 - "$1" <<'EOF'
import json, subprocess, sys, urllib.parse
q = sys.argv[1]
url = "http://localhost:9090/api/v1/query?query=" + urllib.parse.quote(q, safe="")
out = subprocess.run(["docker", "exec", "prometheus", "wget", "-qO-", url], capture_output=True, text=True).stdout
for r in json.loads(out)["data"]["result"]:
    m = {k: v for k, v in r["metric"].items() if k != "__name__"}
    print("   ", m or "{}", r["value"][1])
EOF
}

grafana_state() {
  local tmp; tmp=$(mktemp -d)
  sudo cp /var/lib/docker/volumes/monitoring_grafana_data/_data/grafana.db "$tmp/g.db"
  sudo chown "$(id -u)" "$tmp/g.db"
  python3 - "$tmp/g.db" <<'EOF'
import sqlite3, sys
c = sqlite3.connect(sys.argv[1])
# Grafana 12+ keeps dashboards in unified storage (table resource), not the legacy dashboard table.
for label, sql in [("dashboards", "select json_extract(value, '$.spec.title') || ' (created ' || json_extract(value, '$.metadata.creationTimestamp') || ')' from resource where \"group\"='dashboard.grafana.app'"),
                   ("data sources", "select name || ' (' || type || ')' from data_source"),
                   ("alert rules", "select title from alert_rule"),
                   ("contact points (names only)", "select json_extract(r.value, '$.name') from alert_configuration a, json_each(json_extract(a.alertmanager_configuration, '$.alertmanager_config.receivers')) r"),
                   ("users", "select login || case when is_admin=1 then ' (server admin)' else '' end from user where login not like '%service-account%'")]:
    try:
        rows = [r[0] for r in c.execute(sql)]
        print(f"    {label}: {len(rows)}: {rows}")
    except Exception as e:
        print(f"    {label}: query failed ({e.__class__.__name__})")
EOF
  rm -rf "$tmp"
}

snapshot() {
  echo "--- $1 ($(ts)) ---"
  for c in prometheus grafana; do
    docker inspect "$c" --format "    {{.Name}} id={{slice .Id 0 12}} started={{.State.StartedAt}} restarts={{.RestartCount}} volumes={{range .Mounts}}{{if eq .Type \"volume\"}}{{.Name}} {{end}}{{end}}"
  done
  echo "  oldest stored sample (prometheus_tsdb_lowest_timestamp_seconds):"; pq 'prometheus_tsdb_lowest_timestamp_seconds'
  echo "  probe samples stored in the last 6 h:"; pq 'count_over_time(probe_success{job="https"}[6h])'
  echo "  Grafana state (from a copy of grafana.db):"; grafana_state
}

echo "=== Restart persistence test, started $(ts) on $(hostname) ==="
snapshot "BEFORE"

echo "--- docker restart prometheus ($(ts)) ---"
docker restart prometheus
for _ in $(seq 1 40); do docker exec prometheus wget -qO- http://localhost:9090/-/ready >/dev/null 2>&1 && break; sleep 3; done
echo "    prometheus ready at $(ts)"

echo "--- docker restart grafana ($(ts)) ---"
docker restart grafana
for _ in $(seq 1 60); do docker exec caddy wget -qO- http://grafana:3000/api/health >/dev/null 2>&1 && break; sleep 3; done
echo "    grafana healthy at $(ts)"

echo "--- waiting 70 s for two new scrapes ---"; sleep 70
snapshot "AFTER"
echo "  collection gap: probe samples in the last 5 min (expected about 10 per URL; fewer = the gap):"
pq 'count_over_time(probe_success{job="https"}[5m])'
echo "  targets now:"; pq 'up'
echo "=== finished $(ts) ==="
