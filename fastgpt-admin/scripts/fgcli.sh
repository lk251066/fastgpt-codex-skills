#!/usr/bin/env bash
set -euo pipefail

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

HARNESS_DIR="$(resolve_harness_dir)"
cd "$HARNESS_DIR"

if [[ $# -eq 0 ]]; then
  exec python3 -m cli_anything.fastgpt.fastgpt_cli
fi

exec python3 -m cli_anything.fastgpt.fastgpt_cli "$@"
