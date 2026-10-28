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

## What you can do any time (nothing here waits for BD)
1. `git pull --rebase` in this repo; read `README.md` (dependency rule and gates) and this file.
2. Run the course example's unit tests on your own machine (copy the three files from the manual into a scratch folder, **not** the repo) so you know how they behave: `python3 -m unittest discover -s tests -v`.
3. Start the chapter skeleton for the Jenkins chapter in the Gitea `manual` repo (new file, for example `devopsJenkins.tex`, `\StatusPending` where nothing has run), following the Assignment 5 chapter pattern.
4. Prepare row 8 pieces that need no evidence: glossary and index terms, citations, the history entry draft (version 1.2; BD gives you the Hosts and Passwords list later), the activity diagram of the PR-to-merge flow.

## Your three hand-off points with BD (everything else is yours alone)
1. **Review and approve BD's bootstrap pull request** on `twintrack` when she asks (the branch rule needs a second person). A real review: read the files, leave at least one comment or question, then approve. About 10 minutes.
2. **The failure and repair PR** (rows 5, 6) once BD says the required check is on: you author it, BD reviews. *If you are busy, tell BD and she authors it while you only review (either person may author; the other reviews).*
3. **Write rows 4, 5, 6, 8** from the real runs. BD sends you the commit IDs, run numbers and the exact status-check context.

## Detailed tasks (in order)

### 1. Row 4 (pipeline and tests): BD builds the first version; you review and write it up
**BD creates** the issue, the branch `issue-N-pipeline`, and the three files from the manual (`pricing.py`, `tests/test_pricing.py`,
root `Jenkinsfile`), runs the tests locally, and opens the PR with `Closes #N`. **You:**
1. When BD tells you the PR is open, review it as a real second pair of eyes: compare the three files with the manual's Chapter 4 step 4
   text, run `python3 -m unittest discover -s tests -v` and `python3 -m py_compile pricing.py` on the branch, leave at least one comment
   or question, then approve. Save your local test output as evidence (number 80+).
2. Do not merge until BD confirms the Jenkins run on that PR has the three distinct stage results.
3. For the chapter: link the Jenkinsfile; describe the three stages (Checkout, Syntax check, Test), dependencies (Python 3 on the
   executor, no other packages), expected output and clean-run steps; include a run view with distinct stage results and the tested commit ID.

### 2. Status context and run view (row 4, input to row 5): BD gets them, you record them
BD sends you the first run's number, the commit ID and the exact status-check context text. Open the PR page or the commit-status API
for that head commit (`/api/v1/repos/group1-startup/twintrack/commits/<sha>/statuses`) and check the string matches. Take the run-view
screenshot with the three stage results. Tell BD if the context differs from what she applied as the required check.

### 3. Merge gate and the controlled failure (rows 5 and 6)
1. After BD's bootstrap PR is merged and she says the required check is on, open a **new issue** (for example "Verify the merge gate with a controlled failure") and a branch `issue-M-merge-gate` from the updated `main`, then make the **controlled failure** there: in `pricing.py` replace `unit_price * quantity` with `unit_price + quantity`, commit, push, and open the PR with `Closes #M`. The test must fail in Jenkins and the PR must show the merge blocked. (If you are busy, BD can do this step and you only review.)
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
- [ ] pulled `main`, read the plan · [ ] example's tests run locally (scratch folder) · [ ] chapter skeleton started in the Gitea `manual` repo
- [ ] hand-off 1: reviewed and approved BD's bootstrap PR (real review) · [ ] status context checked against BD's required check
- [ ] hand-off 2: failure and repair PR (or BD authors, you review): screenshot 1 blocked, screenshot 2 passing, real review, merge, issue closed
- [ ] hand-off 3: rows 4, 5, 6 written with inline evidence from BD's commit IDs and run numbers
- [ ] row 8 pass (version 1.2, history, glossary/index, troubleshooting note, activity diagram) · [ ] AI-log lines
