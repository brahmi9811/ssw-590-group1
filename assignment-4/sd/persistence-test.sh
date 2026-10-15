#!/usr/bin/env bash
# Rubric row 3: prove a Gitea repository and issue survive replacement of the
# Gitea container (volumes kept). Run on the Docker host, from assignment-4/gitea.
#
#   GITEA_URL=https://git.example.me GITEA_USER=<user> ../sd/persistence-test.sh | tee persistence.log
#
# The password is read from the terminal (or GITEA_PASS) and is never printed.
# This is NOT a backup/restore test: nothing is copied out of the volume.
set -euo pipefail

: "${GITEA_URL:?set GITEA_URL, e.g. https://localhost}"
: "${GITEA_USER:?set GITEA_USER}"
if [ -z "${GITEA_PASS:-}" ]; then
  read -rsp "Gitea password for $GITEA_USER: " GITEA_PASS; echo >&2
fi
REPO="${REPO:-persistence-check}"
CURL=(curl -fsS ${CURL_INSECURE:+-k} -u "$GITEA_USER:$GITEA_PASS" -H 'Content-Type: application/json')
API="$GITEA_URL/api/v1"
ts() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
show() { echo "\$ $*"; }

wait_healthy() {
  for _ in $(seq 1 40); do
    [ "$(docker inspect -f '{{.State.Health.Status}}' gitea 2>/dev/null)" = healthy ] && return 0
    sleep 3
  done
  echo "gitea did not become healthy" >&2; return 1
}

snapshot() {
  echo "--- $1 ($(ts)) ---"
  show docker inspect gitea --format '{{.Id}} created={{.Created}}'
  docker inspect gitea --format '{{slice .Id 0 12}} created={{.Created}}'
  show docker inspect gitea --format '(mounts: type name -> destination)'
  docker inspect gitea --format '{{range .Mounts}}{{.Type}} {{.Name}} -> {{.Destination}}{{println}}{{end}}'
  show docker compose exec gitea ls -l /data/gitea/gitea.db
  docker compose exec -T gitea ls -l /data/gitea/gitea.db
  show "GET $API/repos/$GITEA_USER/$REPO"
  "${CURL[@]}" "$API/repos/$GITEA_USER/$REPO" \
    | python3 -c 'import sys,json;r=json.load(sys.stdin);print("repo id=%s full_name=%s created=%s" % (r["id"], r["full_name"], r["created_at"]))'
  show "GET $API/repos/$GITEA_USER/$REPO/issues/1"
  "${CURL[@]}" "$API/repos/$GITEA_USER/$REPO/issues/1" \
    | python3 -c 'import sys,json;i=json.load(sys.stdin);print("issue #%s id=%s state=%s title=%r" % (i["number"], i["id"], i["state"], i["title"]))'
  show "GET $API/repos/$GITEA_USER/$REPO/branches/main"
  "${CURL[@]}" "$API/repos/$GITEA_USER/$REPO/branches/main" \
    | python3 -c 'import sys,json;b=json.load(sys.stdin);print("branch %s commit=%s" % (b["name"], b["commit"]["id"][:12]))'
}

echo "=== Gitea persistence test, started $(ts) ==="
echo "host: $(hostname)  url: $GITEA_URL  user: $GITEA_USER"

# 1. Create the test repository (with a README commit) and one issue, if absent.
if ! "${CURL[@]}" "$API/repos/$GITEA_USER/$REPO" >/dev/null 2>&1; then
  show "POST $API/user/repos  (name=$REPO, auto_init=true)"
  "${CURL[@]}" -X POST "$API/user/repos" \
    -d "{\"name\":\"$REPO\",\"auto_init\":true,\"description\":\"Row 3 persistence test\"}" >/dev/null
  show "POST $API/repos/$GITEA_USER/$REPO/issues"
  "${CURL[@]}" -X POST "$API/repos/$GITEA_USER/$REPO/issues" \
    -d '{"title":"Persistence check: this issue must survive container replacement"}' >/dev/null
fi

wait_healthy
snapshot "BEFORE container replacement"

# 2. Replace only the Gitea container. Volumes are NOT removed (no -v, no volume rm).
echo "--- replacing container ($(ts)) ---"
show docker compose up -d --force-recreate gitea
docker compose up -d --force-recreate gitea 2>&1
wait_healthy

snapshot "AFTER container replacement"
echo "=== finished $(ts) ==="
