# BRAHMI (BD) — strict scope and step-by-step plan

Read `README.md` first (decisions, gates, working agreement, rules). This file is for Brahmi and her Claude session.
Course manual `dosManual-V1.18.pdf` Chapters 1–2 is the source of truth; if a step here conflicts with it, the manual wins.

## Progress tracker (kept up to date as we work)
_Last updated: Oct 15, 2026 (HTTPS live, admin `brahmi` works, Sakshi's `sd/gitea` merged into `main`; Brahmi's three regions and the Sakshi hand-off are next)._

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
| Your work committed (`4f691a0`) and Sakshi's branch **`sd/gitea` merged into `main`** (merge commit `1d3de7b`), pushed; `main` is in sync with `origin/main`; no PDF tracked | Oct 15 | Her branch only touched her regions and shared append-only files |
| Read-only server pre-checks of Sakshi's persistence script: all its assumptions hold (python3 3.9, container `gitea` healthy, volume `gitea_gitea_data` -> `/data`, DB `/data/gitea/gitea.db` 2.1 MB, server reaches its own HTTPS URL, API 1.27.3) | Oct 15 | Evidence 15. Her script is not run yet; it is her row 3 task |
| `README.md` working agreement changed: **work on `main`, no new branches**; `SAKSHI.md` has a status section, steps and a verification table for her rows | Oct 15 | |
| **Gitea organization `group1-startup` and team `developers` created** (Write on all repositories, no members yet); Brahmi is the only member | Oct 15 | Evidence 16. Org visibility not shown in the screenshot; confirm it is Public |
| Brahmi joined the `developers` team herself (team now shows 1 member, badge Public) | Oct 15 | Evidence 17. Sakshi is not a member yet |
| Sakshi's SSH public key validated and added to the server's `authorized_keys` (2 keys now: Brahmi, Sakshi); she also confirmed she pulled, switched to `main`, deleted her local `sd/gitea`, and will not sign in until told | Oct 15, 18:15 UTC | Evidence 18. Her login not yet verified. Her email is not stored in the repo |
| **Sakshi's Gitea account `sakshi` created and added to team `developers`** (team shows 2 members, brahmi + sakshi; org Members 2); message with the SSH host-key fingerprint sent to her | Oct 15 | Evidence 19. Waiting for her to confirm Gitea sign-in + password change and her SSH login |
| **Manual regions drafted from real evidence:** `giteaDeployment` (versions table, config, Compose and Caddyfile included from the repo, repeatable steps, checks, problems met), `giteaHttps` (option comparison, TLS termination, certificate and redirect facts, renewal explanation), `giteaFirewall` (security group, rules, port mappings, new figure `TikZ/devopsGitea/devopsGiteaFirewall.tex`, exposure checks, why HTTPS is not a firewall). Full PDF build clean (51 pages, no undefined references) | Oct 15 | Open items are `\Todo`s in each region; see Pending #14 |
| **Sakshi confirmed she can log in.** Verified on the server: her key logged in 5 times from 18:25:52 UTC; no failed SSH attempts in the log. Her Gitea sign-in is her own report (not independently checked) | Oct 15 | Evidence 23 (renumbered: Sakshi also used 20) |
| **Pulled Sakshi's latest and pushed ours**: `main` at `5755c82`, in sync with `origin/main`; `origin/sd/gitea` is gone; combined manual builds clean (54 pages). Renumbering fix: her evidence 20-22 kept, my sshd log became **23** | Oct 15 | |
| **Sakshi's row 3 (persistence) verified by Brahmi's Claude** against the pass conditions in `SAKSHI.md`: real run on the server at 18:29 UTC as user `sakshi`, repo id 1 / issue #1 / branch commit `4f15f700003e` identical before and after; container id changed `858a02ae8412` to `834924d4bc0a`; same volume `gitea_gitea_data`; used `up -d --force-recreate gitea` with no `-v`; cross-checks with the sshd log (her logins at 18:28 to 18:30 UTC) | Oct 15 | Her evidence 20-22. Screenshots 21-22 not opened by Claude |
| **Hosts and Passwords tables filled in** (3 hosts: the Gitea server, the domain/DNS, the previous assignment's instance; 8 password/key hint rows; no secrets), a history entry that names both tables, and an AI Prompt Log record for Brahmi's work. Build clean (57 pages) | Oct 15 | Remaining `\Todo`s in the Passwords table are facts only you know: password-manager entry name, MFA status for Gitea/AWS/Name.com/GitHub, where the AWS and GitHub credentials are kept, Sakshi's key passphrase |
| Row 6 split written down: your Gitea setup steps, issue table, CONTRIBUTING.md draft, and the two traces are in the new "Row 6" section of this file; evidence numbering rule (Sakshi 24 to 39, Brahmi 40+) added to `evidence/README.md` | Oct 15 | Nothing created in Gitea yet |
| **HTTPS option B researched (partly):** Name.com's free Domain Safe certificate is a DV certificate from its free-certificate program, renewable manually within 90 days of expiry; whether it can be installed on an external server is **not confirmed**; the Namecheap free SSL claim has at least one reported problem. Written into the HTTPS region with 3 new citations; build clean | Oct 15 | Sources are search-result summaries of Name.com pages (article bodies could not be read). Open `\Todo`: ask Name.com support |
| **Second-network (phone hotspot) test done:** 443 and 80 open, **SSH blocked** (valid key still timed out after about 20 s), 3000/2019/5432 not reachable; written into the firewall region and its table | Oct 15, 18:57 UTC | Evidence 41. Remaining in that region: a sanitized AWS console screenshot of the inbound rules |
| **Certificate renewal dry run done (staging)**: attempt 1 inconclusive (Caddy kept the existing certificate), attempt 2a rejected (wrong directive, live config unaffected), attempt 2b **succeeded** (throwaway name with a staging-only issuer; certificate obtained in about 5 s, served with a staging issuer); production certificate unchanged; Caddyfile restored (checksum equals the repo copy), test cert and backup removed. Written into the HTTPS region, including all three attempts | Oct 15, 19:03 to 19:08 UTC | Evidence 42. It is an **issuance** test, not a renewal of the production certificate: that is predicted for Dec 13 to 15, 2026 |
| **AWS console screenshot of the inbound rules saved and in the manual** (figure in the firewall region). The account ID (3 places) and the admin IP were blacked out before saving; the original is not in the repo | Oct 15 | Evidence 43. Reminder: the AWS account ID is not recorded anywhere in the repo |
| **Evidence embedded inline in the PDF for your regions** (all needed screenshots as figures: cart, order, domain page ON and OFF, billing, order email, DNS record, Gitea login, AWS console; real command outputs as captioned listings E08, E09, E11, E12, E13, E23, E41, E42). "evidence file NN" references replaced with cross-references (macros `\ListRef{NN}` and `\FigRef{NN}`; listings use the new `longlisting` environment). Build clean, 70 pages, layout checked | Oct 15 | Sakshi's regions still cite repository files in one place (persistence log) |
| **Passwords table completed** from Brahmi's answers (entry name "Gitea admin"; MFA on for Gitea, AWS, Name.com, GitHub; AWS and GitHub credentials written down offline; AWS sign-in is the account owner) and Sakshi's (passphrase set, MFA on). Two earlier assumptions of Claude removed (Sakshi's and Name.com password storage). MFA is as reported, not independently checked | Oct 15 | No `\Todo` left in the Hosts/Passwords chapter |
| **Sakshi ran `row6-setup.py`: it stopped at repository creation with HTTP 403** ("User is not allowed to create repositories in this organization"). Nothing was created and she deleted her token. Her team `developers` cannot create repositories, so **you run the script FIRST** (you are an owner); she reruns it afterwards for her README PR. She also pushed row 7 (commit `ecc32c8`, her evidence 24); her row 6 screenshots will be 25+ | Oct 15 | The script handled the 403 as designed (stopped cleanly) |
| **Script extended with a stage that publishes the deployment files to a public Gitea repo `group1-startup/infra`** (docker-compose.yml, Caddyfile, .env.example, aws/ec2-user-data.sh, README), because the GitHub repo is private (anonymous check returns 404) so graders could not open the manual's link. The manual links to `\GiteaURL/group1-startup/infra` and has one `\Todo` to delete once the link is confirmed to open | Oct 15 | Runs as part of your run of the script |
| **Costs recorded in the manual** (about \$12.84 per month: instance \$7.59 + public IPv4 \$3.65 + 20 GB gp3 \$1.60, list prices, with sources and the honest caveat that two rates are not from AWS's own pages); optional TODOs turned into plain sentences | Oct 15 | Build clean, 70 pages |
| **GitHub repo made public by Brahmi** (anonymous check returns HTTP 200). **Full-history secret scan before/after: clean** across all 22 commits (no private keys, access or API tokens, passwords, AWS account ID, admin IP or email; no key/.env files ever tracked). The deployment link in the manual now works through GitHub; the Gitea `infra` copy is a second copy, no longer blocking | Oct 15 | Things now public that you may want to reconsider are in the chat message: the course template zip, the earlier assignment, instance/security-group IDs |
| **Brahmi ran `row6-setup.py` successfully** and verified: repo `group1-startup/twintrack` (public), 6 issues with assignees, `main` **protected** (1 approval; the site admin's own direct commit refused with HTTP 403; confirmed from outside via the anonymous API), issue #4 closed, **PR #7 "Add CONTRIBUTING.md" open with `Closes #2`**, public repo `group1-startup/infra` with the 4 deployment files (checksums match). Token deleted | Oct 15, ~19:30 UTC | Evidence 40 |
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
| 7a | ~~Hand-off to Sakshi~~ **done**. Left: delete the merged `sd/gitea` branch on GitHub (Branches page, trash icon) if not done yet | you |
| 7b | **Write your three manual regions from real evidence:** `giteaDeployment` (evidence 09, 11, 12, 14), `giteaHttps` (certificate comparison + evidence 12, 13), `giteaFirewall` (evidence 08, 13 + a second-network test). Claude can draft these | you + Claude |
| 7c | Brahmi's part of row 6 is **done** (see evidence 40). **Left:** Sakshi reruns the script for her README PR (issue 1); you **review and approve** hers; she **reviews** PR #7 (at least one comment, you address it, she approves); merge both; confirm issues 1 and 2 close; **issue 6**: add Oct 15, 2027 to the shared calendar, name the owner, close the issue; dated screenshots (evidence 44+ for you, 25+ for Sakshi) | Sakshi, then you |
| 8 | ~~HTTPS renewal test~~ and ~~second-network test~~ done (evidence 41, 42). **Left:** observe the real automatic renewal around Dec 13 to 15, 2026 if the service is still in use (optional follow-up) | |
| 9 | Hand Sakshi access: URL, her public SSH key, a Gitea account (B7) | #8 |
| 10 | Hosts and Passwords tables, history entry, prompt-log record (B8) | as things happen |
| 11 | Final build, remove `\Todo`s, submit PDF only (Phase C) | everything |
| 12 | Merge done. **Left:** tell Sakshi, then delete the merged branch on GitHub (Branches page, trash icon; or `git push origin --delete sd/gitea`), then locally `git fetch --prune`. From now on **nobody creates branches**: both work on `main` with `git pull --rebase` before pushing (rule 1 in `README.md`) | you |
| 13 | ~~Hosts and Passwords tables~~ done. Keep them current if anything changes | |
| 14 | **Required for grading, still open (3):** (a) row 1: how a future team tracks renewal: put the Oct 15, 2027 reminder in the shared calendar (issue 6) and tell Claude who owns it; (b) row 2: the GitHub link now works (repo is public); optional second copy: after your script run, open `https://git.ssw590-g1.tech/group1-startup/infra` signed out, confirm it lists the 4 files, then delete the `\Todo` in the deployment region; (c) rule 7 charges: done (estimate in the manual). **Not required (turned into plain sentences):** card statement check, Name.com support question, teammate DNS lookup, observing the Dec 13 to 15 renewal | you |

## Row 6 (startup team workflow): Brahmi's part, step by step
Sakshi owns the row 6 text in the manual; you own the Gitea setup and two of the traces. Plan source: `sd/backlog-draft.md`. **Evidence numbering from now on: Sakshi uses 24 to 39, Brahmi uses 40 and up** (we collided on number 20 once). Save each dated screenshot in `evidence/` and add an index row.

**Fast path (Claude cannot click in your browser, but the script `assignment-4/gitea/row6-setup.py` can do the setup through the API; it is split by person, and you run yours SECOND):** Sakshi runs it first (repo, 6 issues, README pull request for issue 1). Then you run `python assignment-4/gitea/row6-setup.py` from the repository root: it protects `main` (no direct pushes, also for admins, 1 approval), tries a direct commit to `main` and reports whether it was **refused** (proof for issue 4, which it then closes), and opens your pull request "Add CONTRIBUTING.md" with `Closes #2`. The script asks for a Gitea token at a **hidden prompt** (Gitea, Settings, Applications; scopes `read:user`, `write:organization`, `write:repository`, `write:issue`), never saves or prints it, and prints only safe results. **Delete the token afterwards.** Paste the output to Claude to record as evidence 40. Still done by a person: **review and approve Sakshi's README PR**, address her review comment on yours, merge, issue 6 (calendar), and the dated screenshots. The manual steps below are the fallback.

**Setup (once, about 15 minutes), signed in as `brahmi`:**
1. **Create the repository.** Organization `group1-startup`, then Repositories, then **New Repository**. Name `twintrack`. Description "TwinTrack: Group 1's startup product". Leave **private unchecked** (public, so the TA and instructor can open it). **Tick "Initialize Repository"** with a README so `main` exists. Default branch `main`. No license, no .gitignore. Create. Screenshot 40.
2. **Create the 6 issues** (Issues, then New Issue). Titles, assignees and acceptance text are in the table below. Set the assignee in the right sidebar. Screenshot the issue list (41).
3. **Protect `main` (this is issue 4).** Repo Settings, then Branches, then **Add Branch Protection Rule**: pattern `main`; **disable direct pushes**; **required approvals: 1**; tick the options that block merging on rejected reviews and dismiss stale approvals; save. Screenshot the saved rule (42).
4. **Prove it works.** On `main`, click Add file, New file, any name, and commit **directly to main**. Gitea should refuse. Screenshot the refusal (43), cancel, then close issue 4 with a comment linking the screenshot (the proof is the setting, not a PR).
5. **Tell Sakshi the repo is ready.**

| # | Title | Assignee | Acceptance text to paste |
|---|---|---|---|
| 1 | Write the product README | sakshi | README states purpose, status, workflow and team. Delivered by a PR that closes this issue. |
| 2 | Add CONTRIBUTING.md for the issue, branch, PR, review flow | brahmi | CONTRIBUTING.md merged via a PR reviewed and approved by Sakshi. |
| 3 | Define the TwinTrack task data model | sakshi | `docs/data-model.md` lists fields, states and transitions. |
| 4 | Protect `main`: require PR + 1 approval | brahmi | A direct push to `main` is rejected; screenshot of the setting and of the rejection. |
| 5 | Document the Gitea restart and troubleshooting runbook | sakshi | `docs/runbook.md` matches the runbook in the manual. |
| 6 | Add the domain expiry date (Oct 15, 2027) to the shared calendar and name its owner | brahmi | Calendar event exists with an owner and reminder. We do not plan to renew. |

**Trace 2, your pull request (issue 2):**
1. Open `twintrack`, Add file, New file, name `CONTRIBUTING.md`, paste the draft below.
2. At the bottom choose **"Create a new branch for this commit and start a pull request"**, branch name `issue-2-contributing`, then Propose.
3. On the pull request page: title "Add CONTRIBUTING.md", description including the exact line `Closes #2`. Create. Screenshot (44).
4. Ask Sakshi to **review**: she must leave at least one review comment, you reply or fix it, then she **approves**. Screenshot the review with the comment and approval (45).
5. **Merge** (after her approval). Confirm issue 2 closed automatically. Screenshot the merged PR and the closed issue (46).

**Trace 1, you review Sakshi's pull request (issue 1):** when she opens "Add product README" with `Closes #1`, open it, Files changed, **Review, Approve** (add one comment first if you like). Screenshot (47). She merges or you merge; confirm issue 1 closes (48).

**Issue 6 (calendar):** create the calendar event with the owner and reminder, screenshot it (49), close issue 6 with a comment.

**Draft `CONTRIBUTING.md` (paste as is, edit if you like):**
```markdown
# Contributing to TwinTrack

1. Every change starts as an issue. Pick or create one before you start.
2. Branch from `main` as `issue-<number>-<short-name>`.
3. Open a pull request with `Closes #<number>` in the description.
4. The other team member reviews it, leaves at least one comment or question,
   and approves once it is addressed. You cannot approve your own pull request.
5. After approval, merge. The issue closes automatically.
6. `main` is protected: no direct pushes.
7. Never commit passwords, tokens, private keys or personal data.
```

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
2. Pull Sakshi's pushed commits on `main` (`git pull --rebase`; shared append-only files are the only likely conflicts), run the verification table in `SAKSHI.md`, remove every `\Todo`.
3. Build per `README.md`; read the whole PDF; verify links and redaction; add your AI Prompt Log record.
4. Upload **only** the PDF to the LMS.
5. After grading (or when told): tear down cloud resources and record the shutdown in the manual (costs, renewals).

## BD done-list
See the **Progress tracker** at the top of this file; it replaces the old checkbox list. (Row 8 manual quality is Sakshi's.)
