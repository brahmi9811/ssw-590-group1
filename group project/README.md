# Group Final Project (Group 1): one end-to-end pipeline, a live demo and a final report

Group 1: Brahmi Dalvi (BD) and Sakshi Deshpande (SD). Specification: the instructor's Canvas text in `CANVAS.md` (pasted Nov 17, 2026). Background: our approved proposal `devopsAssignment-1.pdf` (Assignment 3, TwinTrack, **GitHub Actions versus Jenkins**).
Status: **plan and decisions ready to be committed to the repository (Nov 18, 2026).** Decisions already taken are in `DECISIONS.md` (log at the bottom); the open ones are the report format (waiting for the professor) and the "later" items with defaults.

## What is graded (from Canvas)
| Item | When | What |
|---|---|---|
| **Final Project Demo** | Canvas due Mon **Dec 7, 2026**, 11:59 pm; the live 20-minute demonstration with Q/A is on **Mon Dec 14** (we plan to Dec 7 as our internal deadline) | 10 rows x 10 points (issue comment, commit, pipeline trigger, build visibility, tests, versioned artifact `major.minor.changelist`, SWOT of two tools, configuration files, demo quality, cloud execution with load changes) plus 5 bonus for reverse architecture documentation |
| **Final Project Report** | Thu **Dec 17, 2026**, 11:59 pm | a chapter called **Configuring and Running the DevOps Pipeline**: the V-curve steps a) to h) with one tool each, a SWOT chart of two tools, the configuration files documented, update history and links; bonus +5 cloud execution configuration, +5 reverse documentation configuration |

The final project is **smaller than the proposal**: one pipeline run live from change to versioned artifact, with two CI/CD tools compared. We follow the Canvas text and say in the report how the delivered project relates to the proposal.

## Decisions taken (Nov 17 to 18, by BD and SD)
- The two tools for the SWOT are **Jenkins and GitHub Actions**, as in the proposal.
- The demo lives in a **small new GitHub repository**, separate from the assignments repository. The issue, the commit and the push happen on GitHub; **GitHub Actions** starts there and **Jenkins** on our own AWS server starts from the same push through a GitHub webhook.
- The project gets its **own new AWS server**, separate from the assignments server (Assignments 6 to 9 stay untouched). See `ENVIRONMENT.md`.
- The final report: the preference is a **separate document** that follows the manual's structure and template, not a chapter of the assignments manual (the chapter keeps the required title). **Pending the professor's answer;** BD will tell us (open question 1 in `DECISIONS.md`).
- Roles are revised from the proposal (it was a baseline): the split in `TASKS.md`, checked together and agreed.
- Smaller choices (changelist rule, artifact format, LaTeX document size, bonus scope) are decided later; defaults are in `DECISIONS.md`.

## The demo, step by step (what we must do live in 20 minutes)
1. On GitHub, open an existing issue and post a comment describing the fix we are about to make.
2. Change a LaTeX document or the code, commit with a clear message, push.
3. The pipelines start: GitHub Actions on GitHub, Jenkins on our server (automatic on push, with a manual button as a fallback).
4. They visibly show: **compile LaTeX**, **build/compile the code**, **package**.
5. **Automated tests** run with a visible pass or fail.
6. An artifact is produced with the version **major.minor.changelist** (ZIP, and an image tag).
7. Show the SWOT chart of the two tools; show and explain the configuration files.
8. Show the pipeline running on the **cloud server** and the **system load** (CPU, memory, disk) changing while it runs.
9. Bonus: the output contains **architecture diagrams generated from source code** (for example pyreverse with Graphviz).

## What we can reuse from Assignments 4 to 8 (knowledge and files, not the server)
| Need | Existing asset | Gap |
|---|---|---|
| Jenkins pipeline with trusted agent, approval, scans | `Jenkinsfile` of the delivery pipeline and the agent image (Assignment 8) | a new Jenkins on the new server, a smaller pipeline with the demo stages (LaTeX, build, reverse documentation, tests, package) |
| Monitoring | Prometheus, Grafana, Blackbox and Node Exporter configuration (Assignment 7) | reinstall on the new server; panels for the load during a run |
| LaTeX build in a container | TeX Live container and a Gitea Actions workflow for the manual (Assignment 5) | a small `docs/` document that compiles in about a minute; a lighter TeX Live image for the new server (disk) |
| Tests | `unittest` for the course code and the pricing service | tests in the new repository |
| Versioned images | image per commit (Assignment 8) | the `major.minor.changelist` scheme |
| HTTPS and proxy | Caddy configuration | DNS names and certificates for the new server |
| Evidence discipline, scan policy, runbooks | `assignment-8/bd-work/scan-policy.md`, evidence index format | reuse where the demo needs them |
| **Not built yet** | | the GitHub repository, the GitHub Actions workflow, the GitHub webhook to Jenkins, the new server, the reverse-documentation step, the `major.minor.changelist` scheme, a rehearsed load view, the SWOT of Jenkins and GitHub Actions, the report |

## Approach
- **New repository on GitHub** (public recommended: unlimited Actions minutes and easy grading, holding only synthetic code; name proposal `ssw590-g1-devops-pipeline`): `src/` (a small Python service with a few classes so the diagrams mean something), `tests/`, `docs/` (a small LaTeX architecture document), `report/` (the final report, built by the pipeline), `.github/workflows/pipeline.yml`, `Jenkinsfile`, `Dockerfile`, `VERSION`, `scripts/`, `deploy/` (the new server's non-secret configuration: Compose, Caddyfile, `prometheus.yml`, Grafana dashboard).
- **One set of stages** in both tools, with identical names: Checkout, Compile LaTeX, Build, Reverse documentation, Test, Package, Version and archive.
- **Version** `major.minor` from `VERSION` plus a changelist from the commit being built, for example `1.0.245` (rule decided later; recommendation in D4).
- **New AWS server** (`ENVIRONMENT.md`): Docker, Caddy (HTTPS), Jenkins with an agent, Prometheus, Grafana, Node Exporter, a TeX Live image; built after Assignment 8 is submitted; budget alert first; stopped or destroyed after grading.

## Schedule (New York time; Assignment 8 first)
- **Nov 18 to 24:** Assignment 8 (due Nov 24). For the project: decisions and plan files only; no new server and no AWS spend yet.
- **Nov 25 to 29:** budget alert; new server and DNS; the GitHub repository and layout; the Jenkins and Caddy installation; first end-to-end run (T13, T1, T14).
- **Nov 30 to Dec 3:** both pipelines complete with all stages, versioning, reverse documentation, tests; load view rehearsed (T3 to T8).
- **Dec 4 to 6:** SWOT, configuration walkthrough, run sheet, two full rehearsals with a stopwatch; freeze on Dec 6 (T9 to T11).
- **Dec 7:** internal deadline and the Canvas due date of the demo item: everything works and is recorded.
- **Dec 8:** Assignment 9 is due (its work is on the assignments server and in parallel).
- **Dec 9 to 13:** final rehearsal, fixes only. **Dec 14:** the live demonstration (confirm the slot).
- **Dec 9 to 17:** write and build the report (T12); submit by **Dec 17, 11:59 pm**.

## Working agreement
- The new GitHub repository is the source of truth for the project; the planning files in this folder are kept in the assignments repository (GitHub `group project/`). Pull before push; edit only your own files; review each other's changes through pull requests on the new repository.
- No fabricated output, times, versions or screenshots: every number in the demo and the report comes from a logged run. No tokens, passwords, webhook secrets or keys in chat, Git, logs or the report; the planted fake secret in the fixture, if used, is obviously synthetic.
- No paid cloud change (new instance, disk, IP) by the AI assistant without the owner's explicit authorization for that step; BD does or authorizes AWS changes and DNS.
- Do not touch the assignments server for the project; Assignments 6 to 9 keep their own infrastructure.
- Evidence numbering: **SD 500-549, BD 550-599**, index in `evidence/README.md`.

## Files in this folder
`README.md` · `TASKS.md` (tasks T1 to T14) · `DECISIONS.md` (D1 to D10 and the decision log) · `ENVIRONMENT.md` (the new server and repositories) · `Brahmi.md`, `Sakshi.md` · `report/OUTLINE.md` · `evidence/README.md` · `CANVAS.md` · `devopsAssignment-1.pdf`.
