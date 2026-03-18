---
name: fastgpt-dataset-manager
description: Use when managing FastGPT datasets and collections, including listing datasets, creating datasets, listing collections, and uploading local files into a dataset.
---

# FastGPT Dataset Manager

Use this skill for FastGPT knowledge base and file upload operations.

Set environment first:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export FASTGPT_HARNESS_DIR="/path/to/fastgpt/agent-harness"
export FASTGPT_FIREFOX_PROFILE="/path/to/playwright-or-firefox-profile"
export FGADMIN="$CODEX_HOME/skills/fastgpt-admin/scripts"
```

## Commands

List datasets:

```bash
"$FGADMIN/fgcli_json.sh" dataset list
```

Create dataset:

```bash
"$FGADMIN/fgcli_json.sh" \
  dataset create \
  --name 合同制度库
```

List collections:

```bash
"$FGADMIN/fgcli_json.sh" dataset list-collections DATASET_ID
```

Upload local file:

```bash
"$FGADMIN/fgcli_json.sh" \
  dataset upload-local-file \
  --dataset-id DATASET_ID \
  --file /path/to/file.pdf
```

## Guardrails

- Use dataset commands for repeatable admin actions.
- For bulk imports, batch carefully and verify one file first.
- If upload fails, report whether the failure is local file parsing, admin auth, or FastGPT remote response.
- Do not commit uploaded sample files, downloaded exports, or local profile paths into GitHub.
