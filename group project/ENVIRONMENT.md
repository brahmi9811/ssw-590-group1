# The project environment (new, separate from the assignments)

Draft of Nov 18, 2026. Nothing here exists yet. The AI assistant prepares commands and files; BD creates or explicitly authorizes every AWS resource and DNS record.

## Why a separate server and a separate repository
The assignments server runs Gitea, Jenkins, Caddy, monitoring and the Assignment 8 application, and Assignment 9 (Zammad) needs a larger instance. A project server of its own keeps the demo independent of those assignments, makes the load graph clean (only our pipeline runs on it), and can be stopped on a single date without touching graded work. The assignments repository is full of assignment material; the project gets a small public repository where every file is part of the demonstration.

## The new server
| Item | Proposal |
|---|---|
| Cloud and region | AWS, us-east-1 (same account and key-pair practice as before; the assignments server is not changed) |
| Instance | t3.medium (2 vCPU, 4 GB) with Amazon Linux 2023: Jenkins (controller about 640 MiB), an agent, Prometheus, Grafana, Node Exporter, Caddy and Docker builds fit; t3.small (2 GB) is too small |
| Disk | gp3 30 GB (the TeX Live image and Docker layers are the big items; use a smaller TeX Live image than the 5.8 GB one of Assignment 5) |
| Network | its own security group: 80 and 443 from anywhere, SSH only from team addresses, no other public port; an Elastic IP |
| DNS | two names under `ssw590-g1.tech`, for example `pipeline.ssw590-g1.tech` (Jenkins) and `load.ssw590-g1.tech` (Grafana); DNS records are made by BD at Name.com |
| HTTPS | Caddy container with Let's Encrypt certificates, the same method as Assignment 2 |
| Software | Docker Engine and Compose; Jenkins with the GitHub integration (webhook receiver) and one agent; Prometheus, Grafana, Node Exporter; the TeX Live image; Python and Graphviz for pyreverse in the build image |
| Configuration | in the new repository, folder `deploy/` (Compose, Caddyfile, `prometheus.yml`, dashboard JSON); secrets (webhook secret, Jenkins admin password, GitHub token if any) are typed by a person and stored outside Git |
| Approximate cost (verify in the AWS console) | t3.medium about $0.042 per hour (about $30 per month), gp3 30 GB about $2.4 per month; for the five weeks from Nov 25 to Dec 17 about $40 in total; set an AWS Budget alert first |
| End of life | after grading: stop the instance, then terminate it and release the Elastic IP; BD does this; costs recorded in the report |

## The GitHub repository
| Item | Proposal |
|---|---|
| Name | `ssw590-g1-devops-pipeline` (to confirm) under BD's account, with SD as collaborator; public so Actions minutes are unlimited and the instructor can open it without an invitation |
| Contents | no secrets, only synthetic code and configuration; the demo issue, commits and workflow runs are the demonstration |
| Layout | `src/` (a small Python service with a few classes), `tests/`, `docs/` (a small LaTeX architecture document), `report/` (the final report), `.github/workflows/pipeline.yml`, `Jenkinsfile`, `Dockerfile`, `VERSION`, `scripts/` (`version.sh`, `package.sh`), `deploy/` |
| Branch rule | `main` protected, changes by pull request with the other person's review, as in our assignments |
| Secrets in GitHub | only what the workflow needs (none for the ZIP build; a registry token only if an image is pushed); never in the repository |

## How the demo push reaches both tools
1. On GitHub: the issue, the comment, the commit and the push.
2. GitHub Actions starts on the push (GitHub-hosted runner).
3. GitHub sends a webhook to `https://pipeline.ssw590-g1.tech/github-webhook/` and Jenkins starts. The webhook needs a shared secret set by a person; if the webhook is not available at demo time, a manual "Build Now" is the fallback.
4. Both pipelines run the same ordered stages and produce the same artifact name; Jenkins also runs on the AWS server, where Grafana shows the load.

## Risks and how we handle them
- A webhook can fail on demo day: manual button and a recorded run as fallback.
- Prometheus samples every 30 seconds: a build shorter than about two minutes shows a small change; rehearse and, if needed, show a terminal (`docker stats`, `htop`) beside Grafana, or lengthen the build with real work (LaTeX plus Docker build).
- Cost and time: the server is created only after Assignment 8 is submitted, and every AWS action is authorized by BD.
- Public repository: only synthetic data; no tokens in workflow files or history; a fake secret for the fixture must be obviously fake and in a branch only.
