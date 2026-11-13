# Delivery pipeline draft (Assignment 8, rows 4 and 5) - BD

Status: DRAFT Nov 12, 2026; nothing has been run. `Jenkinsfile.delivery-draft` is the planned shape and `make-release-record.sh` its helper for the release records.

## Shape (README gate G7)
1. **Tests** on every branch, on the controller, with no credentials (pull requests stop here).
2. **Delivery** only when the branch is `main`, on the node labelled `delivery`: record tool versions; pip-audit and Trivy secret scan; build once; Trivy image scan; push; record the repository digest;
   Ansible to **staging** and smoke test (the playbook checks health, version, commit and price); **approval** (`input`, submitters `brahmi` and `sakshi`, 30 minutes, approver recorded);
   Ansible to **production** with the same digest and commit; archive `reports/` and `releases/`.
3. `disableConcurrentBuilds`; a 90-minute overall timeout; the last 20 builds kept.

## Open points to settle before the first run
- **Controller tests need Python venv and pip.** The controller image has python3 but may lack `python3-venv`; if so, either add it to the controller image (Assignment 6 Dockerfile, rebuilt by BD) or run the PR tests in a throw-away container on the controller (not wanted: no Docker there). Check first.
- **Layout with SD**: `pricing-service/VERSION`, `ansible/known_hosts` (public host key), `ansible/inventory.ini` group `delivery`, and where `make-release-record.sh` lives (it can move to `ansible/`).
- **Credentials to create (BD, typed by hand):** `gitea-registry-write` (username and token), `deploy-ssh-key` (SSH key and user `deploy`). The package-read token for root on the host is not a Jenkins credential.
- **The `input` step needs the approver to be signed in**; the matrix permissions already give brahmi Administer and sakshi Job Build/Read, which is enough to answer the prompt; confirm in the first run.
- **Limitation to document:** anyone who can change the `Jenkinsfile` in a pull request could remove `when { branch 'main' }`; the required review on `main` and the agent label are the controls.
