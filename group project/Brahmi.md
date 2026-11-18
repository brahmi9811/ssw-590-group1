# Brahmi (BD): T6, T8, T9, T13, T14, and shares of T10, T11, T12 (agreed split)

## Scope
- **T13 New project server (owner).** AWS Budget alert first; instance, security group, Elastic IP, DNS names, Docker, Caddy with HTTPS, Jenkins and agent, Prometheus, Grafana, Node Exporter, TeX Live image; configuration saved in `deploy/`; the stop and teardown procedure. Created after Assignment 8 is submitted. BD does or explicitly authorizes every AWS and DNS change; the AI assistant prepares commands and files and reads, nothing paid without a yes for that step. See `ENVIRONMENT.md`.
- **T1 (repository creation).** Create the public GitHub repository `ssw590-g1-devops-pipeline` under BD's account, add SD as collaborator, protect `main`.
- **T14 GitHub webhook to Jenkins (owner).** The receiver on the new Jenkins, the webhook with a shared secret typed by a person, a tested push that starts the job; the manual button as fallback.
- **T6 Jenkins pipeline for the demo (owner).** Stages Checkout, Compile LaTeX (TeX Live container), Build, Reverse documentation (SD's script), Test, Package, Version and archive; same stage names as the GitHub Actions workflow; about five minutes or less; artifact archived with the version in its name.
- **T8 Cloud load view (owner).** Grafana panels for CPU, memory, disk and network with a short refresh, a terminal with `docker stats` or `htop` beside them, a rehearsed run in which the load visibly changes; the limits (30-second scrape) noted.
- **T9 Configuration walkthrough (owner).** One short page per configuration file with what it does for the pipeline and the settings that matter; links into the repository.
- **T10 SWOT (draft for Jenkins).** From logged facts of Assignments 4 to 8 and of the new server: setup effort, maintenance (the controller and agent changes, the Groovy escape incident), security model (credentials bound only on the trusted agent, the Docker socket), speed, cost, what failed.
- **T11 and T12 (both).** The run sheet, the rehearsals, and the report sections on CI/CD (Jenkins), monitoring, cloud, configuration and the update history.

## Rules
The AI assistant prepares drafts, reads servers (read-only) and records evidence; commits need BD's explicit authorization per assignment or project. BD does or authorizes AWS changes, DNS, server `sudo` changes and any secret. No secrets in chat, Git or the report.

## Needs from SD
The repository layout and the code (T1), the tests (T4), the version scheme (T3), the reverse-documentation step (T5), the GitHub Actions workflow (T7).

## Checklist
- [ ] D3, D4, D5, D6, D9 decided (defaults apply) · [ ] instructor questions asked (report format, Dec 7 versus Dec 14)
- [ ] AWS Budget alert · [ ] new server created and secured (after Nov 24) · [ ] DNS and HTTPS for both names
- [ ] GitHub repository and protection · [ ] Jenkins on the new server · [ ] webhook with secret, tested
- [ ] Jenkins demo job with the stages above · [ ] artifact archived with the version in its name
- [ ] Grafana panels and refresh · [ ] rehearsed run with a visible load change · [ ] screenshot or recording
- [ ] configuration pages for each file · [ ] SWOT of Jenkins drafted with evidence · [ ] run sheet · [ ] two rehearsals
- [ ] report sections · [ ] joint PDF build · [ ] stop or teardown after grading, costs recorded
