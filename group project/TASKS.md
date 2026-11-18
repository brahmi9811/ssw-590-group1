# Tasks T1 to T14 (mapped to the Canvas demo steps and the report rubric)

Status as of Nov 18, 2026. Owners are the agreed split (the proposal was a baseline; its original roles are listed at the bottom). "Rubric" gives the demo rows (D1 to D10, plus the bonus) and the report rows (R1 to R9, plus bonuses) a task supports. Dates follow `README.md`; the live demo is Dec 14, our internal deadline is Dec 7.

| ID | Task | Supports | Owner | Reviewer | Status | Target |
|---|---|---|---|---|---|---|
| T1 | **New GitHub repository and layout**: create `ssw590-g1-devops-pipeline` (BD creates under her account and adds SD; public), `src/` (a small Python service with a few classes), `tests/`, `docs/` (small LaTeX architecture document that compiles in about a minute), `report/`, `scripts/`, `VERSION` (`major.minor`), README, branch protection and PR review | D2, D4, D5, R2 | SD (layout), BD (repository creation) | BD | Open | Nov 27 |
| T2 | **Issue and commit script**: a demo issue on GitHub with a clear description; the exact comment to post; the change to make (one LaTeX line and one code line); the commit message; rehearsed | D1, D2, R1, R2 | SD | BD | Open | Nov 29 |
| T3 | **Versioning** `major.minor.changelist`: `VERSION` plus the changelist rule (decided later, default the Git commit count); naming of the ZIP and the image tag; printed in both pipelines' logs and shown in the artifact name | D6, R6 | SD | BD | Open | Dec 1 |
| T4 | **Tests stage** with visible pass or fail (`unittest`, optional JUnit report); one deliberately failing branch for the Q/A | D5, R5 | SD | BD | Partly (tests exist in the assignments, not in this repository) | Dec 1 |
| T5 | **Reverse documentation** (bonus): `pyreverse` and Graphviz in both pipelines; class and package diagrams copied into the package and into the LaTeX output | demo bonus, report bonus, R-c | SD | BD | Open | Dec 2 |
| T6 | **Jenkins pipeline for the demo** on the new server: stages Checkout, Compile LaTeX (TeX Live container), Build, Reverse documentation, Test, Package, Version and archive; started by the GitHub webhook and by a manual button; stage names identical to the Actions workflow; about five minutes or less | D3, D4, D5, D6, R3 to R6 | BD | SD | Partly (the Assignment 8 delivery `Jenkinsfile` is the model; this one is smaller and new) | Dec 2 |
| T7 | **GitHub Actions workflow** `pipeline.yml` doing the same job on a GitHub-hosted runner: same stage names, same artifact name; ported from our Gitea Actions manual workflow where possible | D7, R7, R8 | SD | BD | Open (only a Gitea Actions workflow exists) | Dec 2 |
| T8 | **Cloud load view** on the new server: Grafana panels for CPU, memory, disk and network with a short refresh, a terminal with `docker stats` or `htop` beside it, one rehearsed run in which the load visibly rises and falls; the 30-second scrape limit noted | D9, R bonus cloud | BD | SD | Partly (panels exist on the assignments server; the new server needs them) | Dec 3 |
| T9 | **Configuration walkthrough**: one short page per file (`pipeline.yml`, `Jenkinsfile`, `Dockerfile`, `docker-compose.yml`, `Caddyfile`, `prometheus.yml`, dashboard JSON, `version.sh`, `package.sh`): what it does for the pipeline and the settings that matter; links to the files | D8, R8 | BD | SD | Open | Dec 4 |
| T10 | **SWOT of Jenkins and GitHub Actions** (the proposal's pair) from first-hand logged facts (setup effort, maintenance, security model, speed, cost, failure modes met); four quadrants per tool, "evidence" lines filled where a number exists | D7, R7 | both (BD drafts Jenkins, SD drafts GitHub Actions) | each other | Open (the proposal has a preliminary SWOT to revise) | Dec 5 |
| T11 | **Demo script and rehearsals**: a 20-minute run sheet with times and who speaks, Q/A topics, a fallback for each step that can fail (webhook, slow build, network), two full rehearsals with a stopwatch on the real server | D9 | both | | Open | Dec 6 |
| T12 | **Final report** (separate document following the manual's structure and template, with the chapter *Configuring and Running the DevOps Pipeline*): V-curve tools a) to h), the pipeline, versioning, SWOT, configuration files, update history, links; built by the pipeline from `report/`; submit | R1 to R9, bonuses | both | each other | Open | Dec 17 (draft Dec 10) |
| T13 | **New project server**: AWS Budget alert; instance, security group, Elastic IP, DNS names, Docker, Caddy with HTTPS, Jenkins and agent, Prometheus, Grafana, Node Exporter, TeX Live image; configuration saved in `deploy/`; stop and teardown procedure written; every AWS action authorized by BD | D8, D9, R8, R bonus cloud | BD | SD | Open (starts after Assignment 8 is submitted) | Nov 28 |
| T14 | **GitHub webhook to Jenkins**: the receiver on the new Jenkins, the webhook with a shared secret typed by a person, a tested push that starts the job; the manual button as fallback; documented for the report | D1, R3 | BD | SD | Open | Nov 30 |

## Dependencies
- T13 (new server) before T6, T8 and T14. T1 (repository) before T2 to T7. T3 before the package stage of T6 and T7.
- T6 and T7 use the same stage names and the same artifact name; T10 and T11 need the real runs of T6 to T8.
- T12 can start in parallel with placeholders (`[PENDING]`); nothing is written as passed before a run exists.
- Assignment 8 (Nov 24) first; Assignment 9 is on the assignments server and does not block this.

## Acceptance criteria (what counts as done, with evidence)
- **T1:** a clean clone builds and tests locally; `docs/` compiles to a PDF; the layout is explained in the README; protected `main`.
- **T2:** the issue exists on GitHub; the comment, change and commit message are written and rehearsed.
- **T3:** both pipelines print the same version for the same commit; a new commit changes the changelist.
- **T4:** the stage shows pass in one run and fail in another; the failure is reproducible on a branch.
- **T5:** the diagrams are generated from source in the pipeline and appear in the artifact and in the PDF.
- **T6:** one push starts Jenkins; every stage is visible with its time; the artifact is archived with the version in its name.
- **T7:** the workflow runs on push, with the same stage names and artifact name.
- **T8:** a recording or screenshots of a run on the server with the load graph moving during LaTeX and Docker work.
- **T9:** the walkthrough exists for each file and is checked against the files.
- **T10:** each quadrant contains facts we can point to; evidence lines hold numbers where we measured.
- **T11:** two rehearsals within 17 minutes, leaving time for Q/A.
- **T12:** the document builds with no undefined references; it holds the update history, the links and the required chapter title.
- **T13:** HTTPS works for both names; the budget alert exists; a stop or teardown procedure is written (not run before the end).
- **T14:** a push to GitHub starts the Jenkins job without a manual click, verified once; a failed webhook has a documented fallback.

## Why this split
SD takes the repository content, the code-facing stages and the GitHub Actions side (T1 to T5, T7); BD takes the server, Jenkins, the webhook, the load view and the configuration walkthrough (T6, T8, T9, T13, T14). The SWOT, the run sheet and the report are shared. It follows what each of us has built since October (BD: Jenkins, monitoring, the server; SD: the application, locked dependencies and Ansible).
The proposal (section 5.11) had BD on application, tests, GitHub Actions and the dashboard, SD on Terraform/AWS, Jenkins, security gates and the report build, and both on the drill, SWOT, report and presentation. It was a baseline and the revised split was agreed by both of us; the owner column can still be changed if circumstances change.
