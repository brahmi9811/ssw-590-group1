# Assignment 8 evidence (SD 170-199, BD 200-229)

| # | File | What it shows | Row | Time (New York) |
|---|---|---|---|---|
| 170 | 170-server-baseline-before-delivery-sd-2026-11-12.txt | Read-only server baseline: t3.small, 768 MiB available, 225 MiB swap, 6.4 GB disk free, Python 3.9.25, Docker 25.0.14, Compose v5.6.0, 8 containers, `gitea_web` network, Gitea registry API `/v2/` answers 401 (enabled), Jenkins has no agent and no docker/ansible/trivy/pip-audit, only 22/80/443 public. | 1, 3 (G1, G2) | 2026-11-12 19:56 |
| 171 | 171-v1-unit-tests-pass-controlled-failure-restore-sd-2026-11-12.txt | v1 tests: 3 pass (exit 0); controlled failure (expected 31) exit 1; restored, file identical to the starter. | 1 | 2026-11-12 19:58 |
| 172 | 172-locked-dependencies-base-image-digest-pip-audit-sd-2026-11-12.txt | Base image python:3.13.18-slim-trixie index and amd64 digests; pip-compile 7.6.2 lock (9 packages, 167 hashes) re-resolves identically; pip-audit 2.10.1: no known vulnerabilities at that time (no vulnerability-free claim). | 1 | 2026-11-12 19:59 |
| 173 | 173-v1-image-local-build-hardened-run-endpoint-checks-sd-2026-11-12.txt | Local amd64 build (not a release), hardened run (read-only, cap_drop ALL, no-new-privileges, uid 10001), healthy; `/` v1, `/health` ok, price 30, invalid quantities 400. | 1 | 2026-11-12 20:00 |
| 174 | 174-ansible-versions-syntax-check-rendered-compose-sd-2026-11-12.txt | ansible-core 2.22.0, community.docker 5.4.0 (pinned); target prerequisites checked; inventory; syntax check exit 0; template rendered with a dummy release and accepted by Compose; mem_limit 128m. | 3 | 2026-11-12 20:03 |
