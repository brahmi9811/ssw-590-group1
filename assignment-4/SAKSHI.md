# SAKSHI (SD) — strict scope and step-by-step plan

Read `README.md` first (decisions, gates, working agreement, rules). This file is for Sakshi and her Claude session.
Course manual `dosManual-V1.18.pdf` Chapters 1–2 is the source of truth (ask Brahmi/Canvas for the PDF); if a step here conflicts with it, the manual wins.

## What SD owns (and ONLY this)
- `manual/devopsGitea.tex` regions: **`giteaDatabase`, `giteaWorkflow`, `giteaArchitecture`, `giteaExtraCredit`**. (Rows 3, 6, 7 = 35 pts, and the mandatory 20-pt backup/restore extra credit.)
- Append-only, own lines only: `devopsDocumentHistory.tex`, `devopsAIPromptLog.tex`, `devopsGlossary.tex`, `devopsReferences.bib`.
- `devopsHostsPasswords.tex`: only add rows for SD's own accounts, hints only. Everything else in it is Brahmi's.
- Your own branch (`sd/...`) and your local rehearsal environment.

## What SD must NOT touch (Brahmi's)
- Regions **`giteaDomainDns`, `giteaDeployment`, `giteaHttps`, `giteaFirewall`, `giteaManualQuality`**, the chapter intro, the status table, and the provider note.
- `gitea/` (compose, Caddyfile, .env.example): if you find a problem while rehearsing, **report it to Brahmi**; don't edit it. Local-only overrides go in untracked files and are never committed.
- Cloud resources, firewall, DNS, domain, certificates. Do not create or change any, and do not ask Claude to.
- `devopsITManual.tex`, `prologue.tex`, `abstract.tex`, `build.sh`, template appendices, and `report/`.
- Final PDF assembly and LMS submission (Brahmi).

## Decisions that already bind you
SQLite is **final** (no PostgreSQL). Backup/restore extra credit is **mandatory for us**. The VM does not exist until Brahmi gets the instructor's OK; she will give you access at gate G3. Don't wait idle: Phase A needs no cloud.

## Phase A — start now (local, no cloud, no cost)

**A0. Setup.** `git pull --rebase`, create branch `sd/gitea`. Install Docker Desktop. To build the PDF you need MiKTeX/TeX Live with `pdflatex`, `bibtex`, `makeglossaries`, `makeindex`, and Pygments (for `minted`, built with `-shell-escape`). `manual/build.sh` has Brahmi's Windows paths in `MIKTEX_BIN`, `MAKEGLOSSARIES_LUA`, `PYGMENTS_BIN`; edit them **locally only** (use `git update-index --assume-unchanged` or just don't stage that file). The earlier assignment also has a `latex-docker/` container; whether it has everything this manual needs is unverified, so test before relying on it.

**A1. Local rehearsal stack (not evidence).**
1. `cd assignment-4/gitea && cp .env.example .env` and set `GITEA_DOMAIN=localhost` (the `.env` is untracked; keep it that way).
2. `docker compose up -d` → browse `https://localhost` (accept the local certificate warning; Caddy uses its own local CA for `localhost`).
3. Create an admin **yourself in your terminal**: `docker compose exec -u git gitea gitea admin user create --admin --username <u> --email <e> --random-password` and put the printed password in your password manager. Never paste it into Claude or a file.
Rehearsal output is **not** evidence for the PDF. Everything graded must be re-run on the real VM and captured there. Never claim a local run as the real test.

**A2. Persistence rehearsal (row 3, 10 pts).** SQLite lives at `/data/gitea/gitea.db` inside the `gitea_data` volume.
1. Create a repo and an issue; note their identifiers/URLs.
2. Show where data lives: `docker compose exec gitea ls -l /data/gitea`, `docker volume ls`, `docker inspect gitea --format '{{json .Mounts}}'`.
3. Replace only the container: `docker compose up -d --force-recreate gitea`. **Never** use `docker compose down -v` or `docker volume rm` here.
4. Confirm the repo and issue are still there; record exact command, before/after, and a short "why it persisted" explanation (volume outside the disposable container layer).
5. Draft the `giteaDatabase` text: SQLite chosen and why (two-person team, no extra container/credential, simple backup; limitation: weaker under high write concurrency), file path, volume, no DB port, no DB secret. Explicitly say the persistence test is **not** a backup/restore test. Leave real-VM evidence `\Todo`/`\StatusPending` until G3.

**A3. Backup/restore plan (extra credit, up to 20 pts: 5 + 5 + 10).**
Procedure to rehearse locally, then repeat on the VM. Verify every command against Gitea's backup/restore docs (`docs.gitea.com`, Administration → Backup and Restore) before trusting it:
1. Create a test repo and issue **before** the backup (needed for the 10-pt proof).
2. Backup with `gitea dump` run as the `git` user inside the container (it bundles repositories, attachments, config and the database, so one archive covers one recoverable state). Record method, coverage, location, timestamp (5 pts). Show a sanitized log or file listing and explain why DB and app data belong to the same state (5 pts).
3. Restore into a **separate, temporary** instance (distinct Compose project name, distinct volumes, bound to `127.0.0.1` on a spare port; on the VM reach it through an SSH tunnel so no new public port is opened). Never overwrite the working service. Confirm the test repo and issue exist and work in the restored instance; screenshot original and restored side by side with dates; keep the restore log (10 pts).
4. Clean up the temporary instance afterwards.
5. **The dump contains secrets (config, keys). Never commit it, put it in the PDF, or paste it anywhere.** Delete it after the test. Do not submit archives or dumps.

**A4. Architecture and operations (row 7, 5 pts).** In `giteaArchitecture`: a TikZ figure (adapt course Figure 2.1; **SQLite path only**; `tikz` is already loaded in `devopsITManual.tex`) showing browser → cloud firewall → Caddy (443/80) → Gitea (private 3000) → `/data` volume with SQLite, with the admin SSH path separate. Include a caption, label, and citation. Text: end-to-end request and data paths, where data lives, which interfaces are public vs. private, how to restart (`docker compose restart` / `up -d`), how to troubleshoot (`docker compose ps`, `logs`), and the persistence-vs-backup distinction. Describe the **actual** deployment, so finish it after G3 with Brahmi's real details.

**A5. Backlog preparation (row 6, 20 pts).** Prepare, don't create yet: README text; ≥5 actionable issues covering both **product** work (e.g. scope of your semester project) and **operations** work (e.g. document the restart procedure, add branch protection, calendar the domain renewal, rehearse the backup/restore); and two small, real changes that can be done as issue-linked pull requests. Choose real work that actually needs doing.

## Phase B — after G3 (Brahmi gives you access)
1. Send Brahmi your **public** SSH key only; she adds it. Ask her which firewall source IPs are approved and send her your current IP.
2. **Row 3 on the VM:** repeat A2 against the real deployment; capture before/after, commands, identifiers, dates.
3. **Row 6 with Brahmi (needs two people):** create the organization and product repository with README; two member accounts (you and Brahmi) with explicit roles; the ≥5 issues; for **two** issues create issue-linked branches (e.g. `issue-12-short-name`) and PRs that reference the issue (`Closes #12`); the **other** person reviews; merge; confirm the issue auto-closes. Capture links, dated screenshots, and commit IDs.
4. **Extra credit on the VM:** repeat A3 there. Use the SSH tunnel for the restored instance.
5. **Row 7:** finish the figure and text against the real setup.

## Phase C — finish
1. Add your history entry (date, `SD`, change, links to your regions; **state whether Hosts/Passwords changed**, and send Brahmi any Passwords rows) and your AI Prompt Log record (what AI did, what you verified, what you corrected; no credentials).
2. Add glossary/index entries and citations for new terms; remove all `\Todo` in your regions; build the PDF locally and check the last pass for `undefined`/`multiply defined`/`!`.
3. Push your branch and tell Brahmi it's ready; she merges and submits.

## SD done-list
- [ ] Local rehearsal done (not used as evidence) · [ ] row 3 real evidence · [ ] row 6 workflow with Brahmi · [ ] row 7 diagram + runbook
- [ ] Backup/restore done on the VM with 5+5+10 evidence · [ ] history + prompt-log entries · [ ] branch pushed, Brahmi notified
