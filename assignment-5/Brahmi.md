# BRAHMI (BD) — Assignment 5 scope and plan

Read `README.md` first. Course manual Chapter 3 is the source of truth.

## BD owns: rows 1, 2, 5, 7 (45 points)
- **Row 1 — Source and trigger (15).** Create `group1-startup/manual` in Gitea (owner rights needed). Document: repo link, main `.tex`
  file, workflow file link, chosen branch and `push` event, Git remote protocol (HTTPS), public port 443 via the Caddy TLS proxy,
  private Gitea port 3000, and why the runner needs no public submission port (it polls Gitea over outbound HTTPS).
  Show a run that started from a relevant push.
- **Row 2 — Runner setup (15).** Install `act_runner` (pin and record the version), register it at the chosen scope
  (instance, org, or repo) with a label the workflow targets. Record: location, version, scope, label, execution mode
  (`docker://` job containers vs host mode), network path (runner → `https://git.ssw590-g1.tech`), capacity (concurrent jobs,
  RAM/disk). Evidence: runner shown **online** in Gitea and a job assigned to it. State whether jobs run in temporary containers.
  Confirm no runner or Docker daemon port is published (security group unchanged except as approved).
- **Row 5 — Downloadable artifact (10).** In the workflow review, confirm the artifact name; link the artifact on a successful run;
  download it and show the file opens; record the retention setting or the observed default; say an artifact is not a backup.
- **Row 7 — Runner and secret boundary (5).** Who may edit workflows (only org members with write; PRs reviewed per branch rule),
  where the registration token is stored (password manager, never in repo/logs/PDF), runner isolation, the Docker socket
  privilege risk if mounted, and why untrusted workflow changes must not get privileged Docker access or secrets.
  Link the non-secret runner config (e.g. `config.yaml` without tokens).

## Also BD's
- Gate G1 decision on the runner option (A/B/C in `README.md`) and any instance resize (paid: confirm cost first).
- Server work: runner install/registration, disk/RAM checks, any Docker image pulls on the server.
- Hosts and Passwords tables (runner host/service row; registration token hint, never the value). Tell SD what changed so her
  history entry is accurate.
- Final build download from a successful run and LMS submission (PDF only).

## Not BD's (SD's)
Rows 3, 4, 6, 8: the workflow's compile steps, failure detection, build-identifier injection, the change/failure/repair series,
and the row 8 quality pass. If something there looks wrong, message SD instead of editing.

## Checklist
- [x] G1 runner option agreed (same server, Oct 19) · [x] `group1-startup/manual` created (public; SD has Write, evidence 51) · [x] runner installed (act_runner 0.6.1, config in `runner/`), registered, online (evidence 50)
- [x] job assigned evidence (57) · [x] artifact downloaded and opened, retention recorded (54, 55, 58; observed expiry about 90 days) · [x] row 7 text · [x] Hosts/Passwords updated (runner host row, registration-token hint row, SD collaborator note)
- [x] rows 1, 2, 5, 7 written in `devopsAutomatedBuild.tex` and pushed to Gitea (commit `30a885b`); run #9 green, artifact `IT-manual+build.9.30a885b.pdf` verified anonymously
- [ ] SD row 8 done and last build green · [ ] history + AI-log lines (SD does the history entry; BD review line) · [ ] final PDF downloaded from the last green run and submitted (PDF only)
- [ ] after grading: tear down the runner (`docker compose down` in `~/runner`, remove the 5.8 GB image), then the Assignment 4 teardown list; delete leftover tokens in Gitea

## Notes
- Gitea (`group1-startup/manual`) is the source of truth; `manual-repo/` here is the mirror. Edit in Gitea, then `git pull` before pushing.
- Registration took four attempts (token paste problem); the scripts in `runner/` read the token from the clipboard. Documented in the chapter's runner subsection.
- Server must stay up until grading is finished.
