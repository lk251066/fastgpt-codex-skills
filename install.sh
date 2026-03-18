#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="$CODEX_HOME/skills"

mkdir -p "$TARGET_DIR"

for skill in \
  fastgpt-login \
  fastgpt-admin \
  fastgpt-api-key-manager \
  fastgpt-dataset-manager
do
  rm -rf "$TARGET_DIR/$skill"
  cp -R "$ROOT_DIR/$skill" "$TARGET_DIR/$skill"
done

echo "Installed FastGPT skills to $TARGET_DIR"
