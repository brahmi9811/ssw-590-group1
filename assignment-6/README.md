# Assignment 6 — Gitea + Jenkins Autobuild and Testing (course manual Chapter 4)

Group 1: Brahmi Dalvi (BD), Sakshi Deshpande (SD). **Due: Wednesday, November 4, 2026, 11:59 PM** (Canvas, group submission,
unlimited attempts, 100 points). Plan created October 27, 2026, so there are 8 days.

Source of truth: **Chapter 4, "Continuous Integration with Jenkins"** of the DOS manual **V1.38**
(`assignment-6/dosManual-V1.38.pdf`; Chapter 4 is manual pages 15–22), plus the common rules in Chapter 1 and Appendix A.
If anything here conflicts with the course manual, the manual wins.

**G0 done (Oct 27): V1.38 compared with V1.18.** The 8 subsections and the points per row are unchanged, but these requirements changed:
- Row 2: provide the **complete, working HTTPS URL of the Jenkins login page** (not just a hostname or screenshot) and explain how the
  instructor opens it through the approved access path **without signing in** (no grader account). IPv4 checks only; IPv6 optional.
- Row 4: an **optional ready-made Python example** (`pricing.py`, `tests/test_pricing.py`, full declarative `Jenkinsfile`) may be used as the
  application. It still counts only if we also do the PR, the Jenkins status, the protected-branch gate and the PDF evidence. The executor needs `python3`.
- Row 5: **two labeled screenshots** in the PDF (failed check blocking the merge; passing check after repair), captions with date, commit ID and check context.
- Row 7: builds may run on the **controller executor or a separate agent container** (agent recommended; controller executors = 0 if an agent is used). State the choice and show it in the diagram.
- Row 8 scoring: narrative 4 + supporting evidence 3 + document controls 3. New section 4.3: activity diagram of PR to merge (Figure 4.1).

**Submit only the compiled PDF** of the IT manual (version increased). Per our Assignment 5 practice, take it from a green Gitea Actions run.

## The assignment in short
A Gitea pull request on the product repo (`group1-startup/twintrack`) must trigger a **Jenkins pipeline**, show a **status on the
proposed commit**, and be **unmergeable while the required check fails**; after a repair it can be reviewed and merged.
1. Jenkins runs as a controlled service: official LTS image, versioned non-secret Compose file, persistent `/var/jenkins_home`, named admin accounts.
2. Own hostname (e.g. `ci.ssw590-g1.tech`) with valid HTTPS and a **working login-page URL** (`https://ci.ssw590-g1.tech/login`); login required; **no raw 8080 or agent port public**; browser access limited to approved sources, with a written explanation of how the instructor opens the login page.
3. Gitea to Jenkins integration: webhook (or polling fallback), a dedicated Gitea integration identity with minimal rights.
4. A `Jenkinsfile` in the product repo: checkout, a meaningful build/lint step, **one real automated test**, clear pass/fail. The course's Python example is allowed.
5. Branch protection on `main` with the Jenkins status as a **required check**; two screenshots: failed check blocking a merge, then the passing check after repair.
6. One issue-linked PR with a controlled failure (example in the manual: change the multiplication to addition), blocked merge, repair, passing status, peer review, merge.
7. Secrets in Jenkins credentials only; document who can edit the Jenkinsfile and where builds run (controller risk, or a separate agent).
8. The manual gets a new **"Continuous Integration with Jenkins" chapter** with 8 numbered subsections in rubric order, dated sanitized evidence, version up, history entry, Hosts/Passwords updated.

## Rubric (100 points) and owners (50 / 50)
| # | Rubric row (V1.38) | Pts | Owner |
|---|---|---|---|
| 1 | Jenkins deployment and persistence: image and tag, plugin versions, Compose, capacity, volume, restart policy, restart test (not a backup test) | 10 | BD |
| 2 | Working HTTPS login-page URL, access control, IPv4 firewall: clickable `https://.../login`, how the instructor opens it, labeled screenshot, DNS, certificate, redirect, renewal, Jenkins URL/proxy settings, named accounts and roles, firewall, external tests (443, raw 8080, agent port) | 15 | BD |
| 3 | Gitea trigger and traceability: adapted UML deployment diagram (shows where checkout and tests run), repo, integration identity, events, webhook/polling, delivery result, commit ID, linked Jenkins run, one failed-delivery diagnosis | 15 | BD |
| 4 | Versioned pipeline and tests: Jenkinsfile link, stages, dependencies, clean-run steps, run view with distinct stage results and commit ID | 15 | SD |
| 5 | Required merge gate: branch protection, exact status-check context, **two labeled screenshots** (failed blocks merge; passing after repair) with date, commit ID, context in captions; PR and Jenkins run links; how the status reaches Gitea | 15 | SD |
| 6 | Failure, repair, review: issue and PR links, dated sequence, commit IDs matched across Gitea and Jenkins | 10 | SD |
| 7 | Credentials and build boundary: secret storage and scope, who edits the Jenkinsfile, where builds run, untrusted PRs and secrets, plugin-update check, webhook/build troubleshooting procedure | 10 | BD |
| 8 | Manual quality and controls: coherent narrative with expected vs actual and corrections (4), readable dated sanitized screenshots and links incl. both merge-gate states (3), version, dated history, Hosts/Passwords hints, UML diagram, citations, glossary/index, restart/troubleshooting note (3) | 10 | SD |

**BD = 50 (rows 1, 2, 3, 7). SD = 50 (rows 4, 5, 6, 8).** Why this split: BD owns the server, DNS, certificates, firewall, Gitea
administration and credentials; SD owns the product code, tests, pipeline, PR workflow and the manual's final quality pass.
Row 5 needs Gitea owner rights: **BD applies the branch-protection setting and the required-check context when SD asks; SD owns
the verification, the two screenshots and the write-up** (same pattern as Assignment 4).

## Decisions and gates
| Gate | What | Who | Notes |
|---|---|---|---|
| G0 | Compare V1.38 with V1.18 | done | see the list at the top |
| G1 | **Where Jenkins runs.** The current `t3.micro` has about 1 GB RAM and already runs Gitea, Caddy and the Actions runner; Jenkins on top is likely to swap or fail. Options: (A) resize the same instance to a larger type, (B) a second instance, (C) keep it small and pause the Actions runner while Jenkins is graded. **Check current prices first; any paid change, stop or start is BD's manual step.** | BD decides | the Assignment 4 and 5 servers must stay up until those are graded |
| G2 | DNS A record for the Jenkins hostname, Caddy site block, certificate | BD | free; same pattern as `git.ssw590-g1.tech` |
| G3 | Jenkins up behind HTTPS with admin login and a working `/login` URL | BD | rows 1 and 2 |
| G4 | **Application.** `twintrack` has only README.md and CONTRIBUTING.md today. Decision: **use the course's Python example** (`pricing.py`, `tests/test_pricing.py`, `Jenkinsfile`), committed to `twintrack` through an issue-linked PR. An own TwinTrack app is allowed but not planned | SD | removes the biggest schedule risk |
| G5 | **Instructor access path (row 2).** Browser access must be limited to approved sources, yet the instructor must be able to open the login URL without an account. Options: (a) leave only the `/login` page reachable by everyone and restrict the rest to team addresses, (b) ask the instructor for a source address range, (c) another documented path. If unsure, email the instructor | BD decides | write the explanation into the chapter |
| G6 | Where builds run: controller executor (document the risk) or a separate agent container (set controller executors to 0; needs Git, Python, private network, checkout path to Gitea) | BD decides, SD informed | row 7, row 3 diagram |
| G7 | First webhook delivery reaches Jenkins and a build runs on a PR | BD + SD | row 3 |
| G8 | Required status check configured; failed check visibly blocks a merge | BD applies, SD verifies | row 5 |

## Plan by day (all dates 2026)
| When | BD | SD |
|---|---|---|
| Oct 27–28 | G1, G2, G5, G6 decisions; start Jenkins | G4: open the issue, add the Python example and `Jenkinsfile` on a branch; run the tests locally |
| Oct 29–30 | HTTPS, firewall and external tests; integration identity; webhook (G3, G7) | Open the PR; first Jenkins run; note the exact status context |
| Oct 31–Nov 1 | Apply the required check (G8); restart test; plugin-update check | Controlled failure (multiplication to addition), blocked-merge screenshot, repair, passing screenshot, review, merge (rows 5, 6) |
| Nov 2 | Row 7 text, Hosts/Passwords, UML diagram data | Row 8 draft; text for rows 4 to 6 |
| Nov 3 | Final read-through, build from Gitea, download the PDF | Final read-through |
| **Nov 4** | **Submit by midday; the deadline is 11:59 PM** | spare day for failures |

## Known gotchas (verify each against current docs before relying on it)
- Gitea blocks webhooks to private addresses by default (`[webhook] ALLOWED_HOST_LIST`); a Jenkins container on the Docker network needs that setting, or a public HTTPS webhook endpoint.
- Do not publish Jenkins 8080 or an agent port; Caddy proxies `ci...` to the Jenkins container. Do not open the whole Jenkins UI only to receive a webhook.
- The stock Jenkins image may not contain `python3`; the manual says the executor must have it (controller image, or a trusted agent container).
- A green Jenkins page or a delivered webhook is not a passing merge gate: record the exact status-check context from Gitea's commit-status API and make that the required check.
- Each corrective push creates a new head commit; the check must be re-reported on the latest head commit.
- Pin the Jenkins image to an exact tag and record plugin versions (Gitea plugin; Checks plugin optional).
- Builds on the controller are allowed only with the risk written down, trusted pipeline authors, and no secrets for untrusted PRs.
- The Assignment 5 runner image uses about 6 GB of disk; removing it is BD's manual step after Assignment 5 is graded.

## Working agreement (same as Assignments 4 and 5)
1. `git pull --rebase` before you start and before you push. Commit and push only when the human says so. The manual's source of truth is the Gitea repo `group1-startup/manual`; this repo mirrors it (edit in Gitea, pull first).
2. Edit only your own rows or regions; for the other person's area, send a message.
3. Never fabricate output, screenshots, dates or results. Unrun is `\StatusPending`. Failed attempts are documented.
4. Never put tokens, passwords, webhook secrets, private keys or `.env` values in chat, the repo, logs or the PDF. Delete personal access tokens after use.
5. No paid cloud change, firewall change, or stopping/starting/deleting of AWS resources by the AI assistant; BD does those manually.
6. Evidence goes inside the PDF; numbered files in `assignment-6/evidence/` (BD 70+, SD 80+) with an index row.
7. Version the manual to 1.2 and add a history entry naming the Hosts and Passwords changes; add AI-log lines.
