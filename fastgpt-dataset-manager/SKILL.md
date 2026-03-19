---
name: fastgpt-dataset-manager
description: Use when managing FastGPT datasets and collections, including listing datasets, creating datasets, listing collections, and uploading local files into a dataset.
---

# FastGPT Dataset Manager

Use this skill for FastGPT knowledge base and file upload operations.

## Recommended order

Use this skill after `fastgpt-login` has confirmed admin auth.

Typical flow:

1. List datasets
2. Create the target dataset if it does not exist
3. Upload one representative local file first
4. Verify collections or parsed objects before bulk upload
5. Only then continue with batch import

For contract projects, distinguish clearly between:

- dataset knowledge sources such as制度库、标准条款库、样本库
- runtime file upload used by multimodal contract review

Do not confuse dataset upload with runtime contract file upload. They solve different problems.

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

## Operational guidance

- Prefer uploading one small validation file before any large batch.
- If parsing results matter, check collections immediately after upload.
- For multimodal contract systems, datasets are usually for rules, clause libraries, and policy references, not for the per-review contract itself.

Suggested reporting fields:

- dataset id
- dataset name
- uploaded file name
- created collection id or count change
- whether this dataset is meant for rules, templates, or reference materials

## Guardrails

- Use dataset commands for repeatable admin actions.
- For bulk imports, batch carefully and verify one file first.
- If upload fails, report whether the failure is local file parsing, admin auth, or FastGPT remote response.
- Do not commit uploaded sample files, downloaded exports, or local profile paths into GitHub.
