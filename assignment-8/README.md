# Assignment 8: Secure Delivery and Rollback (course Chapter 6)

Group 1: Brahmi Dalvi (BD) and Sakshi Deshpande (SD). Course manual: `dosManual-V1.43.pdf` (Chapter 6, PDF pages 55-64).
Starter bundle from the course: `starter/` (the `Examples/dosSecureDelivery` folder of Examples.zip, without macOS files).
Due date: see Canvas.

## In one paragraph
Release the course's small **Startup Pricing Service** (Flask + Gunicorn, v1 = USD 10 per unit, v2 = USD 12) on our server
through a secure pipeline: Jenkins (on a **trusted agent**) runs tests, dependency/secret/image scans, builds **one image per
reviewed commit**, pushes it to the **Gitea container registry**, and **Ansible** deploys that exact image digest to **staging**,
then, after a **restricted human approval**, the same digest to **production**. Then release v2, and practise two recoveries:
roll production back to v1, and recover staging from a deliberately broken deployment. Correlate with the Chapter 5 monitoring.
The IT manual gets a new chapter, *Secure Delivery and Rollback*.

## Rubric and owners (100 points, split 50/50)

| # | Criterion (course sec. 6.6) | Pts | Owner |
|---|---|---|---|
| 1 | Working v1/v2 service, meaningful tests, source identity and locked build inputs | 10 | **SD** |
| 2 | Immutable image publication and traceability; same digest promoted | 10 | **SD** |
| 3 | Ansible deployment, environment separation, valid HTTPS and unchanged rerun | 20 | **SD** |
| 4 | Jenkins gates, restricted recorded approval and verified v2 promotion | 15 | BD |
| 5 | Security scan policy, reports, blocked fixture and credential/access controls | 15 | BD |
| 6 | Both recovery cases, matching configuration restoration and measured verification | 15 | BD |
| 7 | Monitoring correlation and clear operational/state limitations | 5 | BD |
| 8 | Complete PDF manual, diagram, release records, accessible links and runbooks | 10 | **SD** |

Why this split: rows 1-3 make 40 points and adding row 4 would make 55, so SD takes rows 1, 2, 3 + row 8 (= 50) and
BD rows 4, 5, 6, 7 (= 50). It also follows the infrastructure: BD owns Jenkins, its credentials and the server
(agent, approval, scans, recovery runs, monitoring); SD owns the application, image, Ansible deployment, release records,
diagram and runbooks. Row 8's final PDF build stays a joint step (as in Assignments 6 and 7).

## Gates (decisions before anything is deployed)

| Gate | Decision | Who |
|---|---|---|
| G1 | **Trusted Jenkins agent**: today Jenkins has no agent and no Docker, Ansible, Trivy or pip-audit (evidence 170). Choose the agent design (recommended: a dedicated agent container on the server with Docker CLI + build access, Python, Ansible venv, Trivy, pip-audit; its Docker access is root-equivalent and is documented) and record the tool versions. | BD |
| G2 | **Capacity**: 768 MiB available, 225 MiB in swap, 6.4 GB disk free (evidence 170). Builds and Trivy add load; the agent image, Trivy DB and app images need disk. Decide whether to stop the Assignment 5 Actions runner during this work. | BD |
| G3 | **DNS**: `staging.ssw590-g1.tech` and `app.ssw590-g1.tech` -> 52.73.254.36. | BD |
| G4 | **Caddy routes**: SD's draft `sd-work/Caddyfile.pricing-block.txt` (validated). Both hosts public (reason in the file). | SD drafts, BD applies |
| G5 | **Deploy account** on the host: user `deploy`, SSH key (private key only in Jenkins credentials), non-interactive sudo for `become` (document its scope: effectively host admin). Pin the host key in the agent's `known_hosts`. | BD |
| G6 | **Registry credentials**: a Gitea token with package-write for the agent (Jenkins credential) and a package-read token for root's `docker login --password-stdin` on the host. Tokens are created and typed by a human, never by the AI, never in Git/chat/logs. Note: the `group1-startup` org is public, so its packages may be publicly pullable; decide and document. | BD |
| G7 | **Pipeline shape**: delivery stages only for `main` on the trusted agent; PR builds never see deploy credentials; `disableConcurrentBuilds`; approval with `input` restricted to named approvers and a timeout. Who approves? | BD (SD reviews) |

## Working agreement (same as Assignments 6 and 7)
- Gitea is the source of truth; GitHub `assignment-8/` is the backup. Pull (`--rebase`) before every push; edit only your own regions.
- The application goes into `group1-startup/twintrack` via issue, branch and reviewed PR (protected `main`).
- No fabricated output, dates or screenshots. No tokens, passwords, keys or webhook URLs in chat, Git, logs or the PDF.
- No paid cloud change, firewall, DNS or AWS change by the AI assistant; BD does those. Never `docker compose down -v`, never prune.
- Keep Gitea, Jenkins, Caddy and the monitoring stack working; Assignment 7's evidence stays valid.
- Evidence numbering: SD 170-199, BD 200-229.
