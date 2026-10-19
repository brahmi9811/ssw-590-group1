# Job image for the Gitea Actions manual build.
# TeX Live (pdflatex, latexmk, bibtex, makeglossaries, makeindex, Pygments for minted),
# pinned by digest, plus Node.js, which the JavaScript actions (checkout, upload-artifact) need.
FROM texlive/texlive@sha256:7334b00bf8e7a0996f7ddd65482363aaf7711d372e569f3ea78509619e3083ff

RUN apt-get update \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*
