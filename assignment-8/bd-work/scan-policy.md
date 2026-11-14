# Security scan policy (Assignment 8, row 5) - BD, DRAFT, written before the release (course sec. 6.4.5)

Status: DRAFT Nov 12, 2026. The policy must be fixed in Git before the first release is scanned; a scan run before this file is committed would not count as following it.

## What is scanned, when, with what
| Check | Tool (pinned in the agent image) | Where in the pipeline | Command (exact flags are recorded with the run) |
|---|---|---|---|
| Python dependencies | pip-audit 2.10.1 | before the image build, on the lock file | `pip-audit -r requirements.txt --require-hashes --disable-pip` (works on SD's lock, evidence 172) |
| Secrets in the repository | Trivy 0.76.2 (`fs` scanner `secret`) | before the build, on the checked-out commit | `trivy fs --scanners secret --exit-code 1 .` |
| Vulnerabilities in the image | Trivy 0.76.2 (`image`) | after the build, before the push is promoted | `trivy image --severity HIGH,CRITICAL --exit-code 1 --ignore-unfixed=false IMAGE@DIGEST` |

The Trivy vulnerability database and the secret rules are downloaded when the scan runs. Their version and download time are recorded in the report header (`trivy --version` prints both).

## Policy
1. **Block** the pipeline on any detected **secret**, and on any **HIGH or CRITICAL** vulnerability in the image or in the Python dependencies.
2. **A scanner error, a missing report, or a database that could not be downloaded is a failure**, not a clean scan (non-zero exit code stops the stage; the report file must exist and be non-empty).
3. **Fixes first:** a finding with a fixed version is fixed (bump the dependency or the base image digest, rebuild, rescan). Nothing is ignored silently and there is no `|| true`.
4. **Unfixed or false-positive findings** need a written exception in `security/exceptions.md` in the repository, with the finding ID, the reason, the owner, and an **expiry date no later than 14 days** after it was written; it is reviewed in the pull request by the other person. An expired exception blocks the pipeline again. The instructor's acceptance is requested when an exception is used for the release.
5. **LOW and MEDIUM** findings are reported and listed in the manual but do not block; they are looked at before each later release.
6. **Reports** (JSON and a text summary) are archived with the build, with tool and database versions, scan time, command, and exit code. Reports are redacted: no secret value is ever printed (Trivy masks matches; the synthetic fixture below is not a real secret).
7. **Not covered, said plainly:** runtime protection, network attacks, supply-chain attacks on the registry, and vulnerabilities not yet in the databases. A green scan is a statement about known findings at that time only.

## One blocked pipeline (required demonstration)
- A **scanner-supported synthetic fixture**: a file with a fake credential in the format Trivy's secret rules match (for example a placeholder AWS-style key id and secret that AWS documents as example values), added in a **branch only**, never merged and never in the working image.
- Expected: the secret scan exits non-zero, the stage fails, the later stages do not run; the redacted report is archived. Then the fixture is removed, the commit is fixed, the pipeline passes. Both runs are kept as evidence with build numbers and exit codes.
- No live secret is committed and no deliberately vulnerable image is published as the working service.

## Credential and access controls (also row 5)
- Registry write token: Jenkins credential `gitea-registry-write` (created Nov 14, 2026 for the Gitea user `jenkins-bot`, scope package read and write only, with an expiry), bound only in the delivery stages on the agent (main branch). The `jenkins-bot` account itself is in the `developers` team with Write on code, pull requests and actions (evidence 209), so the token is scoped narrower than the account: a leaked token can publish packages but cannot change code. Registry read token: only if an anonymous pull of the public organisation's image fails (to be tested after the first push); it would live on the host for root's `docker login --password-stdin`. Tokens are typed by BD, never in Git, chat, command arguments, or logs.
- Deploy SSH key: Jenkins credential only; host key pinned in the agent's `known_hosts`; `deploy` user's sudo scope documented (effectively host administration).
- The agent has the Docker socket (root-equivalent); the node accepts only jobs labelled `delivery`; pull-request builds get no deploy credentials and no agent.
- Approvers (named, `input` with `submitter`): brahmi and sakshi; timeout 30 minutes; the actual approver and decision are written into the release record.
