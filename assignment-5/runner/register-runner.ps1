# Run this in YOUR OWN PowerShell terminal (not through Claude). It asks for the runner registration token
# without showing it, sends it to the server over SSH, and does not save it anywhere on this machine.
$ErrorActionPreference = "Stop"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ssh = Join-Path $env:USERPROFILE ".ssh"
$opts = @("-i", (Join-Path $ssh "ssw590-g1-gitea-key.pem"), "-o", "IdentitiesOnly=yes",
          "-o", "UserKnownHostsFile=$(Join-Path $ssh 'known_hosts_ssw590')", "-o", "StrictHostKeyChecking=yes")
$target = "ec2-user@git.ssw590-g1.tech"

ssh @opts $target "mkdir -p ~/runner"
scp @opts (Join-Path $dir "docker-compose.yml") (Join-Path $dir "config.yaml") (Join-Path $dir "remote-register.sh") "${target}:runner/"

# Pasting into a terminal prompt kept only 1 character here, so the token is taken from the clipboard instead.
Read-Host "Copy the runner registration token in Gitea now, then press Enter here (the token is not displayed)" | Out-Null
$plain = ((Get-Clipboard) -join "").Trim()
Write-Host "Read $($plain.Length) characters from the clipboard."
if ($plain.Length -lt 20) { throw "Token looks too short ($($plain.Length) characters). Copy it again; nothing was sent to the server." }
$plain | ssh @opts $target "bash ~/runner/remote-register.sh"
$plain = $null
