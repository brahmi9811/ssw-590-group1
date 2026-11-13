# Jenkins controller for the Group 1 startup (Assignment 6).
# Official Jenkins LTS image, pinned to an exact version, plus python3 because the course's example
# Jenkinsfile runs `python3 -m unittest` on the controller executor (decision G6: builds on the controller).
# Plugins are installed at build time so the versions are recorded in the image, not downloaded at run time.
FROM jenkins/jenkins:2.580.2-lts-jdk21

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 \
 && rm -rf /var/lib/apt/lists/*
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Assignment 8: pip and venv so the pull-request test stage can install the pinned application requirements (added Nov 12, 2026)
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*
USER jenkins
