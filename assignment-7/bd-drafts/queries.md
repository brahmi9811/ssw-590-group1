# BD draft: dashboard queries (row 4) and metric inventory (course Steps 3 and 5)

Status: DRAFT written before Grafana runs. Every label marked VERIFY must be checked in Grafana Explore on the real server and compared
with `free -b` and `df -B1 /` before the dashboard JSON is exported.

| # | Panel | Query | Unit | Thresholds | Why it is written this way |
|---|-------|-------|------|-----------|----------------------------|
| 1 | Whole-host CPU % | `100 * (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[2m])))` | percent (0-100) | yellow 70, red 90 | `node_cpu_seconds_total` is a counter of seconds per CPU and mode. rate() gives seconds per second, avg() averages the 2 CPUs, and 1 minus the idle share is the busy share. Lifetime totals are never graphed. Whole host, not per container. |
| 2 | Available memory | `node_memory_MemAvailable_bytes` | bytes (IEC) | red below 200 MiB | MemAvailable is the kernel's estimate of memory applications can still get; it is not "free" memory. Compare with the "available" column of `free -b`. |
| 3 | Root filesystem free % | `100 * node_filesystem_avail_bytes{mountpoint="/",fstype!~"tmpfs|overlay|squashfs"} / node_filesystem_size_bytes{mountpoint="/",fstype!~"tmpfs|overlay|squashfs"}` | percent | red below 15 | Avail (usable by normal processes) divided by the size of the same series. VERIFY: with `--path.rootfs=/host` Node Exporter should report mountpoint="/", device /dev/nvme0n1p1 and fstype xfs; if it shows /host or another device, fix the selector, never average mounts. |
| 4 | Gitea HTTPS availability | `probe_success{job="https",instance="https://git.ssw590-g1.tech/user/login"}` | 0/1 (map 1=UP, 0=DOWN) | red at 0 | Success means DNS, TLS verification, allowed redirects and the expected final status all passed. A login-page probe does not prove Git push or a working build; say so in the manual. |
| 5 | Jenkins HTTPS availability | `probe_success{job="https",instance="https://ci.ssw590-g1.tech/login"}` | 0/1 | red at 0 | Same; /login is the page Jenkins shows to everyone. |
| 6 | Probe duration, both services | `probe_duration_seconds{job="https"}`, legend `{{instance}}` | seconds | yellow 1, red 3 | One labeled line per URL. Shows slow responses before a failure. |
| extra | Scrape health | `up` (table or stat) | 0/1 | red at 0 | `up` means the scrape worked. `up{job="https"}` can be 1 while `probe_success` is 0: collection worked, the probed request failed. |

Dashboard settings: title "Group 1 Startup Server (SRE)", time zone fixed (America/New_York; manual times then name the zone or give UTC),
default range last 3 hours, refresh 30 s, legends on panels 1, 2 and 6. Data source: Prometheus at `http://prometheus:9090` (the private
service name; `localhost` inside the Grafana container is not Prometheus).

## Metric inventory (Step 3 table for the manual)

| Metric | Type | Unit | Key labels | Meaning | Limitation |
|--------|------|------|-----------|---------|-----------|
| `node_cpu_seconds_total` | counter | seconds | cpu, mode | CPU time per core and mode | Lifetime counter, needs rate(); whole host only |
| `node_memory_MemAvailable_bytes` | gauge | bytes | none | Estimate of memory available to applications | Not unused RAM; an estimate |
| `node_memory_MemTotal_bytes` | gauge | bytes | none | RAM seen by the kernel | 1909 MiB on t3.small (evidence 140) |
| `node_filesystem_avail_bytes` / `node_filesystem_size_bytes` | gauge | bytes | mountpoint, device, fstype | Space usable by normal users / total size | Must select the real root filesystem; overlay and tmpfs excluded |
| `up` | gauge | 0/1 | job, instance | Last scrape of the target succeeded | Says nothing about the probed service |
| `probe_success` | gauge | 0/1 | job, instance | The probe's whole check passed | Login page only; not a Git operation or a build |
| `probe_duration_seconds` | gauge | seconds | job, instance | Time taken by the probe request | Includes DNS, TLS and redirects |

## Checks to run once Prometheus has data (each saved as evidence)
1. Compare the dashboard values with `free -b` (MemTotal, available) and `df -B1 /` (size, avail) (Step 3.2).
2. Query `node_filesystem_size_bytes` with no selector, list every mountpoint, device and fstype, and name the one used.
3. One normal Jenkins build on the controller: note build ID, commit, start and end (from the build page) and that it ran on the controller.
   With a 30 s scrape a 5 to 20 s build may fall between two scrapes; if nothing is visible, say so. No synthetic load.
