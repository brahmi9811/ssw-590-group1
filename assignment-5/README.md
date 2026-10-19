# Assignment 5 — Automated LaTeX Manual Builds with Gitea Actions (course manual Chapter 3)

Group 1: Brahmi Dalvi (BD), Sakshi Deshpande (SD). Source of truth: `dosManual-V1.18.pdf`, **Chapter 3** (pages 9–14) plus the
common rules in Chapter 1 and Appendix A. If anything here conflicts with the course manual, the manual wins.

**Submit only the compiled PDF**, and it must be **downloaded from a successful Gitea Actions run**.

## The assignment in short
Move the IT manual's LaTeX source into our Gitea (`git.ssw590-g1.tech`) so that every push to the chosen branch triggers a
**Gitea Actions** workflow that:
1. runs on a **self-managed Gitea runner** (`act_runner`), not GitHub-hosted and not Overleaf;
2. checks out the triggering commit and compiles the manual with **TeX Live + `latexmk -pdf`** in a pinned toolchain, ideally a temporary job container;
3. **fails clearly** if compilation fails or the PDF is missing;
4. stamps the PDF with a visible build identifier: human version + commit short hash + run number, e.g. `v1.1+build.42.a1b2c3d`
   (no auto-commit back to the branch, which would cause a push/build loop);
5. uploads the PDF as a **named Actions artifact** that a team member can download.

The manual gets a new **"Automated Manual Build"** chapter with 8 numbered subsections in rubric order, with dated, sanitized
evidence and clickable Gitea links inside the PDF.

## Rubric (100 points) and owners
| # | Rubric row | Pts | Owner |
|---|---|---|---|
| 1 | Source and trigger: repo, main `.tex`, workflow, branch/push event, remote protocol, public port, TLS proxy, private Gitea port, why the runner needs no public port | 15 | BD |
| 2 | Runner setup: version, location, scope, label, execution mode, network path, capacity; registered/online runner and an assigned job; isolation, no public ports | 15 | BD |
| 3 | Reproducible compilation: toolchain/image version, dependencies, build command, main file, PDF path; successful run log; failure detection; where TeX lives; checkout and upload without a shared filesystem | 20 | SD |
| 4 | PDF version traceability: human version, build identifier, visible commit hash and run number in the PDF, matching run; how metadata is injected without a commit/push loop | 15 | SD |
| 5 | Downloadable artifact: link the named artifact, show the downloaded file opens, retention setting or observed default; not a backup | 10 | BD |
| 6 | Change, failure, and repair: two successive commits with matching runs/PDF IDs, one safe failed compile and its repaired passing run; commit IDs matched across evidence | 10 | SD |
| 7 | Runner and secret boundary: workflow edit rights, token/secret storage without values, runner isolation, Docker privilege risk | 5 | BD |
| 8 | Manual quality and controls: version and dated history; say whether Hosts/Passwords changed; citations, glossary/index, sanitized evidence, short failed-build troubleshooting procedure | 10 | SD |

**BD = 45 points (rows 1, 2, 5, 7). SD = 55 points (rows 3, 4, 6, 8).**

## Decision needed first (gate G1): where the runner runs
Server today (read-only check, Oct 19, 2026): EC2 `t3.micro`, **16 GB free disk, ~1 GB RAM + 2 GB swap**, Gitea + Caddy running.

| Option | Pros | Cons |
|---|---|---|
| **A. Runner on the same EC2 server** (course Figure 3.2) | Always on; TA can trigger builds | Full `texlive/texlive` image is ~9 GB on disk (fits, tight); 1 GB RAM is little for Gitea + a LaTeX build (slow, relies on swap); maybe upsize to `t3.small` (verify price) |
| **B. Same server, smaller custom TeX image** | Much less disk; faster pulls | Must build and maintain it; list exact packages (minted + Pygments, glossaries, tikz, biblatex/bibtex, makeindex) |
| **C. Runner on a laptop** | No server load; SD's Mac already has the TeX Live image | Builds only while the laptop is on; weaker for TA testing |

**Recommendation:** A, with B as the fallback if disk/RAM struggles. **BD decides** (she owns the server and every paid change).
Whatever is chosen: if the runner mounts the Docker socket, jobs get root-equivalent power on that host, so only BD and SD may
edit workflows (row 7).

## How to start (in order)
| Step | What | Who | Gate |
|---|---|---|---|
| 0 | Agree on the runner option and instance size | BD + SD | G1 |
| 1 | Create repo `group1-startup/manual`; push the manual source so it builds **from that repo alone** (today it reads `../evidence/`: copy needed evidence into the repo or change paths) | BD creates repo, SD prepares the source | — |
| 2 | Install and register `act_runner` with a label (e.g. `ubuntu-latest:docker://...` or a custom label); keep the registration token in a password manager | BD | G2: runner online |
| 3 | Minimal `.gitea/workflows/build.yml`: checkout → latexmk → fail if no PDF → upload artifact; get **one green run** | SD | G3: first green run |
| 4 | Build identifier in the PDF (generated metadata file or `-usepretex` definitions), no commit back | SD | — |
| 5 | Two successive changes + one deliberate failing commit + its repair | SD (BD reviews) | — |
| 6 | New chapter "Automated Manual Build", evidence inline, history/AI log, row 8 last | both, own regions | — |

## Working agreement (same as Assignment 4)
1. Work directly on `main` of this GitHub repo; `git pull --rebase` before you start and before you push. Commit/push only when the human says so.
2. Edit only your own rows/regions; for the other person's area, send a message instead.
3. Never fabricate output, screenshots, dates, or results. Unrun = `\StatusPending`. Failed attempts are documented, not hidden.
4. Never put tokens (runner registration token, Gitea access tokens), passwords, private keys or `.env` values in chat, the repo, logs, or the PDF. Delete personal access tokens after use.
5. No paid cloud change, firewall change, or runner registration without BD's explicit go-ahead.
6. Evidence goes **inside the PDF** (figures and `longlisting` listings, `\FigRef`/`\ListRef`), numbered files in `evidence/` with an index row.
7. The workflow must never commit or push back to the branch it builds.
