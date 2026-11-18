# Decisions (D1 to D10) and the decision log

"Decided" means BD and SD decided it (the split and roles were checked together; the tool pair and the other items on Nov 17 and 18); "later" means we leave it open on purpose and the default applies if nothing else is said. Nothing is built on an open decision that blocks it.

| # | Decision | Options | Status and recommendation | Who |
|---|---|---|---|---|
| D1 | **How the demo push starts the pipelines** | one push starts both tools; separate triggers | **Decided in principle:** one push on GitHub starts GitHub Actions (hosted) and, through a GitHub webhook, Jenkins on our new server; a manual "Build Now" is the fallback. Jenkins is the main show (stage view, runs where the load is visible). | both |
| D2 | **Repository and code** | the assignments repository; a Gitea repository; a small new GitHub repository | **Decided: a small new GitHub repository** (proposal name `ssw590-g1-devops-pipeline`, public recommended, under BD's account with SD as collaborator), separate from the assignments. The code is a small Python service with a few classes (so pyreverse draws something useful) and tests. | both |
| D3 | **What the LaTeX stage compiles** | the whole report (several minutes); a small `docs/` architecture document (about one minute) | **Later;** default: the small `docs/` document in the live run; the report is built by the pipeline as a separate artifact. | SD |
| D4 | **The changelist** in `major.minor.changelist` | Git commit count; CI build number; counter file | **Later;** default: Git commit count (`git rev-list --count HEAD`), identical for both tools for the same commit. `major.minor` from `VERSION`. | both |
| D5 | **Artifact** | ZIP; image tag; both | **Later;** default: a ZIP `twintrack-<version>.zip` with code, the compiled PDF and the diagrams, plus an image tagged with the same version. | SD |
| D6 | **Reverse documentation tool (bonus)** | pyreverse with Graphviz; Doxygen with Graphviz | **Later;** default: pyreverse (Pylint) with Graphviz; go for both bonuses (demo +5, report +5) if time allows. | SD |
| D7 | **The two tools for the SWOT** | Jenkins and GitHub Actions; Jenkins and Gitea Actions | **Decided: Jenkins and GitHub Actions**, as in the submitted proposal. An earlier draft recommended Gitea Actions; that was a drift and is withdrawn. Gitea Actions is cited only as a close relative. | both |
| D8 | **Where the pipeline runs and where the load is shown** | the assignments server; a new server | **Decided: a new, separate AWS server** for the project (`ENVIRONMENT.md`). Assignments 6 to 9 keep their own infrastructure. | BD |
| D9 | **Cloud load demonstration** | Grafana panels with a short refresh; `htop` or `docker stats` beside it; both | **Later;** default: both, rehearsed to see the real picture before changing any scrape interval (Prometheus samples every 30 s). | BD |
| D10 | **The final report** | a chapter in the assignments manual; a separate document that follows the manual | **Open until the instructor answers.** Preference: a separate document following the manual's structure and template, with the required chapter title *Configuring and Running the DevOps Pipeline*, built by the pipeline from `report/`. BD will record the answer here after confirming with the professor. | both |

## Open questions for the instructor
1. The Canvas text says "Add a chapter describing your DevOps project". Does a separate final-project document, built with the manual's template and containing that chapter, satisfy it, or must it be added to our existing manual?
2. The demo is on Dec 14 while Canvas shows Dec 7 as the due date: what must be submitted by Dec 7, if anything?
3. The report rubric lists nine rows of 10 points (90) but the text says 100 points plus 10 bonus. Which is right?
4. Are Gitea (our assignments) and a new GitHub repository for the demo both fine, with GitHub as the demo's source control?

## Decision log
| Date | Decision | Taken by | Note |
|---|---|---|---|
| 2026-11-17 | D7: the two tools for the SWOT are **Jenkins and GitHub Actions** (as in the proposal) | BD and SD | Gitea Actions stays what builds the assignments manual and is cited only as a relative. |
| 2026-11-17 | Roles revised from the proposal's section 5.11 to the split in `TASKS.md` | BD and SD | The proposal was a baseline; the split follows what each of us built since October; it was checked together and needs no further confirmation. |
| 2026-11-18 | D2: a small new GitHub repository for the demo | BD and SD | The issue, commit and push happen on GitHub. |
| 2026-11-18 | D1: Jenkins starts from a GitHub webhook (a small change on the new Jenkins is accepted) | BD | A manual button is the fallback. |
| 2026-11-18 | D8: a new, separate AWS server for the project | BD | Not the assignments server. Created after Assignment 8 is submitted; budget alert first. |
| 2026-11-18 | D10: preference for a separate report document following the manual; **decision pending the professor's answer** (BD will tell us) | BD | Open question 1 for the instructor. |
| 2026-11-18 | Demo planning date: Dec 7 (internal deadline); the live demo is Dec 14 | BD | Report due Dec 17. |
| 2026-11-18 | D3, D4, D5, D6, D9 decided later | BD | Defaults apply. |
