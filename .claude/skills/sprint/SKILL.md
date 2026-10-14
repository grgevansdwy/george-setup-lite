---
name: sprint
description: Solve a problem in a strict time box (default 90 minutes). Orient fast, frame in one page, build a thin end-to-end slice first, deepen slice by slice, freeze scope, harden, wrap. Use when the user gives a repo or a problem and a short deadline.
disable-model-invocation: true
argument-hint: "[minutes] <repo URL, path, or problem statement>"
---

# /sprint — solve it inside the time box

Input: $ARGUMENTS. If it starts with a number, that is the budget in minutes. Otherwise the budget is **90**.

Speed over ceremony. No long interview, no security review, no parallel worktrees. Working software at the deadline beats a perfect plan.

## 0. Start the clock
- Run `date +%s > .sprint-start; echo <budget> > .sprint-budget`.
- Run `bash .claude/skills/hide-harness/hide.sh` so the harness files (`.claude/`, `SPRINT.md`, `KNOWLEDGE.md`) never get committed. It is local-only and silent.
- A hook prints elapsed/total time on every prompt. If it doesn't, run `date` yourself at each checkpoint below.
- Milestones for budget B: **thin slice running by 0.5·B**, **feature freeze at 0.78·B**, **wrap starts at 0.88·B**. For 90 min: 45 / 70 / 80.

## 1. Orient (first ~10%)
- If given a URL, clone it. Read the README, the task or issue text, and the manifests. Don't read the whole repo.
- Run the existing tests or the app **once** to get a baseline. Note what already fails, so you don't blame yourself later.
- If an area is unfamiliar and large, send up to 3 **explorer** subagents in parallel (one message), each with one specific question. Otherwise read it yourself.
- If there is no `CLAUDE.md`, write a 15-line one: stack, run command, test command, gotchas. Only real commands.

## 2. Frame (next ~10%)
- Ask questions only if something **blocks** the work, at most one round of 3 (AskUserQuestion, with a recommended default). Everything else becomes a stated assumption.
- **Design check:** if the problem involves an LLM, an agent, a pipeline or a non-obvious architecture, invoke the **architecture-reviewer** skill in *sprint mode* (about 2 minutes). For a plain bug or small feature, skip it.
- Write `SPRINT.md` at the repo root, about 20 lines:

```
# Sprint: <name>   (budget <B> min, started <HH:MM>)
Goal: <1-2 sentences>
Done when: <≤3 checkable items>
Never go wrong: <≤3 items, each gets a test>
Assumptions: <bullets>
Decisions: <one line each: choice — reason>
Slices (thin first):
1. <thin end-to-end slice, fakes for external services>   by min <0.5B>
2. <next>   by min <..>
Cut list (will NOT do): <bullets>
```

Show it in one short message and **keep going** unless the user objects. Don't wait for sign-off.
- Then invoke **knowledge** in `draft` mode. The user must understand this system well enough to explain it in a demo, so understanding is part of the job, not an extra.

## 3. Build
- **Slice 1 first**: the whole happy path end to end, with fakes for anything external. Run it. Commit. If it isn't running by 0.5·B, cut scope now, not later.
- Then deepen one slice at a time, in order. After each slice: run it, run the tests, `git commit` (never push), tick it in `SPRINT.md`, then invoke **knowledge** in `update` mode. It writes `KNOWLEDGE.md` and gives the user 3 plain bullets on what they should now understand.
- Tests: write one for each never-go-wrong item. Don't chase coverage elsewhere.
- Stuck for more than ~5 minutes on one failure: use `/investigate --quick`, or cut the slice. Don't sink the budget into one bug.
- Match the code around you. Reuse what exists. Don't refactor what isn't in the way.
- Parallel subagents only for independent read-only work (research, a second explorer). Never worktrees.

## 4. Freeze (at 0.78·B)
Stop adding scope. Move whatever isn't done to the cut list. Then run `/wrap`.

## Rules
- Explain as you go: when you make a decision, say the reason in plain words (it goes in `SPRINT.md` and `KNOWLEDGE.md`).
- Check the clock at every slice boundary and say the elapsed time in one line.
- Never block on the user. A wrong assumption that's written down is cheaper than a question.
- Never push, never touch anything outside the repo.
