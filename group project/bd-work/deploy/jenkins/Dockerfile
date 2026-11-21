# Jenkins controller for the final project. Same LTS line as Assignment 6 to 8 (known to work),
# plugins installed at build time so their versions are recorded in the image.
FROM jenkins/jenkins:2.580.2-lts-jdk21

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
