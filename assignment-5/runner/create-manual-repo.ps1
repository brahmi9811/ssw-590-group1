# Run in YOUR OWN PowerShell terminal. Creates the public repository group1-startup/manual in Gitea,
# gives the team "developers" (Sakshi) write access, and turns Actions on for it. Safe to run twice.
# The Gitea access token is taken from the clipboard (pasting into a prompt is unreliable here), kept only in
# memory, and never printed. Create it in Gitea > Settings > Applications with scopes: read:user,
# write:organization, write:repository. DELETE it afterwards and clear the clipboard.
$ErrorActionPreference = "Stop"
$base = "https://git.ssw590-g1.tech/api/v1"
$org = "group1-startup"; $repo = "manual"

Read-Host "Copy the Gitea access token now, then press Enter here (the token is not displayed)" | Out-Null
$token = ((Get-Clipboard) -join "").Trim()
Write-Host "Read $($token.Length) characters from the clipboard."
if ($token.Length -lt 20) { throw "Token looks too short; nothing was sent." }
$h = @{ Authorization = "token $token" }

function Call($method, $path, $body) {
    try {
        $p = @{ Uri = "$base$path"; Method = $method; Headers = $h; ContentType = "application/json"; UseBasicParsing = $true }
        if ($body) { $p.Body = ($body | ConvertTo-Json -Depth 5) }
        return @{ ok = $true; data = (Invoke-RestMethod @p) }
    } catch {
        $code = 0; if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
        return @{ ok = $false; code = $code }
    }
}

$me = Call GET "/user"
if (-not $me.ok) { throw "Token rejected (HTTP $($me.code))." }
Write-Host "Signed in as: $($me.data.login)"

# 1. repository
$r = Call GET "/repos/$org/$repo"
if ($r.ok) { Write-Host "1. Repository $org/$repo already exists (private=$($r.data.private))." }
else {
    $c = Call POST "/orgs/$org/repos" @{ name = $repo; description = "Group 1 DevOps IT manual (LaTeX source, built by Gitea Actions)"; private = $false; auto_init = $false; default_branch = "main" }
    if ($c.ok) { Write-Host "1. Created public repository $org/$repo." } else { throw "Could not create the repository (HTTP $($c.code))." }
}

# 2. write access for the team that holds Sakshi
$t = Call GET "/orgs/$org/teams/search?q=developers"
$team = $null; if ($t.ok) { $team = $t.data.data | Where-Object { $_.name -eq "developers" } | Select-Object -First 1 }
if ($team) {
    Write-Host "2. Team developers: permission=$($team.permission), includes_all_repositories=$($team.includes_all_repositories)"
    if (-not $team.includes_all_repositories) {
        $a = Call PUT "/teams/$($team.id)/repos/$org/$repo" $null
        if ($a.ok) { Write-Host "   Added the repository to the team." } else { Write-Host "   Could not add the repository to the team (HTTP $($a.code))." }
    }
} else { Write-Host "2. Team developers not found (or not visible to this token)." }
$col = Call GET "/repos/$org/$repo/collaborators/sakshi/permission"
if ($col.ok) { Write-Host "   Sakshi's effective permission on the repository: $($col.data.permission)" } else { Write-Host "   Could not read Sakshi's permission (HTTP $($col.code))." }

# 3. Actions enabled on the repository
$p = Call PATCH "/repos/$org/$repo" @{ has_actions = $true }
if ($p.ok) { Write-Host "3. Actions enabled on the repository: has_actions=$($p.data.has_actions)" } else { Write-Host "3. Could not set has_actions (HTTP $($p.code))." }

$token = $null; $h = $null
Write-Host ""
Write-Host "Done. Now: DELETE the token in Gitea > Settings > Applications, and copy any ordinary text to clear the clipboard."
Write-Host "Repository: https://git.ssw590-g1.tech/$org/$repo"
