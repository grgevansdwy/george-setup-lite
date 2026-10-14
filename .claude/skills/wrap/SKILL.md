---
name: wrap
description: Finish a time-boxed sprint. Run the tests and the app, do one quick review pass, tidy the diff, write run instructions and the works/cut/next summary, and make the final commit. Use after feature freeze, or when time is almost up.
disable-model-invocation: true
argument-hint: "[optional commit message hint]"
---

# /wrap — harden and ship (last ~15% of the budget)

Hint from the user (may be empty): $ARGUMENTS

Check the clock first (`.sprint-start`, `.sprint-budget`, or `date`). If under 5 minutes remain, skip steps 2 and 3.

## 1. Prove it works
- Run the project's tests and run the app or script once, end to end, the way the "Done when" items in `SPRINT.md` describe.
- Fix what's broken, smallest change first. If something can't be fixed in time, put it on the cut list honestly. Never mark a test skipped just to get green.

## 2. One review pass
- Run one **code-reviewer** subagent on the diff (`git diff <start-commit>..HEAD`), with: "Correctness only. MUST FIX only. No style, no security hardening."
- Fix the MUST FIX items that are quick. List the rest under "next".

## 3. Tidy
- Run `/cleanup` on the diff (debug prints, unused imports, dead code). Nothing else.

## 4. Write it down
- Invoke **knowledge** in `final` mode: `KNOWLEDGE.md` made true to the final code, with the two-minute demo script and likely questions.
- README: add or fix a short **Run it** section (install, run, test) that you actually executed.
- `SPRINT.md`: append

```
## Result
Works: <bullets, only what you ran>
Cut / not done: <bullets>
Next: <the 3 most valuable follow-ups>
Time: <elapsed> of <budget> min
```

## 5. Hide the harness, then commit
- Run `bash .claude/skills/hide-harness/hide.sh`. If it warns that harness files are tracked, run it with `--untrack` and commit that first (`chore: untrack tooling`).
- `git status --short` must show only real project files.
- `git add -A` (skip `.env*`, keys), one Conventional Commit, **no push**, no `--no-verify`.
- Report in this shape and stop:

```
Done in <elapsed>/<budget> min. Commit <hash>.
Works: ... | Cut: ... | Tests: <command> → <result>
Harness hidden: <yes/no>. Demo notes: KNOWLEDGE.md (on disk, not committed).
```
