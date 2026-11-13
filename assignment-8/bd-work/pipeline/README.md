# Delivery pipeline draft (Assignment 8, rows 4 and 5) - BD

Status: DRAFT Nov 12, 2026; nothing has been run. `Jenkinsfile.delivery-draft` is the planned shape and `make-release-record.sh` its helper for the release records.

## Shape (README gate G7)
1. **Tests** on every branch, on the controller, with no credentials (pull requests stop here).
2. **Delivery** only when the branch is `main`, on the node labelled `delivery`: record tool versions; pip-audit and Trivy secret scan; build once; Trivy image scan; push; record the repository digest;
   Ansible to **staging** and smoke test (the playbook checks health, version, commit and price); **approval** (`input`, submitters `brahmi` and `sakshi`, 30 minutes, approver recorded);
   Ansible to **production** with the same digest and commit; archive `reports/` and `releases/`.
3. `disableConcurrentBuilds`; a 90-minute overall timeout; the last 20 builds kept.

## Open points to settle before the first run
- **Controller tests need Python venv and pip. Checked Nov 12, 2026: the controller has Python 3.13.5 and git 2.47.3, but no pip and `python3 -m venv` fails (ensurepip is missing).** Fix: add `python3-venv python3-pip` to the controller image
  (`assignment-6/jenkins/Dockerfile`, apt-get, about 30 MB), rebuild and recreate the Jenkins container (volume kept; a short restart, as tested in Assignment 6). Until then the PR test stage cannot install Flask.
- **Layout with SD (agreed Nov 12):** `pricing-service/VERSION`, `ansible/known_hosts` with the pinned host key, inventory group `delivery`; the SSH target is `deploy-target` (agent compose has `extra_hosts: deploy-target:host-gateway`, evidence 175);
  `make-release-record.sh` goes to `ansible/` in the pipeline pull request (the Jenkinsfile sources it from there).
- **Changes after SD's review of the draft:** the `input` is wrapped in `timeout(30 minutes)`; the Assignment 6 checks (`py_compile pricing.py`, `unittest discover -s tests`) stay in the first stage; the approval stage has `agent none`, so it does not hold the agent's executor
  (the release facts travel in environment variables).
- **Credentials to create (BD, typed by hand):** `gitea-registry-write` (username and token), `deploy-ssh-key` (SSH key and user `deploy`). The package-read token for root on the host is not a Jenkins credential.
- **The `input` step needs the approver to be signed in**; the matrix permissions already give brahmi Administer and sakshi Job Build/Read, which is enough to answer the prompt; confirm in the first run.
- **Limitation to document:** anyone who can change the `Jenkinsfile` in a pull request could remove `when { branch 'main' }`; the required review on `main` and the agent label are the controls.
