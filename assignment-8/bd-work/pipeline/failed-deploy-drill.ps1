# Failed-deployment drill, Assignment 8 case (b), done through the Gitea API (BD runs this herself; it contains no secret).
# What it does, in order (every step is printed; it stops at the first unexpected result):
#   1. asks for the Gitea user name and the token (the token is typed at a hidden prompt; it exists only in this process and in a temporary
#      askpass file that is deleted at the end; it is never written to Git, to a log, or shown)
#   2. creates the issue, renames the prepared branch to issue-<n>-..., pushes it, opens the pull request, waits for the required check
#      pr-main to be green, merges it (as administrator, force merge, because this is a deliberate drill commit)
#   3. waits until Jenkins reports the result of the build on main (expected: FAILURE at "Deploy staging": Compose wait fails because
#      the staging command binds Gunicorn to 8001 while the healthcheck tests 8000)
#   4. prepares the restore commit (the reviewed template of 06550eb is put back), pushes it, opens the pull request, waits for pr-main,
#      merges it, and tells you what to click in Jenkins (the restore build stops at the approval prompt: click Abort)
# Needs: the token with scopes write:repository and write:issue; git in PATH; the clone E:\git-repos\ssw590\twintrack on branch drill-staging-bind-8001.
# Run from PowerShell:  powershell -ExecutionPolicy Bypass -File E:\git-repos\ssw590\ssw-590-group1\assignment-8\bd-work\pipeline\failed-deploy-drill.ps1

$ErrorActionPreference = 'Stop'
$Repo     = 'E:\git-repos\ssw590\twintrack'
$Base     = 'https://git.ssw590-g1.tech'
$Api      = "$Base/api/v1/repos/group1-startup/twintrack"
$GoodSha  = '06550eb4fe5d3315b31e1a1bd2fe1b4f034af77f'    # the last reviewed template (merge of the v2 pull request)
$DrillBranchStart = 'drill-staging-bind-8001'

function Git {
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    try { & git.exe @args 2>&1 | ForEach-Object { Write-Host ("    git: " + $_) }; $script:GitCode = $LASTEXITCODE }
    finally { $ErrorActionPreference = $old }
}
function Say($m) { Write-Host ("[{0}] {1}" -f (Get-Date -Format 'HH:mm:ss'), $m) }
function Stop-Here($m) { Write-Host ""; Write-Host "STOPPED: $m" -ForegroundColor Red; exit 1 }

$user = Read-Host 'Gitea user name (for example brahmi)'
$sec  = Read-Host 'Gitea token (typed here only; not shown)' -AsSecureString
$tok  = [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
$H    = @{ Authorization = "token $tok" }

# git asks the askpass program for the user name and the token; the token comes from this process' environment
$ask = Join-Path $env:TEMP ("askpass-" + [guid]::NewGuid().ToString('N') + '.cmd')
Set-Content -Path $ask -Encoding ascii -Value "@echo off`r`necho %1 | findstr /i `"username`" >nul && (echo %GITEA_USER%) || (echo %GITEA_TOKEN%)"
$env:GIT_ASKPASS = $ask; $env:GITEA_USER = $user; $env:GITEA_TOKEN = $tok; $env:GIT_TERMINAL_PROMPT = '0'

function Api($method, $path, $body) {
    $uri = "$Api$path"
    try {
        if ($null -ne $body) { return Invoke-RestMethod -Method $method -Uri $uri -Headers $H -ContentType 'application/json' -Body ($body | ConvertTo-Json -Depth 5) }
        return Invoke-RestMethod -Method $method -Uri $uri -Headers $H
    } catch {
        $code = $null; if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
        throw ("API {0} {1} failed (HTTP {2}): {3}" -f $method, $path, $code, $_.Exception.Message)
    }
}
function Wait-Check($sha, $minutes) {
    # returns the combined state of the commit once it is success, failure or error; stops waiting after $minutes
    $until = (Get-Date).AddMinutes($minutes)
    while ((Get-Date) -lt $until) {
        $st = Invoke-RestMethod -Uri "$Api/commits/$sha/status"
        if ($st.state -in @('success','failure','error')) { return $st }
        Start-Sleep -Seconds 10
    }
    return $null
}
function Merge-Pr($index) {
    Say "merging pull request #$index (administrator force merge)"
    try { Api 'POST' "/pulls/$index/merge" @{ Do = 'merge'; force_merge = $true } | Out-Null }
    catch { Stop-Here ("the merge was refused (" + $_.Exception.Message + "). Merge that pull request by hand in the browser and tell the assistant what you did; this script cannot resume.") }
}

try {
    Set-Location $Repo
    $me = Api 'GET' '' $null     # repository info; proves the token works
    Say "token works; repository $($me.full_name)"
    $who = Invoke-RestMethod -Uri "$Base/api/v1/user" -Headers $H
    Say "signed in as $($who.login)"

    $cur = (git.exe rev-parse --abbrev-ref HEAD).Trim()
    if ($cur -ne $DrillBranchStart) { Stop-Here "expected branch $DrillBranchStart, found $cur" }
    if ((git.exe status --porcelain | Out-String).Trim()) { Stop-Here "the working tree is not clean" }

    # ---- 2. issue, branch, pull request, merge of the drill commit
    $issue = Api 'POST' '/issues' @{ title = 'Failed-deployment drill: bind Gunicorn to 8001 in staging (Assignment 8, case b)';
        body = "Course exercise (Chapter 6, step 8, case b): in a separate configuration commit the staging Compose command binds Gunicorn to 8001 while the image healthcheck still tests 8000. Compose wait must fail and the Jenkins run must stop before the approval; production is not affected. A second commit restores the reviewed template." }
    $n = $issue.number
    Say "issue #$n created"
    $branch = "issue-$n-staging-bind-8001"
    Git branch -m $DrillBranchStart $branch
    if ($script:GitCode -ne 0) { Stop-Here 'git branch rename failed' }
    Git push -u origin $branch
    if ($script:GitCode -ne 0) { Stop-Here 'git push failed' }
    $pr1 = Api 'POST' '/pulls' @{ title = "Failed-deployment drill: Gunicorn on 8001 in staging (issue #$n)"; head = $branch; base = 'main';
        body = "Refs #$n. Deliberate configuration change for the course's failed-deployment exercise (staging only). The restore pull request follows and closes the issue." }
    Say "pull request #$($pr1.number) opened"
    $sha1 = $pr1.head.sha
    Say "waiting for the required check pr-main on $($sha1.Substring(0,7)) (up to 8 minutes)"
    $c = Wait-Check $sha1 8
    if ($null -eq $c -or $c.state -ne 'success') { Stop-Here "the PR check did not turn green (state: $($c.state)); look at the pull request in the browser" }
    Merge-Pr $pr1.number
    Start-Sleep -Seconds 5
    $main = Invoke-RestMethod -Uri "$Api/branches/main"
    $mergeSha = $main.commit.id
    Say "main is now $($mergeSha.Substring(0,7)); Jenkins starts the delivery build"

    # ---- 3. wait for the result of the build on main (expected: failure)
    Say "waiting for Jenkins to report the build on main (up to 15 minutes; expected result: FAILURE at Deploy staging)"
    $r = Wait-Check $mergeSha 15
    if ($null -eq $r) { Say "no final state yet; check Jenkins; the script continues only if you press Enter"; Read-Host 'Press Enter to continue or Ctrl+C to stop' | Out-Null }
    else { Say "state of the build on main: $($r.state)  (failure is the expected, wanted result)" }
    if ($r -and $r.state -eq 'success') { Stop-Here "the build succeeded, so the drill did not fail; do not restore anything; tell the assistant" }

    # ---- 4. restore: the reviewed template is put back through its own pull request
    Git checkout main
    if ($script:GitCode -ne 0) { Stop-Here 'git checkout main failed' }
    Git pull origin main
    if ($script:GitCode -ne 0) { Stop-Here 'git pull failed' }
    $rb = "issue-$n-restore-staging-template"
    Git checkout -b $rb
    if ($script:GitCode -ne 0) { Stop-Here 'git checkout -b failed' }
    Git checkout $GoodSha -- ansible/templates/compose.yaml.j2
    if ($script:GitCode -ne 0) { Stop-Here 'restoring the template file failed' }
    Git commit -m "Restore the reviewed staging template after the failed-deployment drill (issue #$n)`n`nThe template of $GoodSha is put back; the drill commit stays in the history as the recorded failure.`n`nCo-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>"
    if ($script:GitCode -ne 0) { Stop-Here 'git commit failed' }
    Git push -u origin $rb
    if ($script:GitCode -ne 0) { Stop-Here 'git push of the restore branch failed' }
    $pr2 = Api 'POST' '/pulls' @{ title = "Restore the reviewed staging template (issue #$n)"; head = $rb; base = 'main';
        body = "Closes #$n. Restores the reviewed Compose template after the failed-deployment drill; the next delivery run must deploy staging again." }
    Say "pull request #$($pr2.number) opened"
    $c2 = Wait-Check $pr2.head.sha 8
    if ($null -eq $c2 -or $c2.state -ne 'success') { Stop-Here "the restore PR check did not turn green (state: $($c2.state)); do not leave staging broken: merge it by hand when green" }
    Merge-Pr $pr2.number
    Say "restore merged; Jenkins starts the next delivery build"
    Write-Host ""
    Write-Host "DONE with the Git side. What you do now: open https://ci.ssw590-g1.tech/job/twintrack/job/main/ ; the new build goes through staging and pauses at the approval prompt: click ABORT there (do not promote)." -ForegroundColor Green
    Write-Host "Then tell the assistant: it checks staging and collects the evidence." -ForegroundColor Green
}
finally {
    Remove-Item -Path $ask -Force -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_ASKPASS, Env:\GITEA_USER, Env:\GITEA_TOKEN, Env:\GIT_TERMINAL_PROMPT -ErrorAction SilentlyContinue
    $tok = $null; $H = $null
}
