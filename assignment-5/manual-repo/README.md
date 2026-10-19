# Group 1 DevOps IT manual

LaTeX source of the SSW 590 Group 1 IT manual. Every push to `main` builds the PDF with Gitea Actions
(`.gitea/workflows/build.yml`) on the team's self-managed runner and publishes it as the artifact `it-manual-pdf`.

- Main file: `devopsITManual.tex` (one chapter per `devops*.tex` file; TikZ sources in `TikZ/<chapter>/`).
- Evidence used by the PDF: `evidence/`; non-secret configuration printed in the PDF: `config/`.
- Build: `latexmk -pdf -shell-escape devopsITManual.tex` (`latexmkrc` adds the glossary rule; `minted` needs `-shell-escape` and Pygments).
- Version shown in the PDF: `\DocumentVersion` (maintained by hand) + a build suffix `+build.<run>.<short-sha>` injected by the
  workflow with `latexmk -usepretex`; a local build shows `+local`. The workflow never commits back to the repository.

## Job image and runner label
`ci/Dockerfile` = TeX Live 2026 (`texlive/texlive`, pinned by digest) + Node.js (needed by `actions/checkout` and
`actions/upload-artifact`). The workflow runs on the runner label `manual-builder`, which must map to this image, e.g.

    docker build -t group1/texlive-node:2026.09 ci
    # act_runner label:  manual-builder:docker://group1/texlive-node:2026.09

## Test a change before pushing
    ci/local-build.sh            # same commands as the workflow, same image, clean copy -> out/IT-manual+build.0.<sha>.pdf

Do not commit generated PDFs, build logs, tokens, or secrets.
