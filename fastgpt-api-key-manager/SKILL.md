---
name: fastgpt-api-key-manager
description: Use when creating, updating, deleting, listing, or exporting FastGPT app API keys and when preparing app access information for backend integration.
---

# FastGPT API Key Manager

Use this skill for FastGPT app key operations.

Set environment first:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export FASTGPT_HARNESS_DIR="/path/to/fastgpt/agent-harness"
export FASTGPT_FIREFOX_PROFILE="/path/to/playwright-or-firefox-profile"
export FGADMIN="$CODEX_HOME/skills/fastgpt-admin/scripts"
```

## Commands

List keys:

```bash
"$FGADMIN/fgcli_json.sh" app list-api-keys APP_ID
```

Create key:

```bash
"$FGADMIN/fgcli_json.sh" \
  app create-api-key \
  --app-id APP_ID \
  --name KEY_NAME
```

Update key:

```bash
"$FGADMIN/fgcli_json.sh" \
  app update-api-key \
  --key-id KEY_ID \
  --app-id APP_ID \
  --name KEY_NAME
```

Delete key:

```bash
"$FGADMIN/fgcli_json.sh" \
  app delete-api-key \
  --key-id KEY_ID \
  --app-id APP_ID
```

## Output rule

When reporting results, show:

- appId
- key id
- key alias
- masked key preview

Never echo the full key unless the user explicitly asks for it.
Never commit generated keys or access snapshots into GitHub.
