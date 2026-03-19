---
name: fastgpt-login
description: Use when you need to connect Codex to FastGPT management operations, check login state, reuse an existing browser profile, or prepare FastGPT admin authentication before app, workflow, or dataset operations.
---

# FastGPT Login

Use this skill when the task needs FastGPT admin authentication.

## Recommended order

Use this skill first in any FastGPT admin workflow.

1. Check whether an existing Firefox/Playwright profile already works
2. Bind that profile to the CLI wrappers
3. Verify with a harmless admin read call
4. Only if that fails, fall back to page login

This skill should hand off to:

- `fastgpt-admin` for app and workflow operations
- `fastgpt-api-key-manager` for app key operations
- `fastgpt-dataset-manager` for dataset operations

## Environment

Prefer reusing an existing Firefox/Playwright profile before attempting page login.

Set these variables in the shell instead of hardcoding them in the skill:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export FASTGPT_HARNESS_DIR="/path/to/fastgpt/agent-harness"
export FASTGPT_FIREFOX_PROFILE="/path/to/playwright-or-firefox-profile"
export FASTGPT_LOGIN_URL="https://cloud.fastgpt.cn/login"
export FASTGPT_LOGIN_USERNAME="__SET_AT_RUNTIME__"
export FASTGPT_LOGIN_PASSWORD="__SET_AT_RUNTIME__"
```

Preferred wrappers:

```bash
export FGADMIN="$CODEX_HOME/skills/fastgpt-admin/scripts"
export FGLOGIN="$CODEX_HOME/skills/fastgpt-login/scripts"
```

## Fast checks

```bash
"$FGADMIN/fgcli_json.sh" auth status
```

If that succeeds, immediately bind the known-good profile:

```bash
"$FGADMIN/fgcli.sh" config set-firefox-profile "$FASTGPT_FIREFOX_PROFILE"
```

Then verify with one harmless read:

```bash
"$FGADMIN/fgcli_json.sh" app list --type workflow
```

## If profile is unavailable

Use browser automation to log into `https://cloud.fastgpt.cn`, then persist or reuse the browser profile.

Use the bundled login helper so the account and password stay in environment variables instead of being written into the repo:

```bash
"$FGLOGIN/login_with_env.sh"
```

Priority:

1. Reuse existing profile
2. Reuse explicit cookie
3. Reuse bearer token
4. Browser login

## What to report back

- Whether admin auth is already valid
- Which auth path was used: profile / cookie / bearer / browser login
- Whether the CLI wrappers are now ready for follow-up skills

Do not print raw cookies, bearer tokens, or passwords.

## Guardrails

- Do not print full cookies or tokens back to the user.
- Do not write login credentials into `SKILL.md`, shell history examples, or repo docs.
- Keep credentials only in shell environment variables or local secret managers.
- Prefer `auth status` and masked previews.
- After login, immediately verify with one harmless admin check.
