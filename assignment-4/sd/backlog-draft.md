# Row 6 backlog draft (SD) — prepare now, create in Gitea after G3

Organization: `group1-startup` (owner: BD). Product repository: `twintrack`
(the semester project from our proposal). Members: BD = organization owner
(infrastructure); SD = member of team `developers` with write access (product).
Branch protection on `main`: pull request + 1 approval required.

## Product README (first commit of `twintrack`)

```markdown
# TwinTrack

A small team task tracker that Group 1 (SSW 590) uses as its startup product.
The same application is delivered by two CI/CD pipelines (GitHub Actions and
Jenkins) so the tools can be compared on security, speed, and operations.

## Status
Planning. See the issues for the current backlog.

## How we work
1. Every change starts as an issue.
2. Branch from `main` as `issue-<number>-<short-name>`.
3. Open a pull request with `Closes #<number>` in the description.
4. The other team member reviews and approves; then merge.

## Team
- Brahmi Dalvi — infrastructure (Gitea, cloud, CI)
- Sakshi Deshpande — product (application, tests, documentation)
```

## Issues (≥5, product + operations)

| # | Title | Type | Assignee | Acceptance criteria |
|---|---|---|---|---|
| 1 | Write the product README | product | SD | README states purpose, status, workflow, team (trace 1) |
| 2 | Add CONTRIBUTING.md for the issue → branch → PR → review flow | operations | BD | file merged via PR reviewed by SD (trace 2) |
| 3 | Define the TwinTrack task data model | product | SD | `docs/data-model.md` lists fields, states, and transitions |
| 4 | Protect `main`: require PR + 1 approval | operations | BD | direct push to `main` is rejected; screenshot of setting |
| 5 | Document the Gitea restart/troubleshooting runbook | operations | SD | runbook in `docs/runbook.md` matches manual section 3.2.7 |
| 6 | Add the domain expiry date (Oct 15, 2027) to the shared team calendar and name its owner | operations | BD | calendar event exists with owner and reminder (we do not plan to renew) |

## Two issue-linked PRs

- **Trace 1:** SD branches `issue-1-readme`, commits the README, opens PR "Add product README" with `Closes #1`; BD reviews and approves; merge; issue #1 auto-closes.
- **Trace 2:** BD branches `issue-2-contributing`, adds CONTRIBUTING.md, opens PR with `Closes #2`; SD reviews (leave at least one review comment and have it addressed), approves; merge; issue #2 auto-closes.

Capture for the manual: org and repo links, member list with roles, issue list
screenshot (dated), each PR page showing the review/approval and "Closes #N",
merge commit IDs, and the closed issues.
