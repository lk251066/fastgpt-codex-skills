#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[1/3] scan sensitive patterns"
if rg -n -P --hidden --glob '!**/.git/**' --glob '!.env.example' --glob '!**/scripts/prepublish_check.sh' \
  'fastgpt_token=|FASTGPT_COOKIE=(?!"?__SET_AT_RUNTIME__"?$).+|FASTGPT_ADMIN_BEARER_TOKEN=(?!"?__SET_AT_RUNTIME__"?$).+|FASTGPT_LOGIN_PASSWORD=(?!"?__SET_AT_RUNTIME__"?$).+|password=(?!"?__SET_AT_RUNTIME__"?$).+|passwd=(?!"?__SET_AT_RUNTIME__"?$).+|token=[A-Za-z0-9]{16,}' \
  "$ROOT_DIR"; then
  echo "Sensitive content detected." >&2
  exit 1
fi
echo "ok"

echo "[2/3] scan local machine paths"
if rg -n --hidden --glob '!**/.git/**' --glob '!**/scripts/prepublish_check.sh' \
  '/mnt/[d-z]/|/home/|C:\\\\Users\\\\|D:\\\\|Users\\\\[^\\]+' \
  "$ROOT_DIR"; then
  echo "Machine-specific path detected." >&2
  exit 1
fi
echo "ok"

echo "[3/3] shell syntax"
bash -n "$ROOT_DIR/install.sh"
bash -n "$ROOT_DIR/scripts/prepublish_check.sh"
bash -n "$ROOT_DIR/fastgpt-login/scripts/login_with_env.sh"
bash -n "$ROOT_DIR/fastgpt-admin/scripts/fgcli.sh"
bash -n "$ROOT_DIR/fastgpt-admin/scripts/fgadmin_http.sh"
echo "ok"
