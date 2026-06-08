# Sync Translations

Detect new or missing translations in the AL project and fill them in across all language files.

## What to do

1. **Find the base file**: locate `*.g.xlf` (no language suffix) in the workspace.

2. **Identify new entries** using git:
   ```bash
   git diff HEAD -- <base-xlf-path>
   git diff --cached -- <base-xlf-path>
   ```
   Extract `trans-unit id` values from `+` lines. If no diff, fall back to scanning all
   language files for `<target state="needs-translation">` with empty content.

3. **Spawn the Translator subagent** (`.claude/agents/translator.md`) to:
   - Translate each identified entry into all language files found in the project
   - Write the translations into the respective language files
   - Verify the XML remains valid

4. **Show a summary** of what was changed in each file.

## Usage examples

- `/sync-translations` — syncs all language files based on git changes + needs-translation entries
- `/sync-translations nl-BE` — only sync the Belgian Dutch file
- `/sync-translations fr-BE` — only sync the French file

If a target language is specified in the argument, only process that language file.
