---
name: fastgpt-login
description: Use when you need to connect Codex to FastGPT management operations, check login state, reuse an existing browser profile, or prepare FastGPT admin authentication before app, workflow, or dataset operations.
---

# FastGPT Login

Use this skill when the task needs FastGPT admin authentication.

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

If that succeeds, prefer:

```bash
"$FGADMIN/fgcli.sh" config set-firefox-profile "$FASTGPT_FIREFOX_PROFILE"
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

## Guardrails

- Do not print full cookies or tokens back to the user.
- Do not write login credentials into `SKILL.md`, shell history examples, or repo docs.
- Keep credentials only in shell environment variables or local secret managers.
- Prefer `auth status` and masked previews.
- After login, immediately verify with one harmless admin check.
