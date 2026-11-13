# releases: one record per deployed release and environment

`<version>-<environment>.yml` (for example `v1-staging.yml`, `v1-production.yml`) is passed to
`ansible-playbook -i ansible/inventory.ini ansible/deploy.yml -e @releases/<file>`. Each record names the exact image
digest, the full source commit, the expected version and total, the public URL and the proxy network. Records hold
metadata only, never credentials. Production uses the same digest and commit as the staging record it was promoted from.
Start from `release.example.yml`; replace every placeholder.
