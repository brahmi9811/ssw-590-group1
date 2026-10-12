# Assignment 4 — Startup Foundation with Gitea (course manual Chapter 2)

Group 1: Brahmi Dalvi (BD), Sakshi Deshpande (SD). Course manual: `dosManual-V1.18.pdf`
(Chapters 1 and 2 govern this work; the PDF is not stored in this repo — get it from Canvas).

**Submit only the compiled PDF** of `manual/` (never the LaTeX source, screenshots, configs or backups).

## Folder map

| Path | What | Owner |
|---|---|---|
| `README.md` | This overview, decisions, hand-offs | shared (read-only in practice) |
| `BRAHMI.md` | Everything BD does, step by step, and what BD must not touch | BD |
| `SAKSHI.md` | Everything SD does, step by step, and what SD must not touch | SD |
| `manual/` | The team IT manual (LaTeX). Built from the Canvas template v1.3 | see regions below |
| `gitea/` | Versioned, non-secret deployment files (Compose, Caddyfile, `.env.example`) | BD only |
| `course-materials/` | The Canvas template zip | reference |

`report/` (the finished previous assignment) must not be modified by anyone.

## Decisions already made (Oct 12, 2026, by BD)
- Database: **SQLite, final.** No PostgreSQL work.
- Reverse proxy / TLS: **Caddy** (suggested by the course manual) with Let's Encrypt. Proposed, BD to confirm when deploying.
- **BD owns all deployment** (cloud VM, Gitea install, domain/DNS, HTTPS, firewall).
- The 20-point **backup/restore extra credit is mandatory for us** (SD owns it).
- **No cloud VM (AWS or DigitalOcean) is launched** until the instructor answers the AWS-instead-of-DigitalOcean email (gate G1).

## Ownership of the manual (all inside `manual/devopsGitea.tex`, one `Region:` block each)

The template requires one chapter per file, so both people edit the same file but **only their own regions**.

| Rubric row | Pts | `Region:` name | Owner |
|---|---|---|---|
| 1 Student Pack domain and DNS | 10 | `giteaDomainDns` | BD |
| 2 Pinned Gitea deployment | 10 | `giteaDeployment` | BD |
| 3 Database and persistence | 10 | `giteaDatabase` | SD |
| 4 HTTPS and certificate renewal | 15 | `giteaHttps` | BD |
| 5 Firewall and external exposure | 15 | `giteaFirewall` | BD |
| 6 Startup team workflow | 20 | `giteaWorkflow` | SD (BD acts as the 2nd member) |
| 7 Architecture and operation | 5 | `giteaArchitecture` | SD |
| 8 Manual quality and controls | 15 | `giteaManualQuality` | BD |
| Extra credit: backup and restore | up to 20 | `giteaExtraCredit` | SD |

BD = 65 pts, SD = 35 pts + 20 extra credit.

Other manual files: `devopsHostsPasswords.tex` → BD (SD may only add rows for SD's own accounts, hints only).
`devopsDocumentHistory.tex`, `devopsAIPromptLog.tex`, `devopsGlossary.tex`, `devopsReferences.bib` → append-only, each person adds their own lines.
Front matter, root file, `devopsIntroduction.tex`, template appendices → BD.

## Gates and hand-offs

| Gate | Meaning | Who unblocks it |
|---|---|---|
| G1 | Instructor approves AWS (or a DO credit exists) | BD |
| G2 | Domain claimed, DNS A record points at the VM | BD |
| G3 | Gitea reachable at `https://<hostname>` | BD |

| From → To | What | How (never put secrets in chat, repo or PDF) |
|---|---|---|
| BD → SD at G3 | SSH access to the VM | SD sends BD her **public** key; BD adds it to `authorized_keys` |
| BD → SD at G3 | Gitea URL and an admin or member account | Credential goes through a password manager / vault, not text |
| SD → BD | Passwords-table hint rows for SD's accounts | A one-line message; BD pastes into the table |
| SD → BD | Finished regions + history/prompt-log lines | Push to a branch; BD merges, builds, submits |

## Working agreement (applies to both people and both Claude sessions)
1. `git pull --rebase` before you start and before you push. Work on your own branch (`bd/…`, `sd/…`). Commit/push only when the human says so.
2. Edit only what your own file lists. If you need a change in the other person's area, write it in a message to them instead of editing.
3. Never fabricate command output, screenshots, dates, costs or test results. Unrun = `\StatusPending`. Failed attempts are documented, not hidden.
4. Never handle, print, store or commit credentials, tokens, private keys, `.env` with real values, or Gitea dumps (they contain secrets).
5. Never create a paid cloud resource or change a firewall without the human's explicit go-ahead in that session.
6. Mark unfinished text with `\Todo{...}`; no `\Todo` may remain in the submitted PDF.
7. Template rules still apply: one chapter per file, stable IDs, glossary/index entries for new terms, history entry for each change that says whether Hosts/Passwords tables changed.

## Building the PDF
`cd assignment-4/manual && bash build.sh` (uses MiKTeX + Pygments for `minted`, `-shell-escape`). `build.sh` has BD's Windows paths hardcoded (`MIKTEX_BIN`, `MAKEGLOSSARIES_LUA`, `PYGMENTS_BIN`); SD should change them **locally only** and not commit that change. Check the final pass of the log for `undefined`, `multiply defined`, and `!` errors. Source of the Canvas template: `course-materials/`.

## Final checklist before submission (BD runs it)
- [ ] All eight regions plus extra credit have real evidence, no `\Todo` left
- [ ] Hosts and Passwords tables current (hints only); history entry says so
- [ ] Version number bumped; history entries from both people present
- [ ] AI Prompt Log has a record for each AI-assisted session (both people)
- [ ] Hyperlinks work (Gitea repo, hostname); no secrets or unredacted IPs/keys in screenshots
- [ ] PDF opened and read page by page; only the PDF is uploaded to the LMS
