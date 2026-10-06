#!/bin/bash
# Build the LaTeX image once, then compile a .tex file from the current folder.
# Usage: ./build.sh [file.tex]   (defaults to hello.tex)
set -euo pipefail
cd "$(dirname "$0")"
docker build -t latex-builder .
docker run --rm -v "$PWD":/workdir latex-builder "${1:-hello.tex}"
