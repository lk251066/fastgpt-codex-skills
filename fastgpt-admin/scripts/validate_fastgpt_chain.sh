#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/3] auth status"
"$SCRIPT_DIR/fgcli_json.sh" auth status

echo "[2/3] cli help"
"$SCRIPT_DIR/fgcli.sh" --help >/dev/null
echo "ok"

echo "[3/3] admin api app list via powershell network path"
TMP_JSON="$(mktemp)"
trap 'rm -f "$TMP_JSON"' EXIT
cat > "$TMP_JSON" <<'JSON'
{"type":["advanced"],"searchKey":"","parentId":null}
JSON
"$SCRIPT_DIR/fgadmin_http.sh" POST /core/app/list "$TMP_JSON"
