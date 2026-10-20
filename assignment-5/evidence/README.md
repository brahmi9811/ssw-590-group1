# Assignment 5 evidence index

Numbered files; BD uses 50+, SD uses 60+. Sanitized: no tokens, no admin IP, no AWS account ID.

| # | File | What it shows | Rubric row | Date (local) |
|---|---|---|---|---|
| 50 | 50-gitea-admin-runners-group1-runner-1-idle-manual-builder-2026-10-19.png | Gitea Site Administration > Actions > Runners: group1-runner-1, v0.6.1, Global scope, label manual-builder, Idle, last online "now" | 2 | Oct 19, 2026 (evening) |
| 51 | 51-gitea-manual-repo-collaborators-sakshi-write-teams-owners-developers-2026-10-19.png | group1-startup/manual > Settings > Collaborators: sakshi (Write); teams Owners (Owner) and developers (unit permissions incl. Code, Pull Requests, Actions) | 1, 7 | Oct 19, 2026 (evening) |
| 60 | 60-run1-full-log-upload-artifact-v4-not-supported-2026-10-20.txt | Full job log of run #1 (commit `1fb4e15`, runner group1-runner-1), downloaded anonymously from the public repo: checkout, toolchain, build ID `+build.1.1fb4e15`, compile OK (87 pages, 38 s), PDF check OK; **upload failed**: `GHESNotSupportedError: upload-artifact@v4+ ... not currently supported on GHES`. Corrected by switching to `upload-artifact@v3`. | 3, 6, 8 (failed test) | 2026-10-19 22:57 EDT (02:57 UTC Oct 20) |
