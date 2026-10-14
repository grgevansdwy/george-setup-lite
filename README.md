# george-setup-lite: a Claude Code harness for 90-minute problems

Given a repo and a short deadline: understand it fast, build a thin working slice first, and finish with something you can explain in a demo. No long interviews, no security ceremony.

## How to use it

```bash
# 1. Clone the repo you need to work on, and go into it
git clone <the-project> && cd <the-project>

# 2. Clone this setup inside it
git clone https://github.com/grgevansdwy/george-setup-lite.git
```

**3. Start Claude Code in the project and say:**
> Run `bash george-setup-lite/install.sh`

(or run it yourself). It copies the harness to the project root, merges any existing settings, and hides the harness from git. **Then restart Claude Code.**

**4. Start the sprint:**
```
/sprint 90 <what you need to solve>
```
Claude reads the README and task, runs the tests once, asks only questions that block the work, and writes `SPRINT.md` (goal, done-when, slices, cut list). It starts a first draft of `KNOWLEDGE.md`.

**5. Build piece by piece.** Claude builds a thin end-to-end slice first, then deepens it. After each slice it commits, updates `KNOWLEDGE.md`, and tells you in 3 plain bullets what you should now be able to explain. A clock on every prompt shows `47/90 min`.

**6. At minute ~70 the clock says FREEZE (no new scope). Run:**
```
/wrap
```
It runs the tests, does one review pass, tidies the diff, writes the final `KNOWLEDGE.md` with a demo script, hides the harness from git, and makes the final commit. It never pushes.

## What you get
- **Only real code in git.** `.claude/`, `SPRINT.md`, `KNOWLEDGE.md` and this setup's folder are excluded locally (`.git/info/exclude`), so commits and PRs contain just the project.
- **`KNOWLEDGE.md`** (stays on disk, not committed): the architecture, every decision and why, one request traced end to end, what was cut, and likely demo questions. Written in plain language.

## Timeline (for 90 minutes)

| Min | Phase |
|---|---|
| 0–10 | Orient: read the task, run the tests once |
| 10–20 | Frame: design check if there's a design question, write `SPRINT.md` |
| 20–45 | Slice 1: thin end-to-end happy path, running |
| 45–70 | Deepen slice by slice, commit each |
| 70 | Freeze |
| 70–90 | `/wrap`: harden, `KNOWLEDGE.md` final, hide harness, commit |

## Other commands
| Command | Use |
|---|---|
| `/architecture-reviewer` | The design check (runs inside `/sprint` when there's a design question). Also usable on its own. |
| `/investigate <bug> [--quick]` | Stuck on a bug: tests competing hypotheses. |
| `/explain <thing>` | How does X work, with `path:line` citations. |
| `/knowledge` | Refresh `KNOWLEDGE.md` any time. |
| `/cleanup` | Strip debug prints and unused imports from your diff. |

Needs `git`, `bash`, `jq`. The previous multi-hour version is tagged `long-session-v1`. Install details for agents: [INSTRUCTIONS.md](INSTRUCTIONS.md).
