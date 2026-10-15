#!/usr/bin/env python3
"""Row 6 setup for the Group 1 Gitea (startup team workflow), split by person.

Run in your OWN terminal from the repository root:
    python assignment-4/gitea/row6-setup.py

It detects who you are (brahmi or sakshi) from the token and runs only your stages.
Every stage is safe to run twice (it skips what already exists).

  Sakshi (run FIRST):
    1. create the public repository group1-startup/twintrack with a README
    2. create the 6 issues from sd/backlog-draft.md (assigned as planned)
    3. branch issue-1-readme with the product README and open the pull request
       "Add product README" with "Closes #<issue 1>"  (Brahmi must review and approve it)
  Brahmi (run SECOND, as organization owner):
    1. (repository and issues are created if missing)
    2. protect `main`: no direct pushes (also for administrators), 1 approval required
    3. try a direct commit to `main`; report whether it was REFUSED (the proof for issue 4);
       if refused, comment on and close issue 4
    4. branch issue-2-contributing with CONTRIBUTING.md and open the pull request
       "Add CONTRIBUTING.md" with "Closes #<issue 2>"  (Sakshi must review and approve it)

Security: the access token is typed at a hidden prompt, kept only in memory, never written to
disk and never printed. Create it in Gitea > Settings > Applications with the scopes
read:user, write:organization, write:repository, write:issue, and DELETE it afterwards.
Everything this script prints is safe to paste into the chat.
Needs only Python 3.8+ (no extra packages).
"""
import base64
import getpass
import json
import os
import sys
import urllib.error
import urllib.request

BASE = "https://git.ssw590-g1.tech/api/v1"
ORG = "group1-startup"
REPO = "twintrack"
FULL = f"{ORG}/{REPO}"

CONTRIBUTING = """# Contributing to TwinTrack

1. Every change starts as an issue. Pick or create one before you start.
2. Branch from `main` as `issue-<number>-<short-name>`.
3. Open a pull request with `Closes #<number>` in the description.
4. The other team member reviews it, leaves at least one comment or question,
   and approves once it is addressed. You cannot approve your own pull request.
5. After approval, merge. The issue closes automatically.
6. `main` is protected: no direct pushes.
7. Never commit passwords, tokens, private keys or personal data.
"""

FALLBACK_README = """# TwinTrack

A small team task tracker that Group 1 (SSW 590) uses as its startup product.
The same application is delivered by two CI/CD pipelines (GitHub Actions and
Jenkins) so the tools can be compared on security, speed, and operations.

## Status
Planning. See the issues for the current backlog.

## How we work
1. Every change starts as an issue.
2. Branch from `main` as `issue-<number>-<short-name>`.
3. Open a pull request with `Closes #<number>` in the description.
4. The other team member reviews and approves; then merge.

## Team
- Brahmi Dalvi - infrastructure (Gitea, cloud, CI)
- Sakshi Deshpande - product (application, tests, documentation)
"""

ISSUES = [
    ("Write the product README", "sakshi",
     "README states purpose, status, workflow and team. Delivered by a pull request that closes this issue."),
    ("Add CONTRIBUTING.md for the issue, branch, PR, review flow", "brahmi",
     "CONTRIBUTING.md is merged via a pull request that is reviewed and approved by Sakshi."),
    ("Define the TwinTrack task data model", "sakshi",
     "`docs/data-model.md` lists the task fields, states and transitions."),
    ("Protect `main`: require PR + 1 approval", "brahmi",
     "A direct push to `main` is rejected. Evidence: the saved rule and the rejection."),
    ("Document the Gitea restart and troubleshooting runbook", "sakshi",
     "`docs/runbook.md` matches the runbook in the IT manual."),
    ("Add the domain expiry date (Oct 15, 2027) to the shared calendar and name its owner", "brahmi",
     "A calendar event exists with an owner and a reminder. We do not plan to renew the domain."),
]

TOKEN = ""


def api(method, path, data=None):
    """Return (status, parsed_json_or_text). Never raises on HTTP errors; never prints the token."""
    body = None if data is None else json.dumps(data).encode()
    req = urllib.request.Request(BASE + path, data=body, method=method)
    req.add_header("Authorization", "token " + TOKEN)
    req.add_header("Accept", "application/json")
    if body is not None:
        req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            raw = r.read().decode("utf-8", "replace")
            return r.status, (json.loads(raw) if raw.strip() else {})
    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8", "replace")
        try:
            return e.code, json.loads(raw)
        except ValueError:
            return e.code, raw[:300]


def say(msg):
    print(msg, flush=True)


def b64(text):
    return base64.b64encode(text.encode()).decode()


def readme_text():
    """Take the README block from sd/backlog-draft.md if it is there, else the built-in copy."""
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "..", "sd", "backlog-draft.md")
    try:
        with open(path, encoding="utf-8") as f:
            text = f.read()
        start = text.index("```markdown") + len("```markdown")
        end = text.index("```", start)
        block = text[start:end].strip("\n") + "\n"
        if block.startswith("# TwinTrack"):
            return block, "from sd/backlog-draft.md"
    except (OSError, ValueError):
        pass
    return FALLBACK_README, "built-in copy"


def stage_repo():
    st, repo = api("GET", f"/repos/{FULL}")
    if st == 200:
        say(f"[repo] exists already: {repo['html_url']}  (private={repo['private']})")
        return True
    st, repo = api("POST", f"/orgs/{ORG}/repos", {
        "name": REPO, "description": "TwinTrack: Group 1's startup product",
        "private": False, "auto_init": True, "default_branch": "main", "readme": "Default"})
    if st in (200, 201):
        say(f"[repo] created: {repo['html_url']}  (private={repo['private']})")
        return True
    say(f"[repo] create FAILED (HTTP {st}): {str(repo)[:250]}")
    if st in (403, 404):
        say("       You may not be allowed to create repositories in the organization.")
        say("       Ask the other person to run this script first (Brahmi is an owner).")
    return False


def stage_issues():
    st, existing = api("GET", f"/repos/{FULL}/issues?state=all&type=issues&limit=50")
    have = {i["title"]: i["number"] for i in existing} if st == 200 else {}
    numbers = {}
    for title, assignee, text in ISSUES:
        if title in have:
            numbers[title] = have[title]
            say(f"[issues] exists: #{have[title]} {title}")
            continue
        st, iss = api("POST", f"/repos/{FULL}/issues",
                      {"title": title, "body": text, "assignees": [assignee]})
        if st in (200, 201):
            numbers[title] = iss["number"]
            say(f"[issues] created: #{iss['number']} {title}  (assignee {assignee})")
        else:
            say(f"[issues] FAILED (HTTP {st}) for '{title}': {str(iss)[:200]}")
    return numbers


def open_pr(branch, title, closes_number):
    st, pr = api("POST", f"/repos/{FULL}/pulls", {
        "head": branch, "base": "main", "title": title,
        "body": f"{title}.\n\nCloses #{closes_number}"})
    if st in (200, 201):
        say(f"[pr] opened: {pr['html_url']}")
        return True
    if st == 409 or "already exists" in str(pr).lower():
        say("[pr] a pull request for this branch already exists")
        return True
    say(f"[pr] FAILED (HTTP {st}): {str(pr)[:250]}")
    return False


def stage_readme_pr(numbers):
    n = numbers.get(ISSUES[0][0])
    if not n:
        say("[readme-pr] issue 1 not found; stopping this stage")
        return
    st, _ = api("GET", f"/repos/{FULL}/branches/issue-1-readme")
    if st != 200:
        st, f = api("GET", f"/repos/{FULL}/contents/README.md?ref=main")
        if st != 200:
            say(f"[readme-pr] cannot read README.md on main (HTTP {st}); stopping this stage")
            return
        text, source = readme_text()
        st, res = api("PUT", f"/repos/{FULL}/contents/README.md", {
            "content": b64(text), "sha": f["sha"], "message": "Add product README",
            "branch": "main", "new_branch": "issue-1-readme"})
        if st not in (200, 201):
            say(f"[readme-pr] create branch/commit FAILED (HTTP {st}): {str(res)[:250]}")
            return
        say(f"[readme-pr] branch issue-1-readme created with the product README ({source})")
    else:
        say("[readme-pr] branch issue-1-readme exists already")
    if open_pr("issue-1-readme", "Add product README", n):
        say("    NEXT: Brahmi reviews it (at least one comment), Sakshi addresses it, Brahmi approves, then merge.")


def stage_protect(numbers):
    n4 = numbers.get(ISSUES[3][0])
    st, rules = api("GET", f"/repos/{FULL}/branch_protections")
    if st != 200:
        say(f"[protect] cannot read protection rules (HTTP {st}); you need to be an organization owner")
        return
    if any(r.get("rule_name") == "main" or r.get("branch_name") == "main" for r in rules):
        say("[protect] a protection rule for main already exists")
    else:
        st, rule = api("POST", f"/repos/{FULL}/branch_protections", {
            "rule_name": "main", "branch_name": "main",
            "enable_push": False, "enable_push_whitelist": False,
            "required_approvals": 1, "block_on_rejected_reviews": True,
            "dismiss_stale_approvals": True, "apply_to_admins": True})
        if st not in (200, 201):
            say(f"[protect] create FAILED (HTTP {st}): {str(rule)[:250]}")
            return
        say("[protect] rule created for main")
    st, rules = api("GET", f"/repos/{FULL}/branch_protections")
    for r in rules if st == 200 else []:
        say("    rule: name={0} enable_push={1} required_approvals={2} block_on_rejected_reviews={3} "
            "dismiss_stale_approvals={4} apply_to_admins={5}".format(
                r.get("rule_name"), r.get("enable_push"), r.get("required_approvals"),
                r.get("block_on_rejected_reviews"), r.get("dismiss_stale_approvals"),
                r.get("apply_to_admins")))
    st, res = api("POST", f"/repos/{FULL}/contents/protection-test.txt", {
        "content": b64("direct push test\n"),
        "message": "Direct commit to main (expected to be refused)", "branch": "main"})
    refused = st in (400, 403, 409, 422)
    say(f"[protect] direct commit to main: HTTP {st} -> "
        f"{'REFUSED (good)' if refused else 'NOT REFUSED (protection is NOT working)'}")
    say(f"    server said: {str(res)[:200]}")
    if not refused:
        say("    WARNING: a file 'protection-test.txt' may now exist on main. Do not close issue 4.")
        return
    if n4:
        api("POST", f"/repos/{FULL}/issues/{n4}/comments", {
            "body": "Branch protection on `main` is active (no direct pushes, 1 approval required). "
                    f"A direct commit to `main` was refused with HTTP {st}."})
        st2, _ = api("PATCH", f"/repos/{FULL}/issues/{n4}", {"state": "closed"})
        say(f"[protect] issue #{n4} commented and closed (HTTP {st2})")


def stage_contributing_pr(numbers):
    n = numbers.get(ISSUES[1][0])
    if not n:
        say("[contributing-pr] issue 2 not found; stopping this stage")
        return
    st, _ = api("GET", f"/repos/{FULL}/branches/issue-2-contributing")
    if st != 200:
        st, res = api("POST", f"/repos/{FULL}/contents/CONTRIBUTING.md", {
            "content": b64(CONTRIBUTING), "message": "Add CONTRIBUTING.md",
            "branch": "main", "new_branch": "issue-2-contributing"})
        if st not in (200, 201):
            say(f"[contributing-pr] create branch/file FAILED (HTTP {st}): {str(res)[:250]}")
            return
        say("[contributing-pr] branch issue-2-contributing created with CONTRIBUTING.md")
    else:
        say("[contributing-pr] branch issue-2-contributing exists already")
    if open_pr("issue-2-contributing", "Add CONTRIBUTING.md", n):
        say("    NEXT: Sakshi reviews it (at least one comment), Brahmi addresses it, Sakshi approves, then merge.")


def main():
    global TOKEN
    TOKEN = getpass.getpass("Gitea access token (hidden, not saved): ").strip()
    if not TOKEN:
        sys.exit("no token entered")
    st, me = api("GET", "/user")
    if st != 200:
        sys.exit(f"token rejected (HTTP {st}). Check the scopes and try again.")
    who = me.get("login")
    say(f"Signed in as: {who}  (site admin={me.get('is_admin')})")
    if who not in ("brahmi", "sakshi"):
        sys.exit("expected user 'brahmi' or 'sakshi'; stopping so nothing is created under another account")

    if not stage_repo():
        return
    numbers = stage_issues()
    if who == "sakshi":
        stage_readme_pr(numbers)
        say("\nYour stages are done. Brahmi runs her part next (protection and the CONTRIBUTING.md PR).")
    else:
        stage_protect(numbers)
        stage_contributing_pr(numbers)
        say("\nYour stages are done. Review Sakshi's README pull request and ask her to review yours.")
    say("\nNow DELETE the token in Gitea > Settings > Applications.")
    say(f"Repository: https://git.ssw590-g1.tech/{FULL}")


if __name__ == "__main__":
    main()
