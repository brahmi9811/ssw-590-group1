# Sakshi (SD): T1, T2, T3, T4, T5, T7, and shares of T10, T11, T12 (agreed split)

## Scope
- **T1 Repository layout (owner).** In the new GitHub repository (created by BD): `src/` (a small Python service with a few classes so the diagrams are meaningful), `tests/`, `docs/` (a small LaTeX architecture document that compiles in about a minute), `report/`, `scripts/`, `VERSION` (`major.minor`), a README, a PR template; review of every change by the other person.
- **T2 Issue and commit script (owner).** The demo issue on GitHub, the comment to post, the change to make (one LaTeX line and one code line), the commit message, rehearsed.
- **T3 Versioning (owner).** `major.minor.changelist` from `VERSION` plus the changelist rule (decision D4, default the Git commit count); the names of the ZIP and the image tag; printed in the logs of both pipelines.
- **T4 Tests (owner).** `unittest` output with a clear pass or fail; one deliberately failing branch for the Q/A.
- **T5 Reverse documentation (owner, bonus).** `pyreverse` and Graphviz in both pipelines; the diagrams copied into the ZIP and into the LaTeX output.
- **T7 GitHub Actions workflow (owner).** `pipeline.yml` with the same stages, names and artifact as the Jenkins pipeline, on a GitHub-hosted runner, the second tool of our proposal and of the SWOT; ported from our Gitea Actions manual workflow where possible.
- **T10 SWOT (draft for GitHub Actions), T11, T12 (both).** SWOT facts for GitHub Actions (setup, runner model, security model such as secrets and third-party actions, speed, cost, limits); the run sheet and rehearsals; the report sections on issue tracking, source control, forward documentation, testing, deployment, reverse documentation and the GitHub Actions workflow.

## Needs from BD
The new server and Jenkins (T6, T13), the webhook (T14), the load view (T8), the configuration walkthrough (T9), AWS and DNS changes, the repository creation (T1).

## Checklist
- [x] roles and split confirmed · [ ] D1 to D10 read · [ ] `CANVAS.md` read
- [ ] repository layout and `VERSION` · [ ] `docs/` compiles · [ ] issue, comment, change and commit message
- [ ] versioning visible in both logs and the artifact name · [ ] tests pass and fail cases · [ ] pyreverse diagrams in the artifact
- [ ] `pipeline.yml` with the same stage names · [ ] SWOT of GitHub Actions with evidence · [ ] run sheet · [ ] two rehearsals
- [ ] report sections · [ ] joint PDF build
