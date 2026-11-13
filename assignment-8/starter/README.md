# Chapter 6: Startup Pricing Service

`v1/` and `v2/` are two releases of the same stateless Flask service. Version 1
charges USD 10 per unit; version 2 charges USD 12. Three units cost 30 and 36.
Both use Gunicorn, run as a non-root container user, and expose port 8000.
No database, real customer data, payment processing, or credentials are involved.

## Local checks

Run from either version directory, using a disposable virtual environment:

```sh
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python -m unittest -v
```

Requirements are compatibility ranges, not a reproducible lock. Before the
assessed release, resolve, review, scan, and commit exact dependency versions
(including transitive dependencies) and an approved base-image digest. Save
scanner versions and reports. These starter files make no vulnerability claim.

## Build and publish

Copy v1 into the team application's working directory and commit it. Build from
that directory on the trusted Jenkins agent. Use the Gitea registry hostname
without a URL scheme; replace the owner/team with its actual lowercase name.

```sh
COMMIT=$(git rev-parse HEAD)
IMAGE=gitea.example.edu/team/pricing
# Authenticate separately using a Jenkins credential and --password-stdin.
docker build --build-arg APP_COMMIT="$COMMIT" -t "$IMAGE:$COMMIT" .
docker push "$IMAGE:$COMMIT"
docker pull "$IMAGE:$COMMIT"
docker image inspect "$IMAGE:$COMMIT" --format '{{index .RepoDigests 0}}'
```

Save that repository digest in a release record. Build once; use the same digest
in staging and production. For v2, replace app.py and test_app.py with the v2
files, commit, and repeat the pipeline. Do not build the entire parent directory.
Use a Linux image architecture compatible with the droplet.

## One-time deployment preparation

Install Ansible in a virtual environment on a trusted Linux Jenkins agent; use a
Python version supported by your selected ansible-core release. Record exact
resolved versions after installation.

```sh
python3 -m venv .ansible-venv
. .ansible-venv/bin/activate
pip install ansible-core
ansible-galaxy collection install -r ansible/requirements.yml
ansible --version
ansible-galaxy collection list
```

On the target droplet, install Python 3, Docker Engine and the Compose v2 plugin
(at least 2.18); verify `docker compose version`. Configure a dedicated SSH
account and the approved escalation policy. The playbook uses become and needs
noninteractive sudo; this is powerful host access. Do not grant it to untrusted
pull-request jobs. Verify/pin the SSH host key in the Jenkins agent's known_hosts.
Keep private keys, sudo credentials and package tokens in Jenkins credentials.

Identify the existing reverse proxy's Docker network with `docker network ls`
and its current Compose configuration. Both app projects join that external
network. Configure the proxy once, preserving all existing routes:

```caddyfile
staging.example.edu {
    reverse_proxy pricing-staging:8000
}
app.example.edu {
    reverse_proxy pricing-production:8000
}
```

Use your real DNS names pointing to the droplet and valid TLS certificates.
The proxy must be attached to that network. For a host-based proxy, adapt the
Compose template to distinct loopback ports and proxy to those ports instead.
The supplied template is for a container-based proxy; do not publish raw 8000.

Authenticate Docker on the target as the account used by become (normally root)
using a read-only package credential and `docker login --password-stdin` through
a protected administrator session. The Jenkins build agent separately needs a
package-write credential. Never commit either credential or Docker config.json.
Do not enable insecure registry access or disable certificate verification.

## Deploy and roll back

Fill inventory.ini and copy release.example.yml to releases/v1-staging.yml.
Replace every placeholder. Keep this release metadata in Git; it has no secrets.
Use the exact source commit, registry digest, proxy network, URL and expected
values. From this starter directory:

```sh
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml --syntax-check
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml -e @releases/v1-staging.yml
```

Run again unchanged and show changed=0. If the module reports unexpected
changes, inspect Compose/plugin versions and the task diff before claiming
idempotence. Create a production record with the same image digest and the
production target and URL; deploy only after an authorized Jenkins approval.
Disable concurrent delivery builds to prevent competing releases.

Preserve each release's Compose template/configuration commit as well as its
image digest. For rollback, check out the previous reviewed deployment files
and run its production release record again. The current playbook does not
perform an automatic rollback: a failed check fails the run and requires the
explicit rollback stage/runbook. Never use `down -v`, prune shared volumes, or
roll back Gitea/Jenkins as part of the application exercise.

For a controlled failure, use staging only: temporarily set the service's
Compose `command` to `["gunicorn", "--bind", "0.0.0.0:8001", "app:app"]` in a
separate configuration commit. The image healthcheck still probes 8000, so
Compose wait should fail. Save the failure, restore the previous configuration
commit, and redeploy its release record. Do not stop the host Docker service.

For the business rollback, deploy healthy v2, verify version v2 and total 36,
then redeploy v1 and verify version v1 and total 30. Measure interruption and
recovery time. This recreate strategy does not provide zero downtime.

Implement the Jenkins stages, security policy, approval and evidence described
in Chapter 6; the examples are application/deployment starters, not a complete
Jenkins pipeline. Container builds and remote deployment were not executed by
the author in a student environment.
