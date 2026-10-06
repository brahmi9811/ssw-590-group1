# Compiles LaTeX documents with TeX Live, the same distribution Overleaf uses.
FROM texlive/texlive:latest

# Documents are mounted here from the host at run time
WORKDIR /workdir

# latexmk reruns pdflatex/bibtex/makeindex until references settle.
# -shell-escape is required by the minted package used in the group report.
ENTRYPOINT ["latexmk", "-pdf", "-shell-escape", "-interaction=nonstopmode", "-halt-on-error"]
CMD ["hello.tex"]
