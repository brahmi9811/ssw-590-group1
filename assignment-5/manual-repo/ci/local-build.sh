#!/usr/bin/env bash
# Runs the same build as .gitea/workflows/build.yml, in the same job image, on a clean copy of the
# repository, so a change can be tested before it is pushed.
#   ci/local-build.sh [run_number] [commit_sha]   (defaults: 0 and the current HEAD, or "0000000")
# Output: out/IT-manual+build.<run>.<short>.pdf
set -euo pipefail
cd "$(dirname "$0")/.."
IMAGE="${IMAGE:-group1/texlive-node:2026.09}"
RUN="${1:-0}"
SHA="${2:-$(git rev-parse HEAD 2>/dev/null || echo 0000000)}"
SHORT="$(printf '%s' "$SHA" | cut -c1-7)"
SUFFIX="+build.${RUN}.${SHORT}"

docker image inspect "$IMAGE" >/dev/null 2>&1 || docker build -t "$IMAGE" ci

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
# A clean copy stands in for the checkout: no build products from earlier local runs.
rsync -a --exclude out --exclude '*.pdf' --exclude '_minted*' --exclude '*.aux' --exclude '*.log' \
  --exclude '*.fdb_latexmk' --exclude '*.fls' ./ "$WORK/"
cp evidence/*.pdf "$WORK/evidence/" 2>/dev/null || true

docker run --rm -v "$WORK":/work -w /work "$IMAGE" bash -c "
  set -euo pipefail
  latexmk -pdf -shell-escape -interaction=nonstopmode -halt-on-error \
    -usepretex='\\def\\BuildSuffix{${SUFFIX}}\\def\\BuildRun{${RUN}}\\def\\BuildCommit{${SHORT}}' \
    devopsITManual.tex >/work/build-output.txt 2>&1 || { tail -40 /work/build-output.txt; exit 1; }
  test -s devopsITManual.pdf
  ! grep -E 'undefined references|multiply defined' devopsITManual.log
  grep -F 'Build identifier: Version' devopsITManual.log
  grep -qF '${SUFFIX}' devopsITManual.log
"
mkdir -p out
cp "$WORK/devopsITManual.pdf" "out/IT-manual${SUFFIX}.pdf"
echo "OK: out/IT-manual${SUFFIX}.pdf"
