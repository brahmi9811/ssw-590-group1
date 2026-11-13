# Trusted Jenkins agent (Assignment 8, gate G1) - BD

Status: DRAFT written Nov 12, 2026. Nothing here has been started on the server yet; the image was only test-built on BD's computer (see "Test build").

## Why an agent, and why this design
Chapter 6 says deployment must run on a **trusted agent**, not on the controller, and the agent needs Docker build capability, Python, Ansible and a scanner
(course manual V1.43, sec. 6.4.2). Today Jenkins (Assignment 6) has only the controller executor and none of these tools (evidence 170).
- **One container on the existing `gitea_web` network**, built from `Dockerfile` here, so recreating it loses nothing (the tools are in the image; the Trivy database is cached in a volume).
- **Connection: Jenkins WebSocket mode.** The agent connects *out* to `http://jenkins:8080`; no agent port (50000) is opened. Assignment 6 deliberately disabled that port, and it stays disabled.
- **Label `delivery`, one executor, "only build jobs with a matching label"**: ordinary pull-request jobs stay on the controller and never run on this agent.
- **Image pinned**: base image by the linux/amd64 digest, Docker CLI and Trivy by SHA-256, Ansible and pip-audit by exact version (ansible-core 2.22.0 needs Python 3.13, which Debian trixie provides).

## The risk, stated plainly
The agent mounts the host's Docker socket so that it can build and push images. **Docker socket access is root-equivalent on the server**: anything that runs on this agent can start a privileged container and read
or change the whole host. Therefore: (1) only reviewed code from `main` may run on it (the delivery stages are in a `when { branch 'main' }` block and the node accepts only jobs labelled `delivery`); (2) pull-request builds get
neither the label nor the credentials; (3) the repository's `main` is protected (one approval, required check); (4) the deploy key and registry token live only in Jenkins credentials. A person with write access to the repository can still change the
`Jenkinsfile` in a pull request; the required review is the control, and this is listed as a limitation in the manual. A rootless or remote Docker host would remove this exposure and is the first improvement.

## Steps (BD, on the server; the AI assistant only drafts the files)
1. `mkdir ~/jenkins-agent`, copy `Dockerfile`, `compose.yaml`, `.env.example` there.
2. In Jenkins: *Manage Jenkins, Nodes, New node*: name `delivery-agent`, *Permanent Agent*; executors 1; remote root directory `/home/jenkins/agent`; labels `delivery`; usage *Only build jobs with label expressions matching this node*;
   launch method *Launch agent by connecting it to the controller*, tick **Use WebSocket**. Save; the node page shows the **secret**.
3. On the server: `cp .env.example .env; chmod 600 .env`, put the secret (typed or pasted by BD only, never in chat or Git) and `DOCKER_GID` (`getent group docker | cut -d: -f3`) into `.env`.
4. `docker compose config --quiet && docker compose build && docker compose up -d`; the node turns online in Jenkins (screenshot).
5. Record the versions (below) and the image digest; test with a job labelled `delivery` that prints the versions.

## Versions to record (output saved as evidence)
`docker --version; trivy --version; ansible --version; ansible-galaxy collection list; pip-audit --version; python3 --version; java -version; id; docker compose version (host)`.
The Trivy vulnerability and secret databases are downloaded at the first scan; their versions and download times are recorded with the scan.

## Files
- `Dockerfile` - the agent image; `compose.yaml` - service with a 1.5 GiB memory limit, no published port; `.env.example` - the two values that stay out of Git.

## Test build
Built on BD's computer (Docker Desktop, Nov 12, 2026, exit 0) to prove that the pinned hashes and versions install; this is not a server deployment. The image printed:
`Docker version 25.0.5`, `Trivy 0.76.2`, `ansible [core 2.22.0]`, `pip-audit 2.10.1`, `Python 3.13.5`, `openjdk 21.0.13`, and runs as `uid=1000(jenkins)`.
Image size about 0.95 GB: with the Trivy database and app images it must fit in the 6.4 GB of free disk (evidence 200), which is why disk is watched during this assignment.
