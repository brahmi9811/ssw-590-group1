#!/usr/bin/env bash
# Row 5: SLI for a real short window (the one around BD's controlled Jenkins outage).
# Run ON THE SERVER (anywhere), with the window in UTC:
#   bash sli-window.sh 2026-11-13T15:00:00Z 2026-11-13T15:30:00Z | tee ~/monitoring/sli-window-$(date -u +%Y%m%dT%H%M%SZ).log
# Prints, for each probed URL: samples expected vs received, successes, failures, the SLI (%), the 99 % budget for
# this window, and the exact PromQL with its evaluation time, so the numbers can be re-run and checked.
# Missing samples are reported separately and never counted as successes.
set -euo pipefail
START="${1:?start, e.g. 2026-11-13T15:00:00Z}"; END="${2:?end, e.g. 2026-11-13T15:30:00Z}"
python3 - "$START" "$END" <<'EOF'
import datetime as dt, json, subprocess, sys, urllib.parse
start, end = sys.argv[1], sys.argv[2]
p = lambda s: dt.datetime.strptime(s, "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=dt.timezone.utc)
t0, t1 = p(start), p(end)
secs = int((t1 - t0).total_seconds()); assert secs > 0
W = f"{secs}s"
def q(expr, at):
    url = ("http://localhost:9090/api/v1/query?query=" + urllib.parse.quote(expr, safe="") + "&time=" + str(at.timestamp()))
    out = subprocess.run(["docker", "exec", "prometheus", "wget", "-qO-", url], capture_output=True, text=True, check=True).stdout
    return {r["metric"].get("instance", ""): float(r["value"][1]) for r in json.loads(out)["data"]["result"]}
sel = 'probe_success{job="https"}'
exprs = {"received": f"count_over_time({sel}[{W}])",
         "successes": f"sum_over_time({sel}[{W}])",
         "sli_percent": f"100 * avg_over_time({sel}[{W}])"}
res = {k: q(e, t1) for k, e in exprs.items()}
expected = round(secs / 30)
print(f"Window: {start} to {end} ({secs} s = {secs/60:.1f} min); evaluation time = window end ({end})")
print(f"Scrape interval 30 s -> expected samples per URL: about {secs} / 30 = {expected} (+/-1 from scrape timing at the window edges)")
print("PromQL (range [W] ends at the evaluation time):")
for k, e in exprs.items(): print(f"  {k:12s} {e}")
print()
for inst in sorted(res["received"]):
    n = int(res["received"][inst]); s = int(res["successes"].get(inst, 0)); f = n - s
    sli = res["sli_percent"].get(inst, float("nan"))
    budget = 0.01 * n
    print(f"{inst}")
    print(f"  received {n} of about {expected} expected (missing {max(0, expected - n)}; missing samples are unknown, not success)")
    print(f"  successes {s}, failures {f}, SLI = 100 * {s}/{n} = {sli:.2f} %")
    print(f"  99 % SLO for this window allows {budget:.2f} failed samples; used {f} -> {'within' if f <= budget else 'over'} budget")
print()
print("Raw failing samples (time UTC, URL), from probe_success == 0 in the window:")
url = ("http://localhost:9090/api/v1/query_range?query=" + urllib.parse.quote(sel, safe="") +
       f"&start={t0.timestamp()}&end={t1.timestamp()}&step=30s")
out = json.loads(subprocess.run(["docker", "exec", "prometheus", "wget", "-qO-", url], capture_output=True, text=True, check=True).stdout)
for r in out["data"]["result"]:
    bad = [dt.datetime.fromtimestamp(float(t), dt.timezone.utc).strftime("%H:%M:%S") for t, v in r["values"] if v == "0"]
    print(f"  {r['metric']['instance']}: {len(bad)} failing steps: {bad[0] + ' .. ' + bad[-1] if bad else 'none'}")
print("Note: query_range steps are a 30 s grid view for the timeline; the SLI above uses the stored samples.")
EOF
