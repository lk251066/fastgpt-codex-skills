---
name: fastgpt-api-key-manager
description: Use when creating, updating, deleting, listing, or exporting FastGPT app API keys and when preparing app access information for backend integration.
---

# FastGPT API Key Manager

Use this skill for FastGPT app key operations.

## Recommended order

Use this skill after:

1. `fastgpt-login` has confirmed admin auth
2. `fastgpt-admin` has identified the target app

Typical flow:

1. List existing keys for the app
2. Decide whether to reuse, rotate, or create a new key
3. Create or update the key
4. Return only masked output
5. If the key is meant for backend integration, update the local env mapping deliberately instead of scattering it into docs or chat

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

## Integration discipline

- Prefer one key per app and usage context when possible.
- If the key is created for a backend service, record the target env var name together with the app id.
- Do not claim “integration complete” unless the key has both been created and mapped to the intended backend config location.

Suggested reporting fields:

- appId
- app name if known
- key id
- key alias
- masked key preview
- intended backend env var name, if applicable

## Output rule

When reporting results, show:

- appId
- key id
- key alias
- masked key preview

Never echo the full key unless the user explicitly asks for it.
Never commit generated keys or access snapshots into GitHub.
