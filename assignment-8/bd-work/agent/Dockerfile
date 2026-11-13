# Trusted Jenkins agent for the delivery stages of Assignment 8 (gate G1).
# Built on the server from this file; nothing here is a secret. Tool versions and hashes are pinned.
#
# - Base: the official inbound agent (Debian 13 "trixie", Java 21), pinned by the linux/amd64 manifest digest
#   (index tag 3395.v6e5377b_0fb_3c-5-jdk21 = trixie-jdk21, read from Docker Hub on Nov 12, 2026).
# - Docker CLI only (no daemon): the agent talks to the HOST's Docker through the mounted socket. That is
#   root-equivalent on the host; it is documented in README.md and the agent runs only reviewed main-branch code.
# - Trivy: release tarball checked against the SHA-256 of the release's own checksums file.
# - Ansible and pip-audit: pinned versions in a virtual environment (ansible-core 2.22.0 needs Python 3.13, which trixie has).
FROM jenkins/inbound-agent:3395.v6e5377b_0fb_3c-5-jdk21@sha256:2e84c389527b7d925510e610a7d76da59f16cc4a92c1bede2e0a033c60f1deb5

USER root

ARG DOCKER_CLI_VERSION=25.0.5
ARG DOCKER_CLI_SHA256=d5ff82e5fd469aab5ce73f01c27fa4ca8df85e5376d8245d012c73694dc2fc95
ARG TRIVY_VERSION=0.76.2
ARG TRIVY_SHA256=bc0fc726e017b8927a62b2d3531d7a84ee01769daf5c99ed866dced54089fdbf
ARG ANSIBLE_CORE_VERSION=2.22.0
ARG PIP_AUDIT_VERSION=2.10.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 python3-venv python3-pip git openssh-client curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz" \
 && echo "${DOCKER_CLI_SHA256}  /tmp/docker.tgz" | sha256sum -c - \
 && tar -xzf /tmp/docker.tgz -C /usr/local/bin --strip-components=1 docker/docker \
 && rm /tmp/docker.tgz

RUN curl -fsSL -o /tmp/trivy.tgz "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" \
 && echo "${TRIVY_SHA256}  /tmp/trivy.tgz" | sha256sum -c - \
 && tar -xzf /tmp/trivy.tgz -C /usr/local/bin trivy \
 && rm /tmp/trivy.tgz

RUN python3 -m venv /opt/tools \
 && /opt/tools/bin/pip install --no-cache-dir "ansible-core==${ANSIBLE_CORE_VERSION}" "pip-audit==${PIP_AUDIT_VERSION}"
ENV PATH="/opt/tools/bin:${PATH}"

# Recorded when the image is built (README.md, "Versions to record"): docker, trivy, ansible, pip-audit, python.
USER jenkins
