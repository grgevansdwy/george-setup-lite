# george-setup: a Claude Code harness for 90-minute problems

A project-level `.claude/` setup you drop into any repo. It is built for one situation: **you're given a repo or a problem and a short deadline** (default 90 minutes). It favors speed: quick understanding, a thin working slice first, no long interviews, no security ceremony.

The old multi-hour version (interview, spec, plan, parallel worktrees, deep review) is tagged `long-session-v1`.

## Install
Needs `git`, `bash`, `jq`. Clone the project, clone this repo anywhere (inside the project is fine), then from the project root:
```bash
cd /path/to/project && bash george-setup-lite/install.sh
```
It copies `.claude/` to the project root (Claude Code only reads it there), merges any existing `settings.json`, and hides the harness from git locally. Restart Claude Code. Details: [INSTRUCTIONS.md](INSTRUCTIONS.md).

## The workflow

```
/sprint 90 <repo URL or problem>
  0-10   Orient   clone, read README/task, run tests once, explorers for big unfamiliar areas
  10-20  Frame    ≤1 round of blocking questions, design check (architecture-reviewer, only if the
                  problem has a design question), write SPRINT.md (goal, done-when, slices, cut list)
  20-45  Slice 1  thin end-to-end happy path with fakes. Run it. Commit.
  45-70  Slices   deepen one slice at a time. Run + commit each.
  70     FREEZE   no new scope
/wrap
  70-80  Harden   run tests + app, one MUST-FIX review pass, /cleanup
  80-90  Ship     KNOWLEDGE.md final + demo script, hide harness from git, README "Run it", works/cut/next in SPRINT.md, final commit (no push). 10 min buffer.
```

A hook prints `[sprint clock] 47/90 min elapsed` on every prompt, so the time box is enforced, not just intended.

## Commands

| Command | What it does |
|---|---|
| `/sprint [min] <problem>` | The whole time-boxed flow above, up to feature freeze. |
| `/wrap` | Harden and ship: tests, one review pass, cleanup, run instructions, final commit. |
| `/architecture-reviewer [design]` | The design brain. In sprint mode it's a ~2-minute check of code-vs-model, workflow-vs-agent, thin-slice-first and the top red flags. Full mode gives a scored review. |
| `/investigate <symptom> [--quick]` | Stuck on a bug: tests competing hypotheses in parallel. `--quick` = 2 hypotheses, one round. |
| `/explain <thing>` | How does X work, with `path:line` citations. |
| `/cleanup` | Strips debug prints, unused imports and dead code from your diff. |
| `/knowledge [draft\|update\|final]` | Writes `KNOWLEDGE.md` in the repo root: the architecture, every decision and why, one request end to end, and a demo script with likely questions, in plain language. `/sprint` updates it after each slice. |
| `/hide-harness` | Adds the harness to `.git/info/exclude` (local, never committed) so only real code is committed or pushed. `/sprint` runs it at the start, `/wrap` again at the end. |

Subagents: `explorer` (cheap, read-only code search), `debugger` (root cause with evidence), `code-reviewer` (fresh-eyes diff review, has a quick mode).

## Rules baked in
- Thin end-to-end slice first. If it doesn't run by 50% of the time, cut scope.
- Never block on the user: a written assumption is cheaper than a question.
- One commit per slice, never a push.
- Understanding is part of the job: after each slice you get 3 plain bullets on what you should now be able to explain, and `KNOWLEDGE.md` keeps the full story.
- The harness never reaches git: `SPRINT.md`, `KNOWLEDGE.md` and `.claude/` are excluded locally.
- Hooks: format-after-edit and the clock. Nothing else. Only `rm -rf /`-style commands and force push are denied.
