# BRAHMI (BD) — strict scope and step-by-step plan

Read `README.md` first (decisions, gates, working agreement, rules). This file is for Brahmi and her Claude session.
Course manual `dosManual-V1.18.pdf` Chapters 1–2 is the source of truth; if a step here conflicts with it, the manual wins.

## Progress tracker (kept up to date as we work)
_Last updated: Oct 15, 2026._ Evidence files are in `evidence/` (see its `README.md` index).

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
| Finding: IAM user `ssw-590` is **not allowed** to view or create AWS Budgets | Oct 15 | A budget alert must be created in the console by the account owner |

### Pending (in order)
| # | Item | Blocked by |
|---|---|---|
| 1 | Check card statement a few days after Oct 15 for any Name.com charge; record result in the manual | time |
| 2 | Name the owner of the Oct 15, 2027 renewal reminder; add to the manual | you |
| 3a | Create a **new budget alert in the AWS console** (account owner/root; the CLI user lacks permission) | you |
| 3b | Confirm final instance specs: recommended `t3.micro` + 2 GB swap, 20 GB gp3, new key pair + new security group, Elastic IP (cost estimates in chat; verify on AWS pricing) | you |
| 4 | Certificate comparison (A3), firewall rule table (A4), review compose files (A5) | nothing, can do now |
| 5 | Create Security Group, key pair, Elastic IP, launch the new instance (B1, B2) | #3, your OK per paid step |
| 6 | DNS `A` record for `git.ssw590-g1.tech`, independent lookup (B3) | #5 |
| 7 | Install Docker, deploy Gitea + Caddy, create admin yourself (B4) | #6 |
| 8 | HTTPS evidence and renewal test (B5); external exposure tests (B6) | #7 |
| 9 | Hand Sakshi access: URL, her public SSH key, a Gitea account (B7) | #8 |
| 10 | Hosts and Passwords tables, history entry, prompt-log record (B8) | as things happen |
| 11 | Merge Sakshi's work, remove `\Todo`s, final build, submit PDF only (Phase C) | everything |

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
