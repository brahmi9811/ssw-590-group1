# gitea/ — versioned, non-secret deployment files

Draft Compose stack: Gitea (SQLite) + Caddy (automatic HTTPS). Nothing here has
been run on a server yet. See `../README.md` (and `../BRAHMI.md`, which owns this folder) for ownership.

Open items before first deploy: confirm the provider (instructor reply pending),
claim the domain and point DNS at the VM, apply the cloud firewall (443, 80,
restricted SSH only), then:

    cp .env.example .env   # edit GITEA_DOMAIN
    docker compose up -d
    docker compose exec -u git gitea gitea admin user create --admin \
      --username <name> --email <email> --random-password   # note: password is printed once; store it in a vault, never in the repo

Never commit `.env` with real values or any credential. Docker-published ports
bypass `ufw`; use the cloud firewall and verify exposure from outside.
