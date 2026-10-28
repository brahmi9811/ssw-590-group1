# BRAHMI (BD) — Assignment 6 scope and plan

Read `README.md` first (rubric, gates, dates). Course manual V1.38 Chapter 4 is the source of truth. **Due Nov 4, 2026, 11:59 PM.**

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
  when SD gives you the exact status-check context.
- All server work, DNS, firewall and AWS changes, **done manually by you** (the AI assistant gives commands only, never stops, starts or deletes).
- Hosts and Passwords tables: Jenkins host row, Jenkins admin account hint, integration-user token hint, webhook secret hint (never values).
  Tell SD what changed so her history entry is accurate.
- Final PDF from the last green Gitea Actions run and the Canvas submission.

## Not BD's (SD's)
Rows 4, 5, 6, 8: the application, tests and Jenkinsfile, the PR workflow, the two merge-gate screenshots and the chapter's quality pass.
If something there looks wrong, message SD.

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

### 4. Required check (gate G8, for SD's row 5)
When SD gives you the exact status-check context: Gitea, `twintrack`, Settings, Branches, protect `main`, turn on "Enable status check", add that context, keep one required approval and no direct pushes. Tell SD it is done.

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
- [ ] G1 hosting decided · [ ] DNS + Caddy + certificate for the Jenkins hostname · [ ] Jenkins up (pinned tag), volume, admin accounts
- [ ] `/login` URL works over HTTPS · [ ] instructor access path decided and written (G5) · [ ] external tests dated (443, 80, 8080, agent)
- [ ] integration user + webhook + one delivery matched to a Jenkins run (G7) · [ ] restart test · [ ] plugin versions and update check
- [ ] required check applied on `twintrack` `main` (G8) · [ ] row 7 text · [ ] Hosts/Passwords updated · [ ] UML diagram data
- [ ] history + AI-log lines reviewed · [ ] final PDF downloaded from the last green run and submitted (PDF only)
- [ ] after grading (manual): Assignment 5 runner removal, Jenkins removal, then the Assignment 4 teardown list
