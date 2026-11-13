# Sakshi (SD): rows 1, 2, 3, 8 = 50 points

## Scope
- **Row 1 (10)** working v1/v2 service, meaningful tests, source identity, locked build inputs.
- **Row 2 (10)** immutable image publication and traceability: one image per reviewed commit, registry digest recorded,
  the same digest promoted from staging to production; v1/v2 traceability table.
- **Row 3 (20)** Ansible deployment, staging/production separation, valid HTTPS, unchanged second run (`changed=0`).
- **Row 8 (10)** complete manual chapter: architecture diagram, release records, clickable links, runbooks (release,
  failed deployment, rollback, cleanup), document history; the final PDF build together with BD.

## Done (Nov 12, 2026, all offline, nothing deployed)
- Server baseline, read-only (evidence 170).
- `sd-work/pricing-service/`: v1 app and tests from the starter; `requirements.in` (starter ranges) locked to
  `requirements.txt` with exact versions and hashes for all 9 packages; Dockerfile pinned to
  `python:3.13.18-slim-trixie@sha256:e48f59cd...` and installing with `--require-hashes --no-deps`.
- Tests: passing baseline, a controlled failing test (exit 1), restored (evidence 171).
- Lock re-resolves identically; pip-audit 2.10.1: no known vulnerabilities at that time (evidence 172).
- Local amd64 build, hardened run (read-only root, tmpfs /tmp, cap_drop ALL, no-new-privileges, uid 10001):
  `/` v1, `/health` ok, `/price?quantity=3` 30, invalid quantities 400 (evidence 173).
- Ansible: ansible-core 2.22.0 (target Python >= 3.9; server has 3.9.25), community.docker pinned 5.4.0
  (Compose >= 2.18 needed; server has v5.6.0); inventory filled; syntax check OK; template renders; `mem_limit 128m`
  added (evidence 174).
- Caddy block for staging/app drafted and validated: `sd-work/Caddyfile.pricing-block.txt` (gate G4).

### Update (Nov 12, ~9:40 PM New York)
- Adapted to BD's pipeline draft: `pricing-service/VERSION` + guard test; `ansible/known_hosts` (pinned key); inventory via the
  Docker bridge `deploy-target` with HostKeyAlias (evidence 175: the server cannot reach its own Elastic IP on 22).
- twintrack issue #11 and PR #12 (branch `issue-11-pricing-service`, commit 55f4d15, reviewer BD); Jenkins PR-12 build #1:
  `twintrack/pipeline/pr-main` and `head` success.

## Next (in order)
1. Gitea issue + branch + PR in `twintrack` adding `pricing-service/` (v1), `ansible/`, `releases/` (BD reviews).
2. After BD's gates G1-G6: first pipeline build on the trusted agent -> registry push/pull, record the digest (row 2).
3. `releases/v1-staging.yml` and `v1-production.yml` with the real digest and commit; Ansible deploy to staging,
   second run `changed=0`, HTTPS checks (row 3). Production after BD's approval stage.
4. v2 in a new reviewed commit; same flow; traceability table v1/v2 (row 2).
5. Chapter: diagram (TikZ, adapted from course Figure 6.1), release records, runbooks, links (row 8).

## Checklist
- [x] baseline (170) · [x] tests pass/fail/restore (171) · [x] lock + base digest + pip-audit (172) · [x] local hardened run (173)
- [x] Ansible offline prep (174) · [x] Caddy draft · [x] twintrack issue #11 / PR #12 (Jenkins green; review by BD pending) · [ ] first registry image + digest
- [ ] staging deploy + `changed=0` · [ ] production (after approval) · [ ] v2 release · [ ] traceability table
- [x] diagram drafted (sd-work/TikZ, target state) · [ ] runbooks · [ ] chapter regions · [ ] final build check
