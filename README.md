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

## Repository layout

```
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
