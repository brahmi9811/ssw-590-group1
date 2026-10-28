# SAKSHI (SD) — Assignment 6 scope and plan

Read `README.md` first (rubric, gates, dates). Course manual V1.38 Chapter 4 is the source of truth (`dosManual-V1.38.pdf`,
manual pages 15–22). **Due Nov 4, 2026, 11:59 PM.**

> **Note for SD (added Oct 28, 2026): please pull the latest `main` before you start or push anything.**
> Run `git pull --rebase` in this repo. Since your last push, `main` has gained the Assignment 6 plan (this folder) and an updated
> root `README.md`. The same applies to the Gitea `group1-startup/manual` repo: `git pull` there before you add the Jenkins chapter.
> If `git pull --rebase` reports a conflict, stop and tell BD instead of resolving it blind.

## SD owns: rows 4, 5, 6, 8 (50 points)
- **Row 4 — Versioned pipeline and tests (15).** Gate G4: the course's **Python example** goes into `group1-startup/twintrack`
  (`pricing.py`, `tests/test_pricing.py`, root `Jenkinsfile`; the full text is in the manual, Chapter 4 step 4). Do it through an
  **issue-linked PR** that follows `CONTRIBUTING.md` (branch `issue-<n>-...`, `Closes #<n>`, BD reviews). Run the tests locally first
  (`python3 -m unittest discover -s tests -v`). In the chapter: link the Jenkinsfile; describe the three stages (checkout, syntax check,
  test), dependencies, expected output and clean-run steps; include a run view with distinct stage results and the tested commit ID.
  Note: the executor needs `python3` (tell BD if the first run fails for that reason).
- **Row 5 — Required merge gate (15).** Find the **exact status-check context** Jenkins reports (Gitea commit-status API or the PR page)
  and give it to BD, who applies branch protection with it as a required check. You verify and capture **two labeled screenshots**:
  (1) the failed check blocking the merge, (2) the passing check after repair. Captions must give the date, commit ID and check context;
  link the PR and the matching Jenkins runs; explain how the status reaches Gitea (plugin or API).
- **Row 6 — Failure, repair, review (10).** On one issue-linked PR: introduce the controlled failure (manual's example: replace the
  multiplication in `total_price` with addition, push, the test must fail), show the blocked merge, push the repair, show the passing
  run and status, get BD's real review (not a placeholder comment), merge. Table with dated steps and commit IDs matched across Gitea
  and Jenkins. **Do not break the deployed Gitea or Jenkins.**
- **Row 8 — Manual quality and controls (10).** Scored as: coherent narrative with expected vs actual and corrections (4), readable dated
  sanitized screenshots and traceable links incl. both merge-gate states (3), document controls (3): version to 1.2, dated history entry
  naming the Hosts and Passwords updates (ask BD for the exact list), citations, glossary and index terms (Jenkins, pipeline, webhook,
  status check, controller, agent), the operator restart/troubleshooting note, and the activity diagram of the PR-to-merge flow
  (manual Figure 4.1) adapted to our run. Whole-PDF scan for `\Todo`, secrets, broken links. Do this last.

## Not SD's (BD's)
Rows 1, 2, 3, 7; Jenkins, DNS, certificates, firewall, the Gitea webhook and integration user, applying branch protection, and the
Hosts and Passwords tables (you only report your own account hints). If something there looks wrong, message BD.

## Can start now (no server needed)
1. Open the issue in `twintrack` for the pipeline work and create the branch.
2. Add the Python example and the Jenkinsfile; run the unit tests locally; keep the files exactly as the manual shows unless you have a reason.
3. Draft the chapter file for rows 4, 5, 6 in the Gitea `manual` repo (new chapter file, e.g. `devopsJenkins.tex`, with `\StatusPending`
   where nothing has run), following the Assignment 5 chapter pattern.

## Waits for BD
- Jenkins reachable and the webhook working before the first real run; the required check applied before the merge-gate screenshots.

## Detailed tasks (in order)

### 1. Application and Jenkinsfile (row 4, gate G4). Start now; no Jenkins needed.
1. Clone `https://git.ssw590-g1.tech/group1-startup/twintrack.git`. In Gitea, open a new **issue**, for example "Add pricing module with unit tests and a Jenkinsfile"; note its number `N`.
2. `git switch main`, `git pull --ff-only origin main`, then create the branch `issue-N-pipeline` (the repo's `CONTRIBUTING.md` convention).
3. Create exactly the three files from the manual (Chapter 4, step 4):
   - `pricing.py`: `total_price(unit_price, quantity)` raises `ValueError("Quantity must be positive")` when `quantity < 1`, else returns `unit_price * quantity`.
   - `tests/test_pricing.py`: a `unittest` class with `test_total` (`total_price(10, 3) == 30`) and `test_invalid_quantity` (`ValueError` for quantity 0).
   - `Jenkinsfile` at the repo root: declarative pipeline, `agent any`, `skipDefaultCheckout()`, stages Checkout (`checkout scm`), Syntax check (`python3 -m py_compile pricing.py`), Test (`python3 -m unittest discover -s tests -v`). Replace `agent any` with a label only if BD sets up an agent.
4. Run locally: `python3 -m unittest discover -s tests -v` (the tests must pass) and `python3 -m py_compile pricing.py`. Save the output as evidence (number 80+).
5. Commit, push the branch, and open the pull request into `main` with **`Closes #N`** in the description. Do not merge it yet (the branch rule needs BD's approval, and the Jenkins check should run first once BD has it ready).
6. Tell BD the PR is open so the first Jenkins run can be triggered.

### 2. First Jenkins run and the status context (row 4, input to row 5)
1. Once BD says Jenkins and the webhook work, push a trivial commit or ask BD to re-deliver the webhook; watch the run.
2. Capture a run view with the three stage results and the tested commit ID (screenshot, signed in as yourself or via the public page if it is reachable).
3. Find the **exact status-check context** the run reports to Gitea: open the PR page, or read the commit status API for the head commit (`/api/v1/repos/group1-startup/twintrack/commits/<sha>/statuses`). **Send the context text to BD** so the required check can be set. Do not guess the string.

### 3. Merge gate and the controlled failure (rows 5 and 6)
1. After BD applies the required check, make the **controlled failure** on the same feature branch: in `pricing.py` replace `unit_price * quantity` with `unit_price + quantity`, commit, push. The test must fail in Jenkins and the PR must show the merge blocked.
2. **Screenshot 1:** the failing check blocking the merge. Caption: date, commit ID, check context. Link the PR and the failed Jenkins run.
3. Push the **repair** (restore the multiplication). The new head commit must be tested and reported again.
4. **Screenshot 2:** the passing check, merge now allowed. Same caption fields. Link the passing run.
5. Ask BD for a **real review** (a comment with a point and an approval, not a placeholder), then merge. Confirm the issue closed automatically.
6. Record the dated sequence: failing commit ID, failed run number, blocked merge, repair commit ID, passing run number, review, merge time, all matched across Gitea and Jenkins. This is the row 6 table.

### 4. Chapter text (rows 4, 5, 6) in the Gitea `manual` repo
1. Pull first (`git pull` in your clone of `group1-startup/manual`). Create the new chapter file (for example `devopsJenkins.tex`, chapter label `Jenkins`), include it in `devopsITManual.tex`, with the eight numbered subsections in the manual's order and `\StatusPending` where nothing has run. Copy the Assignment 5 chapter's layout: status table, owner lines, figures with `\FigRef`, listings with `\ListRef`.
2. Fill rows 4, 5, 6 only from real runs. Evidence files go in `evidence/` of the manual repo and in `assignment-6/evidence/` here with an index row.
3. Build locally with `ci/local-build.sh` before pushing; the workflow fails on undefined references. Push to Gitea, check the run is green, then mirror to this repo.

### 5. Row 8 (do last, after BD's rows have real content)
1. Version 1.1 to **1.2**; dated history entry that links the new chapter and **names the Hosts and Passwords updates** (get BD's list).
2. Glossary and index terms (Jenkins, pipeline, webhook, status check, controller, agent), citations for the Jenkins and Gitea plugin docs the chapter uses, the **operator restart and troubleshooting note**, and the activity diagram of the PR-to-merge flow (the manual's Figure 4.1) adapted to the real runs.
3. Narrative check: every test has expected vs actual, every failure has a correction, every screenshot has a caption with date and commit ID.
4. Scan the built PDF for `TODO`, `PENDING` (only honest ones), `??`, secrets, tokens, addresses; add the AI-log lines.

## Checklist
- [ ] issue + branch + PR for the Python example · [ ] unit tests pass locally · [ ] Jenkinsfile in `twintrack`
- [ ] first Jenkins run on the PR (commit ID noted) · [ ] exact status-check context recorded · [ ] merge-gate screenshot 1 (blocked)
- [ ] repair pushed, passing screenshot 2 · [ ] real review, merge, issue closed · [ ] rows 4, 5, 6 written with inline evidence
- [ ] row 8 pass (version 1.2, history, glossary/index, troubleshooting note, activity diagram) · [ ] AI-log lines
