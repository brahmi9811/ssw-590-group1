#!/usr/bin/env bash
# Runs ON THE SERVER, called by register-runner.ps1. Reads the registration token from stdin (never as an
# argument), writes it to a root-only file, starts the runner, then empties the file once registered.
set -euo pipefail
cd ~/runner
IFS= read -r TOKEN
TOKEN="$(printf '%s' "$TOKEN" | tr -d '[:space:]')"
[ -n "$TOKEN" ] || { echo "no token received"; exit 1; }
echo "token received: ${#TOKEN} characters"
umask 077
printf 'GITEA_RUNNER_REGISTRATION_TOKEN=%s\n' "$TOKEN" > runner.env
unset TOKEN
docker compose up -d
for i in $(seq 1 12); do
  sleep 5
  if docker compose logs runner 2>&1 | grep -qiE "registered successfully|runner registered|declare successfully"; then ok=1; break; fi
done
docker compose logs --tail 8 runner 2>&1
if [ "${ok:-0}" = 1 ]; then
  : > runner.env                      # token no longer needed; registration is stored in the volume
  docker compose up -d --force-recreate
  echo "--- registered; token file emptied ---"
else
  docker compose down                 # stop the retry loop and do not leave the token behind
  : > runner.env
  echo "--- registration NOT confirmed; runner stopped and token file emptied ---"
  exit 2
fi
