# Brahmi (BD): rows 4, 5, 6, 7 = 50 points

## Scope
- **Row 4 (15)** Jenkins gates, restricted recorded approval (`input` with named submitters and a timeout), verified v2
  promotion; `disableConcurrentBuilds`; delivery stages only on `main` on the trusted agent.
- **Row 5 (15)** security scan policy written before the release (block secrets and high/critical findings unless a
  documented, time-limited exception), tool and database versions, reports and exit codes (Trivy image + secret scan,
  pip-audit), one blocked pipeline with a scanner-supported synthetic fixture (never a live secret), fail on scanner
  errors; credential and access controls (Jenkins credentials, deploy account, registry tokens, no Docker socket to PR jobs).
- **Row 6 (15)** both recovery cases: (a) healthy production rollback v2 -> v1 with timeline and measured interruption;
  (b) staging-only failed deployment (Gunicorn bound to 8001 in a separate configuration commit), Jenkins stops,
  restore the previous configuration commit and release record, verify. Database/state-compatibility discussion.
- **Row 7 (5)** production `/health` added to the Blackbox probes and Grafana; release/rollback timestamps correlated
  with monitoring; single-server and state limitations.

## Gates first (see README): G1 agent, G2 capacity, G3 DNS, G4 apply SD's Caddy block, G5 deploy account and sudo,
G6 registry tokens, G7 pipeline shape and approvers.

## Inputs from SD you can use now
- `sd-work/pricing-service/` (locked, pinned, tested), `sd-work/ansible/` (pinned, syntax-checked), `sd-work/releases/release.example.yml`.
- pip-audit command that already works on the lock (evidence 172): `pip-audit -r requirements.txt --require-hashes --disable-pip`.

## Checklist (final, Nov 19, 2026)
- [x] G1 agent (205, 206) · [x] G2 capacity t3.medium (200) · [x] G3 DNS · [x] G4 Caddy (208) · [x] G5 deploy account (203, 204) · [x] G6 registry tokens (207, 209, 211) · [x] G7 approvers (210)
- [x] scan policy written before the release · [x] real block (build #6, 213) and blocked fixture (239) · [x] approval stage (214-217)
- [x] v1 and v2 released with the same digest staging to production (216, 230, 231) · [x] rollback v2 to v1 with observer log (232, 233)
- [x] failed deployment: first drill by replay (237, 238) and the course drill, Gunicorn on 8001 (243-246)
- [x] monitoring probe and correlation (219, 220, 236) · [x] limitations in the chapter
- [x] manual: BD rows 4-7 written, SD regions merged, PR #2, official PDF built (Gitea Actions run #24, a953531, 275 pages), read by SD
- [x] file: `assignment-8/IT-manual+build.24.a953531-grp1.pdf`
- [x] **Upload to Canvas (#8, due Tue Nov 24, 11:59 pm): BD** (uploaded Nov 20, 2026)

## After submission (server stays up until grading ends; teardown is BD's alone)
- Trivy exceptions end Sun Nov 29, 7 PM New York: after that a delivery build blocks again until a reviewed pull request renews or removes them.
- Keep Gitea, Jenkins, the agent, Caddy, monitoring, staging and production running; disk is the tight resource (3.3 GB free).
