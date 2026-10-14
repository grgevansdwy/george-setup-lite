# INSTRUCTIONS: installing the sprint harness (for the agent doing the install)

Target = the project root (current directory unless told otherwise). Source = this repo. Never write to `~/.claude`. Never overwrite without asking.

1. **Preflight.** Confirm the target is a project root and not this repo. Check `jq` exists (`format.sh` and `clock.sh` still run without it, they just skip work).
2. **Fast path:** from the target root, `bash <SRC>/install.sh` does steps 2-4 and 6 (copy, settings merge, hide from git). Use the manual steps below only if it fails.
2. **Copy.** Copy `SRC/.claude/agents`, `SRC/.claude/skills`, `SRC/.claude/hooks` into `TGT/.claude/`. If a file exists and differs, show a short diff and ask: keep theirs or replace. Then `chmod +x TGT/.claude/hooks/*.sh`.
3. **Settings.** If `TGT/.claude/settings.json` doesn't exist, copy ours. Otherwise merge: append our `permissions.allow` / `permissions.deny` entries that are missing, and append our hook groups (`PostToolUse` format, `UserPromptSubmit` clock) unless an identical one exists. If they already run a formatter on Edit/Write, ask before adding ours. Leave `settings.local.json` alone.
4. **Hide from git.** Run `bash TGT/.claude/skills/hide-harness/hide.sh`. It writes to `.git/info/exclude` (local only), so the project's own `.gitignore` stays untouched.
5. **CLAUDE.md.** Don't write one now. `/sprint` writes a 15-line one during Orient if the repo has none. If the user wants it up front, use `templates/CLAUDE.md.template` and keep it short with real commands only.
6. **Check.** `jq . TGT/.claude/settings.json`, and `echo '{}' | bash TGT/.claude/hooks/clock.sh` should print nothing (no sprint running).
7. **Report.** What was installed, merged, skipped. Tell the user to restart Claude Code (or run `/hooks`), then use `/sprint 90 <problem>`.
