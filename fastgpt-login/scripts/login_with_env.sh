#!/usr/bin/env bash
set -euo pipefail

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required." >&2
  exit 1
fi

: "${FASTGPT_LOGIN_USERNAME:?FASTGPT_LOGIN_USERNAME is required}"
: "${FASTGPT_LOGIN_PASSWORD:?FASTGPT_LOGIN_PASSWORD is required}"

FASTGPT_LOGIN_URL="${FASTGPT_LOGIN_URL:-https://cloud.fastgpt.cn/login}"
FASTGPT_FIREFOX_PROFILE="${FASTGPT_FIREFOX_PROFILE:-}"
PLAYWRIGHT_CLI_SESSION="${PLAYWRIGHT_CLI_SESSION:-fastgpt-login}"

cmd=(npx --yes --package @playwright/mcp playwright-cli --session "$PLAYWRIGHT_CLI_SESSION")
open_args=(open "$FASTGPT_LOGIN_URL" --browser firefox --headed --persistent)
if [[ -n "$FASTGPT_FIREFOX_PROFILE" ]]; then
  open_args+=(--profile "$FASTGPT_FIREFOX_PROFILE")
fi

"${cmd[@]}" "${open_args[@]}" >/dev/null
"${cmd[@]}" snapshot >/dev/null
"${cmd[@]}" eval "async () => { const agree = Array.from(document.querySelectorAll('button')).find(el => /agree/i.test(el.textContent || '')); if (agree) agree.click(); return true; }" >/dev/null || true
"${cmd[@]}" eval "async () => { const fields = Array.from(document.querySelectorAll('input')); if (fields[0]) fields[0].value = ''; if (fields[1]) fields[1].value = ''; return fields.length; }" >/dev/null
"${cmd[@]}" eval "() => { const fields = Array.from(document.querySelectorAll('input')); if (!fields[0]) throw new Error('Username field not found'); fields[0].focus(); }" >/dev/null
"${cmd[@]}" type "$FASTGPT_LOGIN_USERNAME" >/dev/null
"${cmd[@]}" eval "() => { const fields = Array.from(document.querySelectorAll('input')); if (!fields[1]) throw new Error('Password field not found'); fields[1].focus(); }" >/dev/null
"${cmd[@]}" type "$FASTGPT_LOGIN_PASSWORD" >/dev/null
"${cmd[@]}" eval "() => { const loginBtn = Array.from(document.querySelectorAll('button')).find(el => /^login$/i.test((el.textContent || '').trim())); if (!loginBtn) throw new Error('Login button not found'); loginBtn.click(); return true; }" >/dev/null

echo "FastGPT login submitted."
if [[ -n "$FASTGPT_FIREFOX_PROFILE" ]]; then
  echo "Profile: $FASTGPT_FIREFOX_PROFILE"
fi
echo "Session: $PLAYWRIGHT_CLI_SESSION"
