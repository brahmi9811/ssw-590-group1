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

## Progress (Oct 19, 2026)
Staged in `assignment-5/manual-repo/` = exactly what gets pushed to `group1-startup/manual` once BD creates it:
- Standalone source: copy of the Assignment 4 manual; the 27 evidence files it prints are in `evidence/`, the two printed
  Gitea config files in `config/gitea/`; no `../` paths left.
- `ci/Dockerfile`: `texlive/texlive@sha256:7334b00b…` (TeX Live 2026) + Node.js 24 (needed by checkout/upload actions).
- `.gitea/workflows/build.yml`: push to `main` (+ manual dispatch), `runs-on: manual-builder`, checkout, toolchain versions,
  build ID `+build.<run>.<sha7>` via `latexmk -usepretex`, fail on LaTeX error / missing PDF / unresolved refs / missing ID,
  upload `it-manual-pdf` (`if-no-files-found: error`). Never commits back.
- `ci/local-build.sh`: same commands in the same image on a clean copy. Tested: clean build 18 s, title page and footers show
  `Version 1.0+build.42.a1b2c3d`; a deliberate undefined command exits 1 with no PDF.
- `devopsAutomatedBuild.tex`: new chapter, 8 regions; rows 3, 4 drafted (real local facts, run evidence pending), row 6 table
  and row 8 troubleshooting procedure drafted; BD's rows are placeholders for her.

### Notes for BD (runner)
1. Label: register the runner with `manual-builder:docker://group1/texlive-node:2026.09`, and build that image on the
   server from `ci/Dockerfile` (base layer ~2.7 GB download, ~9 GB on disk; server had 16 GB free on Oct 19). The image is
   local-only, so the runner must not force-pull it (check `act_runner`'s `container.force_pull` setting), or push it to a
   registry first (Gitea has a container registry).
2. `actions/upload-artifact@v4` is assumed to work with Gitea 1.27.3; if the first run fails at upload, switch to `@v3`.
3. `actions/checkout@v4` / `upload-artifact@v4` are fetched from github.com (Gitea default `DEFAULT_ACTIONS_URL=github`).
4. Root-file edits by SD for row 4 (please keep): `\BuildSuffix`/`\BuildRun`/`\BuildCommit` defaults, `\VERSION` includes
   `\BuildSuffix`, `\typeout` of the identifier, and `\include{devopsAutomatedBuild}`. The Introduction's repository-layout
   block still says `assignment-4/manual/` (yours to update).

## First runs on the server (Oct 19, 2026 EDT / Oct 20 UTC)
- Source pushed to https://git.ssw590-g1.tech/group1-startup/manual (commit `1fb4e15`). **From now on the Gitea repo is the
  source of truth**; `assignment-5/manual-repo/` here is only the staging copy (synced at `a5f3446`).
- Run #1 (`1fb4e15`): compile OK (87 pages, `+build.1.1fb4e15`), **upload failed**: `upload-artifact@v4` not supported by
  Gitea 1.27.3 (`GHESNotSupportedError`). Evidence 60.
- Run #2 (`a5f3446`, switched to `upload-artifact@v3`): **success**; artifact `it-manual-pdf` downloads anonymously as a zip
  containing `IT-manual+build.2.a5f3446.pdf` (87 pages, title page `Version 1.0+build.2.a5f3446`).

## Checklist
- [x] standalone manual source · [x] `build.yml` drafted and tested locally · [x] first green run (G3, run #2) · [ ] build ID visible in PDF
- [ ] two changes + failure + repair · [ ] rows 3, 4, 6 written with inline evidence · [ ] row 8 pass · [ ] history + AI-log lines
