# Brahmi (BD): rows 4, 5, 6, 7 = 50 points

## Scope
- **Row 4 (15)** Jenkins gates, restricted recorded approval (`input` with named submitters and a timeout), verified v2
  promotion; `disableConcurrentBuilds`; delivery stages only on `main` on the trusted agent.
- **Row 5 (15)** security scan policy written before the release (block secrets and high/critical findings unless a
  documented, time-limited exception), tool and database versions, reports and exit codes (Trivy image + secret scan,
  pip-audit), one blocked pipeline with a scanner-supported synthetic fixture (never a live secret), fail on scanner
  errors; credential and access controls (Jenkins credentials, deploy account, registry tokens, no Docker socket to PR jobs).
- **Row 6 (15)** both recovery cases: (a) healthy production rollback v2 -> v1 with timeline and measured interruption;
  (b) staging-only failed deployment (Gunicorn bound to 8001 in a separate configuration commit), Jenkins stops,
  restore the previous configuration commit and release record, verify. Database/state-compatibility discussion.
- **Row 7 (5)** production `/health` added to the Blackbox probes and Grafana; release/rollback timestamps correlated
  with monitoring; single-server and state limitations.

## Gates first (see README): G1 agent, G2 capacity, G3 DNS, G4 apply SD's Caddy block, G5 deploy account and sudo,
G6 registry tokens, G7 pipeline shape and approvers.

## Inputs from SD you can use now
- `sd-work/pricing-service/` (locked, pinned, tested), `sd-work/ansible/` (pinned, syntax-checked), `sd-work/releases/release.example.yml`.
- pip-audit command that already works on the lock (evidence 172): `pip-audit -r requirements.txt --require-hashes --disable-pip`.

## Checklist
- [ ] G1 agent + tool versions · [x] G2 capacity (t3.medium, evidence 200) · [ ] G3 DNS · [ ] G4 Caddy · [ ] G5 deploy account · [ ] G6 tokens · [ ] G7 pipeline shape (approvers decided: brahmi and sakshi)
- [ ] scan policy · [ ] blocked fixture · [ ] approval stage · [ ] v2 promotion · [ ] rollback (a) · [ ] failed deploy (b)
- [ ] monitoring probe + correlation · [ ] limitations
