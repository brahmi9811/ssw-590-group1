# ssw-590-group1

SSW 590 DevOps — Group 1

## Contributors
- Brahmi Dalvi
- Sakshi Deshpande

## Assignment: Cloud Docker Deployment + Project Proposal

The group deploys to **AWS EC2** instead of a Digital Ocean Droplet.

| # | Item | Where |
|---|------|-------|
| 1–2 | Docker website deployed to the cloud, steps in minted LaTeX | `deploy/aws/`, report chapter *AWS Docker Deployment* |
| 3 | Two buttons rewritten as class-based JavaScript + UML class diagram | `website/color-buttons-app/public/js/colorButtons.js`, [`docs/uml-class-diagram.md`](docs/uml-class-diagram.md), chapter *Class-Based Two-Button Website* |
| 4 | Docker container that compiles LaTeX with TeX Live | `latex-docker/`, chapter *LaTeX Docker* |
| 5–6 | Project proposal (TwinTrack: GitHub Actions vs. Jenkins on AWS) | chapter *Project Proposal* |
| 7 | Document history | report front matter |

The compiled report is [`report/devopsAssignment.pdf`](report/devopsAssignment.pdf).

## Course assignments at a glance

The course builds one startup: a Gitea work hub, an automated manual build, then Jenkins CI. The course manual is in each
assignment folder (`dosManual-V1.18.pdf` for assignments 4–5, `dosManual-V1.38.pdf` for assignment 6). Each assignment adds a chapter
to the group's LaTeX IT manual, and only the compiled PDF is submitted.

| # | Assignment (course manual chapter) | Due | Status | Start here |
|---|---|---|---|---|
| 1–3 | Cloud Docker deployment, class-based website, LaTeX Docker, project proposal | earlier | submitted; its EC2 instance is stopped | the sections below, `report/devopsAssignment.pdf` |
| 4 | Domain Names, SSL, and Versioning: Gitea on AWS EC2 behind Caddy (Chapter 2) | Oct 15 | **submitted** | [`assignment-4/README.md`](assignment-4/README.md); submitted PDF [`assignment-4/manual/devopsITManual-grp1-hw4.pdf`](assignment-4/manual/devopsITManual-grp1-hw4.pdf) |
| 5 | LaTeX Auto-Compilation with Gitea: self-managed Actions runner builds the manual (Chapter 3) | Oct 21 | **submitted** (PDF from Gitea Actions run #10) | [`assignment-5/README.md`](assignment-5/README.md); submitted PDF [`assignment-5/IT-manual+build.10.f8a6179-grp1.pdf`](assignment-5/IT-manual+build.10.f8a6179-grp1.pdf) |
| 6 | Gitea + Jenkins Autobuild and Testing: PR triggers Jenkins, required status check (Chapter 4) | **Nov 4, 11:59 PM** | **in progress**: plan and task split done | [`assignment-6/README.md`](assignment-6/README.md); personal task lists in `assignment-6/Brahmi.md` and `assignment-6/Sakshi.md` |

Where things live:
- **Live service:** Gitea at <https://git.ssw590-g1.tech> (organization `group1-startup`; product repo `twintrack`, manual repo `manual`, deployment files in `infra`). It runs on one AWS EC2 instance with Caddy and a Gitea Actions runner and must stay up until grading is finished.
- **The IT manual's source of truth is the Gitea repo `group1-startup/manual`**; `assignment-5/manual-repo/` in this repository is a mirror. Assignment 4's manual source is under `assignment-4/manual/`.
- **Deployment files for Gitea and the runner** (non-secret): `assignment-4/gitea/`, `assignment-5/runner/`.
- **Evidence** (screenshots and real command output) is numbered per assignment in `assignment-N/evidence/` with an index in each folder.
- **Working agreement:** work on `main`; `git pull --rebase` before every push; edit only your own rows; never commit secrets; never claim an unrun test passed.

## Repository layout

```
assignment-4/                Gitea foundation: plan, manual source, gitea/ deployment files, evidence
assignment-5/                Gitea Actions manual build: plan, runner/ files, manual-repo/ mirror, evidence
assignment-6/                Jenkins CI: plan, task lists, evidence (in progress)
website/color-buttons-app/   Express site, class-based JS, Dockerfile, unit tests
deploy/aws/                  launch-ec2.sh, ec2-user-data.sh, redeploy.sh, teardown-ec2.sh
latex-docker/                TeX Live Dockerfile, hello.tex, build.sh
evidence/                    real command output captured while building/testing
docs/                        UML (Mermaid)
report/                      LaTeX group document
```

## Run the website locally

```bash
cd website/color-buttons-app
npm install && npm test
docker build -t color-buttons-app:2.0 .
docker run -d --name color-buttons-app -p 8080:3000 color-buttons-app:2.0
# open http://localhost:8080
```

## Deploy to AWS

Requires the AWS CLI v2 configured for an IAM user (`aws configure`).

```bash
./deploy/aws/launch-ec2.sh      # prints http://<EC2-PUBLIC-DNS>
./deploy/aws/teardown-ec2.sh    # terminate when done
```

After deploying, put the public URL in `\WebsiteURL` in `report/devopsAssignment.tex`,
save `curl` output to `evidence/aws-checks.txt` and a screenshot to `evidence/aws-website.png`.

## Build the report (no local LaTeX needed)

```bash
docker build -t latex-builder latex-docker
docker run --rm -v "$PWD":/workdir -w /workdir/report latex-builder devopsAssignment.tex
```
