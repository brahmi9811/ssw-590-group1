# SD's regions of the Assignment 8 chapter (rows 1, 2, 3, 8) and the shared manual edits

- `devopsDelivery-sd-head.tex`: chapter head, overview, rows 1-3 (sections deliveryService, deliveryImage, deliveryAnsible).
- `devopsDelivery-sd-tail.tex`: row 8 (deliveryManual with subsections deliveryRecords, deliveryRunbooks).
- `devopsDelivery.tex` for the manual repo = head + `../../bd-work/manual/devopsDelivery-bd.tex` + tail
  (`devopsDelivery-assembled-test.tex` is that concatenation as test-built on Nov 17, 2026).
- `0001-a8-delivery-chapter-test-assembly.patch`: everything except the evidence files, as one commit on top of manual `main` (d1da656):
  the chapter, `\include{devopsDelivery}` after devopsSre, version 1.4 and date, document history entry, Hosts and Passwords,
  8 glossary entries (rollback already existed), 9 references, SD's AI Prompt Log record, `TikZ/devopsDelivery/`, and
  `config/twintrack/` copies (app, tests, Dockerfile, playbook, template, inventory, the four release records).
  Apply with `git am`, then copy `assignment-8/evidence/17*` and `2[0-4]*` into `evidence/`.
- Local test build (Nov 17, 2026, about 11:45 PM New York) in `group1/texlive-node:2026.09` with the CI's latexmk command: exit 0,
  270 pages, no undefined or duplicate reference, no citation warning. One wide table remains in BD's region
  (Table DeliveryCredentials, about 58 pt too wide: `\texttt{gitea-registry-write}` / `/root/.docker/config.json`).
- Nothing was pushed to the manual repository.

## Update Nov 19, 2026 (after BD's course drill, evidence 243-246)
- SD regions updated: traceability rows for builds #14 (drill, failed staging) and #15 (restore, rejected), two more full digests,
  five registry versions (not three), row 3 notes that an unhealthy container also fails at the convergence step,
  failed-deployment runbook with the configuration-commit path (restore PR, then re-apply the last good record), PR list with #19, #26, #28, #29.
- Regenerate `devopsDelivery.tex` on the manual branch = new head + BD's current file + new tail (the BD region is untouched).
- `0002-history-entry-drill-update.patch`: the 1.4 history entry mentions evidence 200-246, both drills and PRs #28/#29 (`git am` after 0001).
- Test build with BD's current region and evidence 243-246: exit 0, 272 pages, no undefined/duplicate references, no overfull box in the chapter.
