# BRAHMI (BD) — Assignment 6 scope and plan

Read `README.md` first (rubric, gates, dates). Course manual V1.38 Chapter 4 is the source of truth. **Due Nov 4, 2026, 11:59 PM.**

## PICK UP HERE (session notes, written Oct 28, 2026 when BD logged off)

**State: planning is done; nothing for Assignment 6 has been built or changed on the server yet.** No Jenkins, no DNS record, no webhook, no new user.
- `main` is at `852e8b5` (history was rewritten once to remove a grade line from the public README; Sakshi had not pulled the old commits, so a plain `git pull` fast-forwards her). Plan, task lists and `dosManual-V1.38.pdf` are in `assignment-6/`. The root `README.md` has the status table.
- **Sakshi has not started Assignment 6** (her last commit is Oct 19, `2044565`). Her `Sakshi.md` starts with a note to pull first. **The plan was revised on Oct 28 so that you never wait for her:** you do the bootstrap (issue, Python example, Jenkinsfile, PR) and all infrastructure yourself; she is needed only to review that PR, to author (or just review) the failure and repair PR, and to write rows 4, 5, 6, 8 (see the README "Dependency rule"). Nudge her only at those hand-off points.
- `twintrack` has only README.md and CONTRIBUTING.md. Issues #3, #5, #6 are open; #1, #2, #4 are closed. The Python example from the manual (V1.38, Chapter 4 step 4) is the planned application.
- **Assignment 5 is submitted but its grade is not shown yet. Keep the server, Gitea and the Actions runner running until it is graded.** Assignment 4 is graded. The first assignment's instance is stopped (done on Oct 20).

**Your decisions still open (README gates):**
1. **G1, where Jenkins runs.** Server facts checked Oct 28 (read-only): `t3.micro`, 913 MB RAM, about 330 MB used (Gitea 128 MiB, runner 25, Caddy 21), about 440 MB available, 2 GB swap with 114 MB used, 9.3 GB disk free (5.8 GB of Docker images is the Assignment 5 job image, reclaimable), load near zero. Agreed plan: **try Jenkins on the same server first** with a capped heap (for example `-Xmx384m`), one executor, minimal plugins (Pipeline, Git, Gitea). **Resize only if** there is an out-of-memory kill, swap stays above about 1 GB, or Gitea turns slow during a build. A resize means you stop, change the type and start the instance by hand (Gitea is down a few minutes; the Elastic IP and DNS stay). Check current prices yourself first.
2. **G5, instructor access path** for `https://<ci-host>/login` while browser access is restricted (options in the README). Email the instructor if unsure.
3. **G6, controller or separate agent** for builds (controller is allowed with the risk written; agent recommended, controller executors 0).

**Next steps, in order:**
1. Decide G1, G5, G6 (write the decision in the chapter later).
2. **Bootstrap (G4), no server needed, about 15 minutes:** do section 3b below (issue, branch, the three files from the manual, local test run, PR). This gives Jenkins something to build the moment it is up, so you do not wait for Sakshi.
3. DNS: A record for the Jenkins hostname (for example `ci.ssw590-g1.tech`) to the same Elastic IP as `git`; no AAAA.
4. `~/jenkins/docker-compose.yml` on the server with an exact-pinned LTS tag, a named volume for `/var/jenkins_home`, no published ports, on the Caddy network; Caddy site block for the new host; confirm certificate.
5. Jenkins wizard: plugins, named admin accounts, Jenkins URL; restart test. Then the integration user and webhook (gotcha: set the webhook allowed-host setting in Gitea so a private Jenkins address is allowed; this recreates only the Gitea container).
6. **First Jenkins run on your own bootstrap PR** (no one else needed). Read the exact status-check context from that run's commit status yourself, write it down, then apply the required check on `twintrack` `main`. Message Sakshi: "bootstrap PR ready for review; required check is on; you can do the failure and repair PR (or tell me and I will author it and you review)".

**Working rules and tricks that cost time before:**
- **The AI assistant never stops, starts, resizes or deletes AWS resources, DNS records or the runner; you do those by hand** (saved in memory). It gives commands only and does read-only checks.
- Pasting a token into a terminal prompt failed (only 1 character arrived). Scripts in `assignment-5/runner/` read the token from the **clipboard** instead; clear the clipboard and delete the token afterwards. The AI never sees tokens.
- Git push to the Gitea repo asks for credentials: use a token with `write:repository` in the credential window; delete it afterwards.
- SSH to the server works from the AI's PowerShell tool (Windows ssh with the `.pem` key), not from its bash tool.
- The manual's source of truth is the Gitea repo `group1-startup/manual`; `assignment-5/manual-repo/` here is only a mirror. Edit there, pull first, build with `ci/local-build.sh` or MiKTeX before pushing; the workflow fails on undefined references and the final PDF must come from a green run.
- Do not put grades, tokens, the admin IP or the AWS account ID in this public repo.
- Teardown afterwards (manual): Assignment 5 runner and image, Jenkins, then the Assignment 4 list in `assignment-4/BRAHMI.md`.

## BD owns: rows 1, 2, 3, 7 (50 points)
- **Row 1 — Jenkins deployment and persistence (10).** Official Jenkins LTS image pinned to an exact tag; non-secret Compose file in the
  `infra` repo; `/var/jenkins_home` on a named volume; restart policy; installed plugin versions; Droplet/instance memory and disk.
  Create named admin accounts. Restart test: restart the container and show settings and the job still there. **State that this is not a backup test.**
- **Row 2 — HTTPS, access, firewall (15).** DNS A record for the Jenkins hostname, Caddy site block, Let's Encrypt certificate and renewal
  (same Caddy), Jenkins URL and proxy headers, login required, named accounts and roles. **Give the clickable working URL
  `https://<ci-host>/login` and explain how the instructor opens it without signing in (gate G5).** Document the security group, host
  firewall and Compose ports. Dated external tests from another network: 443 works, 80 redirects, **raw 8080 and any agent port closed**
  (IPv4; IPv6 only if enabled). Labeled screenshot of the login page.
- **Row 3 — Gitea trigger and traceability (15).** Dedicated Gitea integration user with only the rights needed; webhook (push and pull
  request events) or polling fallback; delivery result and the matching Jenkins run for one real commit; adapted UML deployment diagram
  (browser path, webhook path, **where checkout and tests run**); one failed-delivery diagnosis (can be the real one if it happens, or the
  operator steps). Remember the Gitea private-address webhook restriction.
- **Row 7 — Credentials and build boundary (10).** Where each secret lives (Jenkins credentials, hints only), scope, who may edit the
  Jenkinsfile, **where builds run (controller or separate agent, gate G6)**, how untrusted PRs are kept from secrets, plugin-update
  check, and a short webhook/build troubleshooting procedure. If builds run on the controller, write the specific risk and the
  compensating restrictions.

## Also BD's
- Gates G1 (hosting, paid), G2, G3, G5, G6, G7 and **G8: apply branch protection with the Jenkins check as required on `twintrack` `main`**
  once you have read the exact status-check context from the first run on your bootstrap PR.
- **G4 bootstrap** (the Python example, the Jenkinsfile and the first PR): yours, so nothing waits for SD (section 3b).
- All server work, DNS, firewall and AWS changes, **done manually by you** (the AI assistant gives commands only, never stops, starts or deletes).
- Hosts and Passwords tables: Jenkins host row, Jenkins admin account hint, integration-user token hint, webhook secret hint (never values).
  Tell SD what changed so her history entry is accurate.
- Final PDF from the last green Gitea Actions run and the Canvas submission.

## Not BD's (SD's)
Rows 4, 5, 6, 8: the row 4, 5, 6 write-ups, the failure and repair PR (she authors it, or you author and she reviews), the two merge-gate
screenshots and the chapter's quality pass. You only build the bootstrap files (section 3b) so the pipeline can start. If something
there looks wrong, message SD.

## Detailed tasks (in order). You run every command that changes a resource; the AI assistant only reads and drafts.

### 0. Before anything (Oct 27)
1. Read `README.md` gates G1, G5, G6. Decide G1 (hosting) and G6 (controller or agent). **Check current EC2 prices yourself** before any resize; a resize needs the instance stopped and started again by you (the Elastic IP and DNS stay the same, Gitea is down for a few minutes).
2. Check free memory and disk on the server: `free -m`, `df -h /`. The Assignment 5 runner image is about 6 GB of the 20 GB disk.

### 1. Jenkins service (row 1)
1. In `~/jenkins/` on the server (new folder, like `~/gitea/`): a `docker-compose.yml` with the official `jenkins/jenkins` image **pinned to an exact LTS tag** (look the tag up on Docker Hub; do not use `lts` or `latest`), `restart: unless-stopped`, a named volume mounted at `/var/jenkins_home`, **no `ports:` section**, and the same Docker network Caddy uses (`gitea_web`) so Caddy can reach `jenkins:8080`.
2. `docker compose up -d`; read the one-time admin password from the container log or volume **on the server only; never paste it anywhere**.
3. In the browser: finish the setup wizard, install the plugins you need (Gitea, Pipeline, Git; Gitea Checks optional) and **record their versions** (Manage Jenkins, Plugins).
4. Create **named administrator accounts** (one for you, one for Sakshi) and turn off anonymous access. Set the Jenkins URL (Manage Jenkins, System) to the final HTTPS URL.
5. Restart test: create a small test job or setting, run `docker compose restart` (never `down -v`), reload, show it is still there. Screenshot it. Write in the chapter that this is **not a backup test**.
6. Evidence: image tag, `docker compose ps`, plugin list, volume name, memory and disk, restart before/after.

### 2. Hostname, HTTPS, access, firewall (row 2)
1. Name.com: add an A record for the Jenkins host (for example `ci`) pointing at the same Elastic IP as `git`; same TTL. Do not add an AAAA record.
2. Add a site block for the new hostname to the Caddyfile (`reverse_proxy jenkins:8080`), validate, reload Caddy; Let's Encrypt issues the certificate the same way as for Gitea. Keep the Caddyfile in the `infra` repo.
3. Decide G5 and implement it in the Caddy block (for example allow the team's addresses everywhere and everyone only on `/login`; check the exact syntax in the Caddy docs). **Test that you cannot lock yourself out** before relying on it.
4. Reverse-proxy headers and Jenkins URL: after the change, Jenkins' "reverse proxy setup is broken" warning must be absent.
5. External tests from **another network** (phone hotspot, as in Assignment 4), dated and with expected vs actual: 443 works; 80 redirects; **8080 and the agent port (50000) closed**; the login page URL opens. IPv4 only unless you added AAAA.
6. Security group: no new rule should be needed (80 and 443 are already open). Record the effective rules, the host firewall state and the Compose port mappings (none for Jenkins).
7. Evidence: working clickable URL, labeled screenshot of the login page, certificate issuer and expiry, redirect output, test listing.
8. Write the instructor access explanation (G5): exactly what URL to open and why no account is needed.

### 3. Gitea integration (row 3)
1. Create the **integration user** (for example `jenkins-bot`) in Gitea's admin page (registration is closed, so only an admin can); give it only what is needed on `twintrack` (reading the repository and reporting commit statuses; verify whether status reporting needs Write). Create a token for it with the narrowest scopes that work; store it **only in Jenkins credentials**; delete or rotate it after the assignment.
2. Gitea blocks webhooks to private addresses by default. Allow the Jenkins container (the `[webhook] ALLOWED_HOST_LIST` setting, in the Gitea environment in the Compose file), recreate only the Gitea container, and note the short downtime. Re-check with the existing persistence behavior (the volume is untouched).
3. In Jenkins add the Gitea server and a Multibranch Pipeline (or Organization Folder) for `group1-startup/twintrack`, using that credential.
4. In `twintrack` add a **repository webhook** for push and pull-request events to the Jenkins endpoint on the private network (verify the exact path for the plugin you installed), with a secret stored as a hint only.
5. Use "Test delivery" in Gitea; screenshot the delivery result. Match one real commit to its Jenkins run (commit ID in both).
6. Draw the adapted **UML deployment diagram** (copy the pattern of Figure 4.2 in the manual and the Assignment 4/5 TikZ figures): browser path, webhook path, and where checkout and tests run. Send SD or the manual the node list.
7. Write one **failed delivery diagnosis**: what you check first (webhook delivery list, Jenkins log, network name, secret, allowed host list).

### 3b. Bootstrap pull request (gate G4): you do this alone, before the server work if you like
`twintrack` has only README.md and CONTRIBUTING.md, so there is nothing for Jenkins to build yet. The manual provides the code (V1.38,
Chapter 4, step 4); copy it exactly.
1. In Gitea, `group1-startup/twintrack`, create the **issue** "Add pricing module, unit tests and Jenkinsfile for CI"; note its number `N`.
2. Clone `twintrack` (or use your clone), `git switch main`, `git pull --ff-only origin main`, `git switch -c issue-N-pipeline`.
3. Create `pricing.py`, `tests/test_pricing.py` and the root `Jenkinsfile` exactly as in the manual. Run `python3 -m unittest discover -s tests -v` and `python3 -m py_compile pricing.py` locally; both must pass. Save the output as evidence (70+).
4. Commit, `git push -u origin issue-N-pipeline`, open the **PR into `main` with `Closes #N`** in the description. **Do not merge it yet**: the branch rule needs Sakshi's approval, and you want the Jenkins check to run on it first. A multibranch job can already build the pushed branch, so Jenkins is testable before she looks at it.
5. Ask Sakshi for a real review whenever she has 10 minutes (she compares the files with the manual, runs the tests, comments, approves). If she is slow, nothing else is blocked.
6. Remember the Jenkinsfile's `agent any` needs `python3` on the executor; if the first run fails with "python3: not found", that is a Jenkins image or agent issue, not a code problem.

### 4. Required check (gate G8, for SD's row 5)
After the first Jenkins run on your bootstrap PR, read the exact status-check context from the PR page or the commit-status API (`/api/v1/repos/group1-startup/twintrack/commits/<sha>/statuses`). Then in Gitea, `twintrack`, Settings, Branches, protect `main`, turn on "Enable status check", add that exact context, keep one required approval and no direct pushes. Send SD the context text and tell her the check is on.

### 5. Credentials and build boundary (row 7)
1. List each secret, where it lives (Jenkins credentials store, Gitea webhook settings, your password manager), its scope and rotation; hints only.
2. State who can edit the Jenkinsfile (anyone with write access to `twintrack`: you and Sakshi) and what that means.
3. State where builds run. Controller: write the specific risk and the compensating restrictions (trusted authors only, no secrets for untrusted PRs, no Docker socket). Agent: set the controller's executors to 0 and show the agent's private connection and its checkout path to Gitea.
4. Plugin-update check: look at Manage Jenkins, Plugins, Updates, note the date and the result. A short webhook and build troubleshooting procedure (delivery list, Jenkins log, plugin errors, network).

### 6. Tables and finish
1. Hosts table: Jenkins host (same instance or new), role, ports (none published by Jenkins), owner, URL, backup (none).
2. Passwords table (hints only): Jenkins admin accounts, the integration user's token, the webhook secret. MFA status as reported.
3. Send SD the exact list of table changes for the history entry. Do the final read-through, download the PDF from the last green run, upload only that PDF.

## Checklist
- [ ] G4 bootstrap: issue + branch + Python example + Jenkinsfile + local test output + PR open (no one else needed) · [ ] Sakshi asked to review it
- [ ] G1 hosting decided · [ ] DNS + Caddy + certificate for the Jenkins hostname · [ ] Jenkins up (pinned tag), volume, admin accounts
- [ ] `/login` URL works over HTTPS · [ ] instructor access path decided and written (G5) · [ ] external tests dated (443, 80, 8080, agent)
- [ ] integration user + webhook + one delivery matched to a Jenkins run (G7) · [ ] restart test · [ ] plugin versions and update check
- [ ] required check applied on `twintrack` `main` (G8) · [ ] row 7 text · [ ] Hosts/Passwords updated · [ ] UML diagram data
- [ ] history + AI-log lines reviewed · [ ] final PDF downloaded from the last green run and submitted (PDF only)
- [ ] after grading (manual): Assignment 5 runner removal, Jenkins removal, then the Assignment 4 teardown list
