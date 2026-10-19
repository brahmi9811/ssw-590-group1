# SAKSHI (SD) — Assignment 5 scope and plan

Read `README.md` first. Course manual Chapter 3 is the source of truth.

## SD owns: rows 3, 4, 6, 8 (55 points)
- **Row 3 — Reproducible compilation (20).** Write `.gitea/workflows/build.yml`: check out the triggering revision; use a
  **pinned** TeX Live job image (record tag or digest; `latex-docker/` from the earlier assignment is a starting point);
  run `latexmk -pdf -shell-escape` on the main file (minted needs `-shell-escape` and Pygments; glossaries needs the `latexmkrc`
  rule); **fail** on a compile error and fail if the expected PDF path is missing. Document toolchain/image version,
  dependencies, build command, main file, PDF path, where TeX is installed and how the job gets it, and that checkout and artifact
  upload go over HTTPS (no shared filesystem with Gitea). Link a successful run log. Do not download and run unreviewed scripts.
- **Row 4 — PDF version traceability (15).** Keep the human version (`\DocumentVersion`) and append a build suffix
  `+build.<run_number>.<short_sha>` visible on the title page/footer. Inject it at build time (a generated `buildinfo.tex` or
  `latexmk -usepretex` definitions from `${{ gitea.run_number }}` / `${{ gitea.sha }}`, verified against Gitea's docs),
  with a safe default for local builds. Never commit it back (no push/build loop). Evidence: PDF page showing the ID next to
  the matching Gitea run.
- **Row 6 — Change, failure, and repair (10).** Two successive source commits, each with its run number and PDF build ID;
  one deliberate, safe LaTeX error on a branch the workflow covers (e.g. an undefined command in a throwaway line), the failed
  run, then the repair commit and its passing run. Table of expected vs. actual, commit IDs matched across all evidence.
  Do not disrupt the live Gitea service.
- **Row 8 — Manual quality and controls (10).** Last, after BD's rows have real content: version bump and dated history entry,
  say whether Hosts/Passwords changed (ask BD), citations, glossary/index terms (Gitea Actions, runner, artifact, job container),
  sanitized evidence, and a **short failed-build troubleshooting procedure**. Whole-PDF scan for `\Todo`, secrets, broken links.

## Not SD's (BD's)
Rows 1, 2, 5, 7; creating the repo; installing or registering the runner; any server, firewall, or paid change; the Hosts and
Passwords tables (SD only reports her own hints). If something there looks wrong, message BD instead of editing.

## Can start now (no server needed)
1. Prepare the manual source so it builds **standalone** (copy referenced evidence into the manual repo or fix paths; no `../`).
2. Draft `build.yml` and the build-ID injection, and test the same `latexmk` command locally with the TeX Live container.
3. Draft the new chapter's rows 3, 4, 6 with `\StatusPending` where results are not yet real.

## Waits for BD
- Runner online (G2) before the first real run; repo `group1-startup/manual` created before pushing the source.

## Checklist
- [ ] standalone manual source · [ ] `build.yml` drafted and tested locally · [ ] first green run (G3) · [ ] build ID visible in PDF
- [ ] two changes + failure + repair · [ ] rows 3, 4, 6 written with inline evidence · [ ] row 8 pass · [ ] history + AI-log lines
