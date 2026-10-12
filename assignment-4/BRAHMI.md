# BRAHMI (BD) — strict scope and step-by-step plan

Read `README.md` first (decisions, gates, working agreement, rules). This file is for Brahmi and her Claude session.
Course manual `dosManual-V1.18.pdf` Chapters 1–2 is the source of truth; if a step here conflicts with it, the manual wins.

## What BD owns (and ONLY this)
- `manual/devopsGitea.tex` regions: **`giteaDomainDns`, `giteaDeployment`, `giteaHttps`, `giteaFirewall`, `giteaManualQuality`**, plus the chapter intro, the status table, and the provider note at the top.
- `gitea/` (docker-compose.yml, Caddyfile, .env.example, README.md).
- `manual/devopsHostsPasswords.tex`, `devopsITManual.tex`, `prologue.tex`, `abstract.tex`, `devopsIntroduction.tex`, template appendices.
- All cloud/DNS/firewall/domain actions, the instructor email, the final PDF build and LMS submission.
- Append-only (own lines only): history, prompt log, glossary, bibliography.

## What BD must NOT touch (Sakshi's)
- Regions **`giteaDatabase`, `giteaWorkflow`, `giteaArchitecture`, `giteaExtraCredit`** in `devopsGitea.tex`. Do not edit, reformat, or "tidy" them.
- Sakshi's history/prompt-log entries, her branches, and her local rehearsal work.
- If something in her area is wrong, tell her; don't fix it.
- `report/` — finished assignment, never modify.

## Sequence overview
`G1 instructor reply → B1–B3 prep (can start now) → launch VM → G2 domain/DNS → G3 HTTPS live → hand off to Sakshi → B-evidence → final build`

## Phase A — start now (no cloud, no cost)

**A1. Chase the instructor reply (gate G1).** The AWS-instead-of-DigitalOcean email is unanswered. Do nothing paid until you have an answer. When it comes, record the answer and date in the provider note at the top of `devopsGitea.tex` (replace the `\Todo`). If the answer is "DigitalOcean only", find out whether any DO credit is available before proceeding.

**A2. Claim the domain (rubric row 1, 10 pts).**
1. Open the GitHub Student Developer Pack page (`education.github.com/pack`) → Namecheap offer → follow the claim link. GitHub's pack page lists a `.me` domain plus an SSL certificate, each free for one year; treat that as unconfirmed until you see your own checkout.
2. At checkout, record: what you were offered, eligibility proof used (do not paste personal data), **first-year price, renewal price, expiry date**, any ICANN fee, auto-renew setting. Screenshot each (redact personal data).
3. Pick the Gitea hostname (e.g. `git.<yourdomain>.me`). Do **not** create DNS records yet (no IP exists).
4. Put a renewal reminder on a calendar owned by both of you; note who owns it. Write all of this into region `giteaDomainDns`.
5. Set `\GiteaHost` in `manual/devopsITManual.tex` and `GITEA_DOMAIN` in your local (untracked) `gitea/.env`.

**A3. Certificate comparison (row 4).** Write a short comparison of two options in `giteaHttps`: (a) Let's Encrypt via Caddy's automatic HTTPS (free, automated renewal; needs port 80 or 443 reachable for the challenge), (b) the Namecheap SSL certificate from the pack (free for one year per the pack page; manual install and renewal). Justify the choice. Cite sources in `devopsReferences.bib`. Verify against current docs: `caddyserver.com/docs/automatic-https`, `letsencrypt.org/docs/challenge-types/`.

**A4. Firewall plan (row 5).** Draft the inbound rule table in `giteaFirewall`, for **IPv4 and IPv6**:

| Port | Source | Purpose |
|---|---|---|
| 443/TCP | anywhere | HTTPS to Caddy |
| 80/TCP | anywhere | HTTP→HTTPS redirect and certificate validation only |
| 22/TCP | your and Sakshi's current IPs only | admin SSH |
| 3000 | nobody | Gitea backend, private to the Compose network |
| SQLite | n/a | no database port exists |
| Gitea SSH | n/a | disabled (`DISABLE_SSH=true`); Git over HTTPS only |

Also plan the **external test** (must run from outside the VM, e.g. phone hotspot or another machine): `curl -I http://<host>` (expect a redirect), `curl -vI https://<host>` (cert issuer/expiry), a port probe of 22/3000 from an unapproved IP (expect blocked), and 443/80. A scan from the VM itself proves nothing.

**A5. Review the deployment files.** `gitea/docker-compose.yml`, `Caddyfile`, `.env.example` are a draft: Gitea 1.27.3 and Caddy 2.11.7 (tags existed on Docker Hub on Oct 12, 2026; re-check, and consider whether a newer Gitea is wanted). Nothing has ever been run on a server. Confirm Caddy as the proxy. Gitea has **no published ports**; only Caddy publishes 80/443. Keep it that way.

## Phase B — after G1 (instructor says yes). Check in with Brahmi before every paid action.

**B1. Launch the VM** (human approves each step). Decide whether to reuse the instance from the last assignment (`i-00ee7edd4a5352f05` in `report/`) or create a new one; reusing changes that assignment's live site, so ask first. Size matters: Gitea + Caddy fit a small instance, but check memory and disk. Record: provider, region, instance type, OS, estimated monthly cost, owner, and the **teardown steps**. On AWS give the instance an **Elastic IP** (otherwise the public IP changes on stop/start and DNS breaks; note its cost). Do not run `deploy/aws/*` scripts from the last assignment unless you have read them; they target the old website.

**B2. Firewall first (row 5).** Create the Security Group / Cloud Firewall with the table above. **Before** removing broad SSH access, confirm you can still log in from an approved IP (lockout risk). Check for overlapping firewalls. Note that Docker-published ports bypass `ufw`, so the cloud firewall is the real boundary.

**B3. DNS (G2).** Create an `A` record for the hostname → the VM's public IP (and `AAAA` only if the VM has IPv6 and you want it). Verify with an independent lookup (e.g. `nslookup <host> 8.8.8.8`, or a teammate's machine). Screenshot the DNS panel.

**B4. Install and deploy (row 2).**
1. Install Docker Engine and the Compose plugin; record versions.
2. Clone the repo (read-only deploy key if it's private; never paste the private key anywhere), `cd assignment-4/gitea`, `cp .env.example .env`, set `GITEA_DOMAIN`.
3. `docker compose up -d`; `docker compose ps`; `docker compose logs caddy` (watch certificate issuance).
4. Create the first admin from a terminal **yourself** so the generated password never enters a chat: `docker compose exec -u git gitea gitea admin user create --admin --username <u> --email <e> --random-password`. Store the password in a password manager; put only a hint/vault reference in the Passwords table.
5. Record in `giteaDeployment`: provider/instance version, image tags and source (Docker Hub `gitea/gitea`, `caddy`), exact commands, restart policy (`unless-stopped`), volumes, proxy connection, redacted Compose excerpt, link to the file in the repo, and steps another team could repeat.

**B5. HTTPS evidence (row 4, G3).** Capture: valid cert for the hostname (issuer, expiry), HTTP→HTTPS redirect, where TLS terminates (Caddy; plain HTTP on the private Compose network to `gitea:3000`), `ROOT_URL` is https. **Renewal:** Caddy renews automatically and stores certs in the `caddy_data` volume. As far as we know Caddy has no certbot-style `--dry-run`; verify in its docs. Acceptable evidence needs a real renewal test, so decide with Brahmi between (a) pointing Caddy at Let's Encrypt's **staging** CA temporarily and showing issuance logs, or (b) another honest method you can run. Describe what you actually did; never claim a dry run you didn't perform.

**B6. External exposure evidence (row 5).** Run the planned tests from outside; record test source, time, expected vs. actual for 443, 80, admin SSH, 3000, and the (absent) DB port; include the Compose port mappings (`docker compose ps`, `ss -tlnp` on the host) and a sanitized firewall screenshot/export. Document any correction you had to make. Explain why HTTPS isn't a firewall.

**B7. Hand off to Sakshi (G3).** Send her: the URL; ask for her **public** SSH key and add it to the VM; give her a Gitea account/admin access via a password manager. Tell her which firewall source IPs are allowed (add hers). She does persistence, workflow, architecture, backup/restore from here.

**B8. Hosts and Passwords tables.** Add the VM (hostname, role, provider, address/DNS, exposed ports, owner, HTTPS URL, backup status) and hint rows for the Gitea admin, VM SSH key, domain registrar account, cloud account. Hints/vault references only, MFA status noted.

## Phase C — finish and submit
1. **Row 8 (`giteaManualQuality`)**: bump `\DocumentVersion`, history entries (dated, initials, links to changed sections, **explicitly name Hosts and Passwords updates**), headings/captions/citations, glossary/index terms, failed tests and corrections, and a failed-build or troubleshooting note.
2. Merge Sakshi's branch (resolve conflicts only in shared append-only files), remove every `\Todo`.
3. Build per `README.md`; read the whole PDF; verify links and redaction; add your AI Prompt Log record.
4. Upload **only** the PDF to the LMS.
5. After grading (or when told): tear down cloud resources and record the shutdown in the manual (costs, renewals).

## BD done-list
- [ ] Instructor decision recorded · [ ] domain claimed with costs/expiry · [ ] firewall applied and externally tested · [ ] DNS + independent lookup
- [ ] Gitea + Caddy running, pinned · [ ] cert, redirect, renewal evidence · [ ] Sakshi has access · [ ] tables current · [ ] PDF submitted
