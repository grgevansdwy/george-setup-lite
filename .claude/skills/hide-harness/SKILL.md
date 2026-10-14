---
name: hide-harness
description: Locally git-ignore the sprint harness (.claude/, SPRINT.md, KNOWLEDGE.md, clock files, the setup folder) via .git/info/exclude so only the real code is committed or pushed. Run at sprint start and again in /wrap. Use when the user says "hide the harness", "only commit the real code", or "ignore the setup".
disable-model-invocation: true
---

# /hide-harness — only the real code leaves this repo

Run the script. It is the whole skill:

```bash
bash .claude/skills/hide-harness/hide.sh
```

What it does:
- Adds rules to `.git/info/exclude`. That file is **local to this clone** and never committed, so the project's own `.gitignore` is untouched and nothing about the harness shows up in a diff or a PR.
- Hides: `.claude/`, `SPRINT.md`, `KNOWLEDGE.md`, `.sprint-start`, `.sprint-budget`, `CLAUDE.local.md`, the folder this setup was cloned into, and `CLAUDE.md` only if you created it (never the project's own tracked one).
- If the project already tracks its own `.claude/`, only our files are hidden.

Then read its last line:
- `clean` → done.
- `WARNING already tracked` → harness files were committed before the rules existed. Run `bash .claude/skills/hide-harness/hide.sh --untrack` (keeps the files on disk, removes them from the index), commit `chore: untrack tooling`, and tell the user those files still exist in earlier commits' history. Do **not** rewrite history unless the user asks.

Finish with `git status --short`: it should list only real project files. KNOWLEDGE.md and SPRINT.md are hidden on purpose, so remind the user they are still on disk for the demo.
