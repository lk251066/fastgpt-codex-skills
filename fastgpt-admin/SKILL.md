---
name: fastgpt-admin
description: Use when managing FastGPT apps and workflows from Codex, including listing apps, creating apps from workflow JSON, exporting workflow JSON, viewing permissions, and running the FastGPT admin CLI in REPL or one-shot mode.
---

# FastGPT Admin

Use this skill for FastGPT app and workflow management.

Set the environment once:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export FASTGPT_HARNESS_DIR="/path/to/fastgpt/agent-harness"
export FASTGPT_BASE_URL="https://cloud.fastgpt.cn/api"
export FASTGPT_FIREFOX_PROFILE="/path/to/playwright-or-firefox-profile"
export FGADMIN="$CODEX_HOME/skills/fastgpt-admin/scripts"
```

## Standard startup

Prefer JSON output:

```bash
"$FGADMIN/fgcli.sh" --help
```

## Common commands

List workflow apps:

```bash
"$FGADMIN/fgcli_json.sh" app list --type workflow
```

Create app from workflow JSON:

```bash
"$FGADMIN/fgcli_json.sh" \
  app create-from-workflow-json \
  --workflow /path/to/workflow.json \
  --name 新工作流 \
  --type workflow
```

Export workflow JSON:

```bash
"$FGADMIN/fgcli_json.sh" \
  app export-workflow-json APP_ID \
  --output /tmp/exported_workflow.json
```

If Linux-side HTTPS to the FastGPT admin API is unstable, use the PowerShell network fallback:

```bash
cat >/tmp/app_list.json <<'JSON'
{"type":["advanced"],"searchKey":"","parentId":null}
JSON
"$FGADMIN/fgadmin_http.sh" POST /core/app/list /tmp/app_list.json
```

To validate the current end-to-end chain quickly:

```bash
"$FGADMIN/validate_fastgpt_chain.sh"
```

## When page automation is needed

If CLI cannot cover the action, switch to browser automation only for:

- login
- page-only editing
- manual inspection of workflow nodes

Prefer CLI for repeatable creation/export flows.

## GitHub hygiene

- Keep the skill repo free of real usernames, passwords, cookies, and machine-specific absolute paths.
- Use `FASTGPT_HARNESS_DIR`, `FASTGPT_FIREFOX_PROFILE`, `FASTGPT_BASE_URL`, and local config for runtime binding.
