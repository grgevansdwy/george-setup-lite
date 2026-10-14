#!/usr/bin/env bash
# Hide the sprint harness from git, locally, so only the real code gets committed.
# Uses .git/info/exclude (per-clone, never committed, no tracked file changes).
#
#   hide.sh            add exclude rules, report anything of ours that is already tracked
#   hide.sh --untrack  also `git rm --cached` tracked harness files (keeps them on disk)
#
# Safe to run repeatedly. If the project already tracks its own .claude/ or CLAUDE.md,
# those are left alone: only our own files are excluded.

untrack=0; [ "$1" = "--untrack" ] && untrack=1

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "hide.sh: not a git repo" >&2; exit 1; }
cd "$root" || exit 1
ex=$(git rev-parse --git-path info/exclude)
mkdir -p "$(dirname "$ex")"; touch "$ex"

# This setup's own folder name, if it was cloned inside the project.
self=$(basename "$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." 2>/dev/null && pwd)")
[ "$self" = "$(basename "$root")" ] && self=""

paths=("SPRINT.md" "KNOWLEDGE.md" ".sprint-start" ".sprint-budget" "CLAUDE.local.md")
[ -n "$self" ] && [ -d "$self" ] && paths+=("$self/")

# .claude/: hide it all if the project doesn't track anything there, else only our files.
if [ -z "$(git ls-files .claude 2>/dev/null | head -1)" ]; then
  paths+=(".claude/")
else
  echo "hide.sh: project tracks its own .claude/, hiding only harness files"
  for d in sprint wrap knowledge hide-harness architecture-reviewer investigate explain cleanup; do paths+=(".claude/skills/$d/"); done
  for a in explorer debugger code-reviewer; do paths+=(".claude/agents/$a.md"); done
  for h in format clock; do paths+=(".claude/hooks/$h.sh"); done
fi

# CLAUDE.md only if we created it (untracked). A tracked CLAUDE.md is the project's own.
if [ -f CLAUDE.md ] && ! git ls-files --error-unmatch CLAUDE.md >/dev/null 2>&1; then paths+=("CLAUDE.md"); fi

added=0
if ! grep -q '^# george-setup harness' "$ex"; then printf '\n# george-setup harness (local only)\n' >> "$ex"; fi
for p in "${paths[@]}"; do
  grep -qxF "$p" "$ex" || { echo "$p" >> "$ex"; added=$((added+1)); }
done
echo "hide.sh: $added rule(s) added to $ex"

# Anything of ours already tracked? (committed before the rules existed)
leaked=()
for p in "${paths[@]}"; do
  [ -n "$(git ls-files -- "$p" 2>/dev/null | head -1)" ] && leaked+=("$p")
done
if [ ${#leaked[@]} -eq 0 ]; then
  echo "hide.sh: clean. No harness file is tracked."
elif [ $untrack = 1 ]; then
  for p in "${leaked[@]}"; do git rm -r --cached -q -- "$p" && echo "untracked: $p"; done
  echo "hide.sh: untracked ${#leaked[@]} path(s). Commit that, e.g. 'chore: untrack tooling'. Earlier commits still contain them in history."
else
  echo "hide.sh: WARNING already tracked: ${leaked[*]}"
  echo "         run: bash .claude/skills/hide-harness/hide.sh --untrack"
fi
exit 0
