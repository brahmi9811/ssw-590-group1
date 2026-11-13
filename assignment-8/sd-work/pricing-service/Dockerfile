# Startup Pricing Service (course Chapter 6 starter, adapted by Group 1).
# Base image pinned by digest: python:3.13.18-slim-trixie, OCI index digest (linux/amd64 manifest
# sha256:48d884813cf44e927cf64c5529dd630dd3b18338c6dc727991eef9b71e934a20), resolved Nov 12, 2026.
FROM python:3.13.18-slim-trixie@sha256:e48f59cdba69a3cbd9ed2cf0f348d90d45a8d350d98134cf1070bc106ee9ed90
ARG APP_COMMIT=development
ENV APP_COMMIT=$APP_COMMIT PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
# requirements.txt is the lock produced by pip-compile --generate-hashes from requirements.in:
# every direct and transitive package has an exact version and hash; anything else is refused.
COPY requirements.txt .
RUN pip install --no-cache-dir --require-hashes --no-deps -r requirements.txt
COPY app.py .
USER 10001:10001
EXPOSE 8000
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "1", "--worker-tmp-dir", "/tmp", "app:app"]
