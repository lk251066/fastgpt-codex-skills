---
name: fastgpt-admin
description: Use when managing FastGPT apps and workflows from Codex, including listing apps, creating apps from workflow JSON, exporting workflow JSON, viewing permissions, and running the FastGPT admin CLI in REPL or one-shot mode.
---

# FastGPT Admin

Use this skill for FastGPT app and workflow management.

## Recommended order

Use this skill after `fastgpt-login` has confirmed admin auth.

Typical flow:

1. `auth status`
2. `app list --type workflow`
3. Export the current workflow before changing anything
4. If the repo has local workflow JSON, regenerate it first
5. Publish or create the workflow
6. Read back the remote app detail and verify the key fields actually synced

For repeatable repo work, prefer project-local publish scripts when they exist.
In practice, local workflow JSON plus a repo publish script is safer than hand-editing pages.

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

## Workflow publishing guidance

Important: workflow editor persistence is not the same as generic app detail update.

- Do not assume `/core/app/update` will persist workflow-editor graph changes.
- For workflow JSON publishing, prefer the formal publish flow used by the editor, typically `/core/app/version/publish`.
- After publish, always read the remote app detail back and verify that the target prompt or node content actually changed.

If the current repo contains a dedicated workflow publisher such as `fastgpt/scripts/publish_workflows.py`, prefer that over ad hoc HTTP calls.

Recommended publish discipline:

1. Export or back up the current remote app
2. Publish local workflow JSON
3. Read back remote detail
4. Compare critical fields such as `systemPrompt`
5. Only then report success

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
- confirming a page-only behavior that the admin API cannot express clearly

Prefer CLI for repeatable creation/export flows.

## What this skill should report

- Which app or workflow was touched
- Whether the action was read-only or mutating
- For publish operations: whether remote verification passed
- Any backup/export file created during the operation

## GitHub hygiene

- Keep the skill repo free of real usernames, passwords, cookies, and machine-specific absolute paths.
- Use `FASTGPT_HARNESS_DIR`, `FASTGPT_FIREFOX_PROFILE`, `FASTGPT_BASE_URL`, and local config for runtime binding.
