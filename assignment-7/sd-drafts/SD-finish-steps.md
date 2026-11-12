# SD: how to finish rows 1, 2, 3, 5 (Assignment 7)

Already done: deployment, digests, targets, probes, host check, access tests (evidence 110-114), infra PR #2 merged
(c03fb1b), deployment diagram, rows 1-3 and 5 drafted and test-built (`devopsSre-sd-rows-1-2-3.tex`, `row5-sli-slo-draft.tex`).

What is left needs **campus** (SSH and full Grafana work only from the team list) and **Brahmi** (outage time, chapter file).

## Step 1 - Change your Grafana password (row 3) - on campus, 2 minutes
1. Open https://metrics.ssw590-g1.tech/login, sign in as `sakshi` with the temporary password from Brahmi.
2. Avatar (top right) -> **Profile** -> **Change password**. Type the new one yourself; never paste it in chat.
3. Tell Claude the date. It replaces the `\Todo{date SD changed it}` in row 3.

## Step 2 - Before the outage (agreed time with Brahmi) - on campus
1. Tell Claude "on campus"; it checks SSH works (`ssh -i ~/.ssh/ssw590-g1-sakshi ec2-user@git.ssw590-g1.tech`).
2. Claude copies the two scripts to the server: `scp restart-test.sh sli-window.sh ...:monitoring/`.
3. Note the **window start**: about 10 minutes before Brahmi's `docker stop jenkins` (UTC). The window ends about
   10 minutes after the first successful probe. A 30-minute window gives about 60 samples per URL.

## Step 3 - During the outage (Brahmi drives, you record)
- Brahmi runs `docker stop jenkins`, waits about 3 minutes, runs `docker start jenkins` (her runbook).
- You watch dashboard panel 5 and the Discord channel; write down when you saw each change (UTC):
  panel 5 turns red, alert Firing message, Jenkins back, Resolved message.

## Step 4 - Restart test (row 1, shared with Brahmi's row 7) - right after Jenkins is back
```bash
cd ~/monitoring && bash restart-test.sh | tee ~/monitoring/restart-test-$(date -u +%Y%m%dT%H%M%SZ).log
```
It restarts Prometheus, then Grafana (never `down -v`), and shows before/after: same volumes, oldest sample unchanged,
earlier probe samples still stored, dashboard / data source / alert rules / contact point / users still there, and the
collection gap. Tested on a local copy of the stack on Nov 11. Claude saves the log as the next SD evidence (115).

## Step 5 - Real SLI window (row 5) - when the window has ended
```bash
bash ~/monitoring/sli-window.sh <START>Z <END>Z | tee ~/monitoring/sli-window-$(date -u +%Y%m%dT%H%M%SZ).log
```
(times in UTC, e.g. `2026-11-13T15:00:00Z`). It prints the exact PromQL, the evaluation time, samples received vs
expected, successes, failures, SLI for Gitea and Jenkins, and the 99 % budget for that window. Claude saves it as
evidence 116 and writes the "Our short window" paragraph of row 5 (Jenkins should miss 99 % in that window, about 3 min of
6 failing samples out of 60; say why a 30-minute window cannot establish a 24-hour SLO).

## Step 6 - Move your sections into the manual (after Brahmi pushes `devopsSre.tex`)
1. `git pull --rebase` in `~/Downloads/group1-manual`.
2. Claude replaces only the SD regions (sreDeployment, sreMetrics, sreAccess, sreSlo) with the drafts and copies
   `config/monitoring/`, `TikZ/devopsSre/`, evidence 110-116, and the bib entry `GoogleSREWorkbookSLO`.
3. Build with `ci/local-build.sh`; no undefined references allowed.
4. Commit and push to `main` of the manual repo; mirror to GitHub (`assignment-7/`).
5. Tell Brahmi; she runs the final Gitea Actions build. Do not push after her "final build" message.

## Step 7 - Final check
Open the final PDF from Gitea Actions and check rows 1, 2, 3, 5: no `TODO` left, every listing and figure present,
status markers PASS, the PR #2 link opens.
