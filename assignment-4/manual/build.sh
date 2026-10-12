#!/usr/bin/env bash
# Local PDF build for the team IT manual (devopsITManual.tex). Run from this directory:
#   ./build.sh
# Uses -shell-escape because minted shells out to Pygments.
set -e
cd "$(dirname "$0")"

MIKTEX_BIN="/c/Users/BRAHMI/AppData/Local/Programs/MiKTeX/miktex/bin/x64"
MAKEGLOSSARIES_LUA="/c/Users/BRAHMI/AppData/Local/Programs/MiKTeX/scripts/glossaries/makeglossaries-lite.lua"
PYGMENTS_BIN="/c/Users/BRAHMI/AppData/Roaming/Python/Python314/Scripts"
export PATH="$PATH:$MIKTEX_BIN:$PYGMENTS_BIN"

pdflatex -shell-escape -interaction=nonstopmode devopsITManual.tex
bibtex devopsITManual
texlua "$MAKEGLOSSARIES_LUA" devopsITManual
makeindex devopsITManual
pdflatex -shell-escape -interaction=nonstopmode devopsITManual.tex
pdflatex -shell-escape -interaction=nonstopmode devopsITManual.tex

# Remove build byproducts, keep the .tex sources and the PDF.
rm -f *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg *.idx *.ind *.ilg *.ist *.glo *.gls *.glg *.acn *.acr *.alg
rm -rf _minted-devopsITManual

echo "Build complete: devopsITManual.pdf"
