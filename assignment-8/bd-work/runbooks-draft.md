# Row 6 draft: recovery runbooks (BD). NOT YET RUN. Written Nov 16, 2026.

Both recoveries use the same mechanism as a normal release: Ansible applies a release record (exact image digest, version, commit, expected total) and verifies it through the public HTTPS name. No rebuild, no `latest` tag.

## Open design point (to agree with SD)
The pipeline writes `releases/<version>-<env>.yml` into the build workspace and archives it with the build. Rolling back needs the earlier record (v1 production) and the main branch is protected, so the pipeline cannot commit records. Proposal: a separate Jenkins pipeline job `rollback-production` (Jenkinsfile.rollback in the repository, reviewed like any change) that takes the release record of a chosen earlier build, shows its digest and version, asks for the same restricted approval, and runs the same playbook. If SD prefers committed records, the v1 and v2 records are committed to `releases/` in a reviewed pull request after each release and the rollback job reads them from the repository.

## A. Production rollback v2 to v1 (trigger: v2 is live and wrong)
1. Detect: the cause is recorded (for the exercise: v2 intentionally judged unacceptable after promotion; the evidence is the Ansible smoke test or an operator observation, plus the monitoring view).
2. Decide: name the release to restore (v1, its digest and commit from the archived v1 production record of the build that deployed it).
3. Approve: the restricted approval (brahmi or sakshi) with timeout.
4. Apply: the same Ansible playbook with the v1 production record. The playbook converges Compose to the v1 digest and verifies HTTPS health, version v1, price total 30.
5. Verify: public checks from the PC (`/`, `/health`, `/price?quantity=3`: version v1, total 30), container image digest equals the record, Prometheus `probe_success` back to 1, the Discord alert (if it fired) resolved.
6. Record: start/finish time, time to recovery, digest before and after, who approved; leave v2 in the registry (immutable by digest) and in staging so the cause can be examined.
7. Matching configuration: the Compose file and the release record on the server show the v1 digest; nothing else changed (compare `docker inspect` and the rendered `compose.yaml` before and after).

## B. Staging failed-deploy recovery (trigger: a deployment fails)
1. Break on purpose, in a reviewed way: a release record for staging whose image digest does not exist (or whose expected version is wrong). The pipeline run fails in "Deploy staging" (pipefail makes the failure visible); production is not touched because the approval stage is never reached.
2. Observe: the Ansible failure line, the state of the staging container (still the previous good release, or none if the first deploy), production unchanged.
3. Recover: run the same deployment with the last good staging record; verify as in A.5 on https://staging.ssw590-g1.tech.
4. Record: failure time, cause, recovery time, evidence that production stayed on its release throughout.

## Evidence to capture
Console output with timestamps of every step, the release records used (metadata only), `docker inspect` digests before and after, public check outputs, Prometheus/Grafana screenshots of the probe, and the Discord alert if it fired. Numbers from BD's range 214+.
