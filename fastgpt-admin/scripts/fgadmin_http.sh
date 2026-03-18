#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 METHOD PATH [BODY_JSON_FILE]" >&2
  exit 2
fi

METHOD="$1"
PATH_PART="$2"
BODY_FILE="${3:-}"

BASE_URL="${FASTGPT_BASE_URL:-https://cloud.fastgpt.cn/api}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PS_SCRIPT_PATH="$(wslpath -w "$SCRIPT_DIR/invoke_fastgpt_admin.ps1")"
PS_BODY_FILE=""

resolve_powershell_exe() {
  if [[ -n "${POWERSHELL_EXE:-}" ]]; then
    printf '%s\n' "$POWERSHELL_EXE"
    return 0
  fi

  local candidates=(
    "/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe"
    "/mnt/c/Program Files/PowerShell/7/pwsh.exe"
  )

  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  if command -v powershell.exe >/dev/null 2>&1; then
    command -v powershell.exe
    return 0
  fi

  if command -v pwsh.exe >/dev/null 2>&1; then
    command -v pwsh.exe
    return 0
  fi

  cat >&2 <<'EOF'
Error: Windows PowerShell executable not found.
Set POWERSHELL_EXE to powershell.exe or pwsh.exe when using the PowerShell network fallback.
EOF
  exit 1
}

resolve_harness_dir() {
  if [[ -n "${FASTGPT_HARNESS_DIR:-}" ]]; then
    printf '%s\n' "$FASTGPT_HARNESS_DIR"
    return 0
  fi

  if [[ -f "$PWD/cli_anything/fastgpt/fastgpt_cli.py" ]]; then
    printf '%s\n' "$PWD"
    return 0
  fi

  if [[ -f "$PWD/agent-harness/cli_anything/fastgpt/fastgpt_cli.py" ]]; then
    printf '%s\n' "$PWD/agent-harness"
    return 0
  fi

  cat >&2 <<'EOF'
Error: FASTGPT_HARNESS_DIR is not set and no local harness was found.
Set FASTGPT_HARNESS_DIR to the FastGPT agent-harness directory, or run this script from the harness directory.
EOF
  exit 1
}

if [[ -n "$BODY_FILE" ]]; then
  PS_BODY_FILE="$(wslpath -w "$BODY_FILE")"
fi

HARNESS_DIR="$(resolve_harness_dir)"
AUTH_JSON="$(
  cd "$HARNESS_DIR"
  python3 - <<'PY'
import json
from cli_anything.fastgpt.utils.fastgpt_backend import resolve_admin_auth
print(json.dumps(resolve_admin_auth(), ensure_ascii=False))
PY
)"

AUTH_MODE="$(
  AUTH_JSON="$AUTH_JSON" python3 - <<'PY'
import os
import json
print(json.loads(os.environ["AUTH_JSON"])["mode"])
PY
)"

if [[ "$PATH_PART" == /* ]]; then
  URL="${BASE_URL}${PATH_PART}"
else
  URL="${BASE_URL}/${PATH_PART}"
fi

if [[ "$AUTH_MODE" == "cookie" ]]; then
  POWERSHELL_BIN="$(resolve_powershell_exe)"
  AUTH_VALUE="$(
    AUTH_JSON="$AUTH_JSON" python3 - <<'PY'
import os
import json
print(json.loads(os.environ["AUTH_JSON"])["value"])
PY
  )"
  exec "$POWERSHELL_BIN" \
    -ExecutionPolicy Bypass \
    -File "$PS_SCRIPT_PATH" \
    -Method "$METHOD" \
    -Url "$URL" \
    -Cookie "$AUTH_VALUE" \
    -BodyFile "$PS_BODY_FILE"
fi

if [[ "$AUTH_MODE" == "bearer" ]]; then
  POWERSHELL_BIN="$(resolve_powershell_exe)"
  AUTH_VALUE="$(
    AUTH_JSON="$AUTH_JSON" python3 - <<'PY'
import os
import json
print(json.loads(os.environ["AUTH_JSON"])["value"])
PY
  )"
  exec "$POWERSHELL_BIN" \
    -ExecutionPolicy Bypass \
    -File "$PS_SCRIPT_PATH" \
    -Method "$METHOD" \
    -Url "$URL" \
    -Authorization "$AUTH_VALUE" \
    -BodyFile "$PS_BODY_FILE"
fi

echo "Error: unsupported admin auth mode: $AUTH_MODE" >&2
exit 1
  -ExecutionPolicy Bypass \
  -File "$PS_SCRIPT_PATH" \
  -Method "$METHOD" \
  -Url "$URL" \
  -Cookie "$COOKIE" \
  -BodyFile "$PS_BODY_FILE"
