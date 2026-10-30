# Assignment 6 evidence index

Numbered files; BD uses 70+, SD uses 80+. Sanitized: no tokens, passwords, webhook secrets, admin IP or AWS account ID.

| # | File | What it shows | Rubric row | Date (local) |
|---|---|---|---|---|
| 70 | 70-local-test-run-pricing-example-2026-10-29.txt | Local run of the course Python example before the first PR: py_compile OK, unittest 2 tests OK (test_total, test_invalid_quantity); files unchanged from the manual | 4, 6 | Oct 29, 2026 (evening) |
| 71 | 71-gitea-twintrack-issue-9-pricing-jenkinsfile-opened-2026-10-29.png | twintrack issue #9 "Add pricing module, unit tests and Jenkinsfile for CI", opened by brahmi, Open; the issue the bootstrap PR will close | 4, 6 | Oct 29, 2026 (evening) |
| 72 | 72-jenkins-image-build-and-plugin-versions-2026-10-29.txt | Jenkins image build on the server (base 2.580.2-lts-jdk21 + python3 + 4 plugins): BUILD_EXIT=0, 547MB; memory watchdog (lowest free 131 MB, swap peak 147 MB, Gitea healthy); Jenkins 2.580.2, Java 21.0.13, Python 3.13.5; 60 installed plugins with exact versions | 1 | Oct 29, 2026 (evening) |
| 73 | 73-jenkins-first-start-memory-and-exposure-2026-10-29.txt | Jenkins first start: fully up in about 25 s, peak 408 MiB of the 640 MiB cap, no restarts or OOM, Gitea healthy; settled state (98 MB RAM free, swap 176 MB); no published ports; reachable privately from Caddy (HTTP 200); raw 8080 closed from outside | 1, 2 | Oct 29, 2026 (evening) |
