# pricing-service: Startup Pricing Service (Assignment 8, course Chapter 6)

The course's stateless Flask + Gunicorn starter, release **v1** (USD 10 per unit). v2 (USD 12) comes later in its own
reviewed commit. Endpoints: `GET /` (service, version, source commit), `GET /health`, `GET /price?quantity=N` (1-1000, else 400).

Build inputs are locked:
- `requirements.in` holds the course's ranges; `requirements.txt` is the lock made from it with
  `pip-compile 7.6.2 --generate-hashes --strip-extras --no-emit-index-url` inside the base image (exact versions and hashes
  for all direct and transitive packages). Re-lock and rescan whenever `requirements.in` or the base image changes.
- `Dockerfile` uses `python:3.13.18-slim-trixie` pinned by digest and installs with `--require-hashes --no-deps`;
  the image runs Gunicorn as uid 10001. The source commit is baked in at build time with `--build-arg APP_COMMIT=<full sha>`.

Tests (from this folder, in a virtual environment):
```sh
python3 -m venv .venv && . .venv/bin/activate
pip install --require-hashes --no-deps -r requirements.txt
python -m unittest -v
```
Delivery (image build, scans, registry push, Ansible deploy to staging and production) runs in Jenkins on the trusted
agent; see `../ansible/` and `../releases/`.
