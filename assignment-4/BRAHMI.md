# BRAHMI (BD) — strict scope and step-by-step plan

Read `README.md` first (decisions, gates, working agreement, rules). This file is for Brahmi and her Claude session.
Course manual `dosManual-V1.18.pdf` Chapters 1–2 is the source of truth; if a step here conflicts with it, the manual wins.

## Progress tracker (kept up to date as we work)
_Last updated: Oct 15, 2026 (Gitea + Caddy live over HTTPS, admin `brahmi` works; Sakshi's branch `sd/gitea` exists, unmerged)._ Evidence files are in `evidence/` (see its `README.md` index).

### Done
| Item | Date | Notes / evidence |
|---|---|---|
| Manual skeleton from Canvas template v1.3, Gitea chapter outline, draft `gitea/` compose | Oct 12 | Compose validates with `docker compose config`; never run on a server |
| Decisions: SQLite final, BD owns deployment, extra credit optional/unassigned | Oct 12 | `README.md` |
| **G1** instructor approved AWS ("available online and usable by the TA and me to test") | Oct 12 | Recorded in the provider note in `devopsGitea.tex` |
| Decision: **new** EC2 instance (leave last assignment's instance alone until graded) | Oct 14 | Section B1 |
| Domain claimed: `ssw590-g1.tech` via Name.com Student Pack offer, **$0.00** | order confirmed (email dated Oct 14; local Oct 15) | Order #28974415; evidence 01, 02, 06 |
| Domain facts captured: renewal price **$89.99**, expires **Oct 15, 2027**, WHOIS privacy ON, transfer lock ON | Oct 15 | Evidence 03 |
| Auto-renew turned **OFF** | Oct 15 | Evidence 04 |
| Stored payment card deleted ("No saved payment profiles") | Oct 15 | Evidence 05 |
| Namecheap offer declined: its GitHub authorization asked for the `repo` scope (read/write all repos) | Oct 14 | Name.com asked only for public data; noted in the manual |
| Hostname set in the manual: `git.ssw590-g1.tech` (DNS **not** created yet) | Oct 15 | `\GiteaHost` in `devopsITManual.tex` |
| Manual `giteaDomainDns` region written (facts table, 2 figures, payment safeguards) | Oct 15 | Still has `\Todo`s, see Pending |
| PDF builds (34 pages, no errors) | Oct 15 | `manual/devopsITManual.pdf` |
| Decision: use the **AWS CLI** (not the console) for EC2 work; instance specs OK "as long as it works and doesn't cost more" | Oct 15 | |
| Read-only AWS checks: CLI v2.37.9 works, region `us-east-1`, credentials valid. Existing: 1 running instance (`ssw590-group1-web`, `t3.micro`, last assignment, untouched), 0 Elastic IPs, 1 old key pair, 1 old security group | Oct 15 | CLI is **not on PATH**: run `C:\Program Files\Amazon\AWSCLIV2\aws.exe` from PowerShell |
| Finding: IAM user `ssw-590` is **not allowed** to view or create AWS Budgets | Oct 15 | Budgets must be managed in the console by the account owner |
| **Security group `ssw590-g1-gitea` created** (`sg-0415c75429368eb85`, default VPC, us-east-1): 443 and 80 from anywhere (IPv4), 22 from Brahmi's single IP only, egress all. Not attached to anything yet | Oct 15 | Evidence 08 (admin IP redacted). IPv4 only, no AAAA planned |
| **EC2 instance launched**: `i-0c68ec1bc1e16a414`, `t3.micro`, Amazon Linux 2023 (`ami-0ed59cbb87dfa8dba`), 20 GB gp3, IMDSv2 required, `us-east-1c`; new key pair `ssw590-g1-gitea-key` (private key at `C:\Users\BRAHMI\.ssh\ssw590-g1-gitea-key.pem`, outside the repo, never commit) | Oct 15 | Evidence 09 |
| **Elastic IP** `52.73.254.36` attached to the instance | Oct 15 | Evidence 09. Billed hourly; release it at teardown |
| Boot script `gitea/aws/ec2-user-data.sh` ran OK: 2 GB swap, Docker 25.0.14, Compose v5.6.0 (SHA-256 pinned), git 2.50.1 | Oct 15 | Evidence 09 |
| **DNS A record created**: `git.ssw590-g1.tech` -> `52.73.254.36`, TTL 300 (no AAAA) | Oct 15 | Evidence 10 |
| DNS verified via 8.8.8.8, 1.1.1.1, 9.9.9.9 (all return `52.73.254.36`); SSH by hostname works with the verified host key; server matches plan (AL2023, Docker 25.0.14, Compose v5.6.0, 2 GB swap) | Oct 15, 17:30 UTC | Evidence 11. Lookups were from Brahmi's machine, not a teammate's |
| Manual `giteaDomainDns` updated with DNS record, lookup table, figure | Oct 15 | Remaining there: optional teammate lookup, HTTPS link |
| **Gitea 1.27.3 + Caddy 2.11.7 deployed** on the server in `~/gitea` via `docker compose up -d` (files copied from `assignment-4/gitea/`, checksums match; `.env` has only non-secret values). Gitea healthy; only Caddy publishes 80/443 | Oct 15, 17:34 UTC | Evidence 12 |
| **Let's Encrypt certificate obtained automatically** (TLS-ALPN-01), issuer `YE2`, valid 2026-10-15 to 2027-01-13, TLS 1.3, chain valid; HTTP gives 308 redirect to HTTPS; HTTPS 200 | Oct 15, 17:35 UTC | Evidence 12, 13 |
| First external probes from the admin machine: 443 and 80 open; 3000, 2019, 5432 not reachable | Oct 15 | Evidence 13. From the **admin IP**, so a second-network test is still needed |
| **First Gitea admin created** by Brahmi in her own terminal (username `brahmi`; password in her password manager, never shared) and sign-in at `https://git.ssw590-g1.tech` works | Oct 15 | Evidence 14 |
| Checked the remote: `main` has nothing new. Sakshi pushed branch **`sd/gitea`** (1 commit, "draft rows 3, 6, 7, 8"): touches only her regions and shared append-only files; a trial merge into `main` predicts no conflicts | Oct 15 | Not merged yet; see Pending #12 |
| Budget already exists: "My Monthly Cost Budget", **$15.00/month**; used $3.13, forecast $3.12 (before the new instance) | Oct 15 | Evidence 07. Thresholds/email not visible in the screenshot |

### Pending (in order)
| # | Item | Blocked by |
|---|---|---|
| 1 | Check card statement a few days after Oct 15 for any Name.com charge; record result in the manual | time |
| 2 | Name the owner of the Oct 15, 2027 renewal reminder; add to the manual | you |
| 3a | _Optional, deferred by Brahmi (Oct 15): not needed for grading._ Check the existing $15 budget's alert thresholds/email; it may fire once the second instance runs | you, whenever |
| 3b | Confirm final instance specs: recommended `t3.micro` + 2 GB swap, 20 GB gp3, new key pair + new security group, Elastic IP (cost estimates in chat; verify on AWS pricing) | you |
| 4 | Certificate comparison (A3), firewall rule table (A4), review compose files (A5) | nothing, can do now |
| 5 | ~~Security group, key pair, instance, Elastic IP~~ (all done) | |
| 6 | ~~DNS record, lookup, SSH test~~ (done). Optional: Sakshi runs `nslookup git.ssw590-g1.tech 8.8.8.8` from her side | |
| 7 | ~~Deploy Gitea + Caddy, create first admin~~ (done) | |
| 7a | **Hand-off to Sakshi (B7), now unblocked:** (1) ask her for her SSH **public** key and add it to `~/.ssh/authorized_keys` on the server (her public IP is the same as yours, so the security group already allows her); (2) create her Gitea account in the admin UI (site administration, user accounts, "must change password"), give her the temporary password through a password manager, never chat; (3) create the Gitea organization `group1-startup` (her backlog draft names you as owner) and add her; (4) tell her it is ready | you |
| 7b | **Write your three manual regions from real evidence:** `giteaDeployment` (evidence 09, 11, 12, 14), `giteaHttps` (certificate comparison + evidence 12, 13), `giteaFirewall` (evidence 08, 13 + a second-network test). Claude can draft these | you + Claude |
| 8 | Remaining HTTPS/exposure evidence: a real **renewal test** (e.g. temporarily use Let's Encrypt staging, or another honest method); external test from a **second network** (phone hotspot) for SSH/80/443/3000; confirm the hostname loads in a browser (screenshot) | after #7 |
| 9 | Hand Sakshi access: URL, her public SSH key, a Gitea account (B7) | #8 |
| 10 | Hosts and Passwords tables, history entry, prompt-log record (B8) | as things happen |
| 11 | Final build, remove `\Todo`s, submit PDF only (Phase C) | everything |
| 12 | **Commit and push** your own uncommitted work first (evidence 07-14, `gitea/aws/ec2-user-data.sh`, manual and tracker edits), then review and merge Sakshi's `sd/gitea` branch; tell her to `git pull --rebase` afterwards | you |
| 13 | Hosts and Passwords tables are still placeholders: add the server (hostname `git.ssw590-g1.tech`, AWS `us-east-1`, instance `i-0c68ec1bc1e16a414`, ports 443/80/22), and hint rows for the Gitea admin, AWS, Name.com, SSH key | you + Claude |

## What BD owns (and ONLY this)
- `manual/devopsGitea.tex` regions: **`giteaDomainDns`, `giteaDeployment`, `giteaHttps`, `giteaFirewall`**, plus the chapter intro, the status table, and the provider note at the top.
- `gitea/` (docker-compose.yml, Caddyfile, .env.example, README.md).
- `manual/devopsHostsPasswords.tex`, `devopsITManual.tex`, `prologue.tex`, `abstract.tex`, `devopsIntroduction.tex`, template appendices.
- All cloud/DNS/firewall/domain actions, the instructor email, the final PDF build and LMS submission.
- Append-only (own lines only): history, prompt log, glossary, bibliography.

## What BD must NOT touch (Sakshi's)
- Regions **`giteaDatabase`, `giteaWorkflow`, `giteaArchitecture`, `giteaManualQuality`** in `devopsGitea.tex`. Do not edit, reformat, or "tidy" them.
- Sakshi's history/prompt-log entries, her branches, and her local rehearsal work.
- If something in her area is wrong, tell her; don't fix it.
- `report/` — finished assignment, never modify.

## Sequence overview
`G1 instructor reply → B1–B3 prep (can start now) → launch VM → G2 domain/DNS → G3 HTTPS live → hand off to Sakshi → B-evidence → final build`

## Phase A — start now (no cloud, no cost)

**A1. Instructor reply (gate G1): DONE.** On Oct 12, 2026 the professor replied that any hosting service, including AWS, is allowed provided it is available online and usable by the TA and him to test the assignments. It is recorded in the provider note in `devopsGitea.tex`. **Design consequence:** the deployment must stay up and testable by the TA/instructor through grading. Gitea's HTTPS is public anyway; SSH only needs to be open to you and Sakshi. Plan how the TA will test (a TA account or a repo they can view) and do not tear anything down until grading is finished. Still check with Brahmi before every paid launch.

**A2. Claim the domain (rubric row 1, 10 pts). DONE Oct 15 via Name.com (not Namecheap); see the tracker. Remaining: DNS record and lookup after the server exists, the renewal-reminder owner, and the card-statement check. The steps below are the original plan.**
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

## Phase B — G1 cleared (AWS approved). Check in with Brahmi before every paid action.

**B1. Launch the VM** (human approves each step). **Decided (Oct 14, 2026, Brahmi): create a NEW instance.** Leave the last assignment's instance (`i-00ee7edd4a5352f05`, in `report/`) untouched; it will be disabled only after that assignment is graded. Size matters: Gitea + Caddy fit a small instance, but check memory and disk. Record: provider, region, instance type, OS, estimated monthly cost, owner, and the **teardown steps**. On AWS give the instance an **Elastic IP** (otherwise the public IP changes on stop/start and DNS breaks; note its cost). Do not run `deploy/aws/*` scripts from the last assignment unless you have read them; they target the old website.

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

**B7. Hand off to Sakshi (G3).** Send her: the URL; ask for her **public** SSH key and add it to the VM; give her a Gitea account/admin access via a password manager. Tell her which firewall source IPs are allowed (add hers). She does persistence, workflow, architecture and the row 8 quality pass from here. The extra-credit backup/restore is unassigned and optional.

**B8. Hosts and Passwords tables.** Add the VM (hostname, role, provider, address/DNS, exposed ports, owner, HTTPS URL, backup status) and hint rows for the Gitea admin, VM SSH key, domain registrar account, cloud account. Hints/vault references only, MFA status noted.

## Phase C — finish and submit
1. **Row 8 is Sakshi's** (`giteaManualQuality`, version bump, quality review). Your part: keep Hosts/Passwords tables current and tell her when they change so she can name them in the history entry; add your own history entry and prompt-log record.
2. Merge Sakshi's branch (resolve conflicts only in shared append-only files), remove every `\Todo`.
3. Build per `README.md`; read the whole PDF; verify links and redaction; add your AI Prompt Log record.
4. Upload **only** the PDF to the LMS.
5. After grading (or when told): tear down cloud resources and record the shutdown in the manual (costs, renewals).

## BD done-list
See the **Progress tracker** at the top of this file; it replaces the old checkbox list. (Row 8 manual quality is Sakshi's.)
