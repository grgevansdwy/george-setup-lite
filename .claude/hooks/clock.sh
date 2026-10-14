#!/usr/bin/env bash
# UserPromptSubmit: tell Claude how much of the sprint budget is gone.
# Does nothing unless /sprint created .sprint-start in the project. Never blocks.

dir=${CLAUDE_PROJECT_DIR:-$PWD}
[ -f "$dir/.sprint-start" ] || exit 0

start=$(cat "$dir/.sprint-start" 2>/dev/null)
budget=$(cat "$dir/.sprint-budget" 2>/dev/null || echo 90)
case "$start$budget" in *[!0-9]*|"") exit 0 ;; esac

now=$(date +%s)
elapsed=$(( (now - start) / 60 ))
left=$(( budget - elapsed ))

phase="build"
[ $((elapsed * 100)) -ge $((budget * 50)) ] && phase="build (thin slice should already run)"
[ $((elapsed * 100)) -ge $((budget * 78)) ] && phase="FREEZE: no new scope, run /wrap"
[ $left -le 5 ] && phase="LAST MINUTES: commit what works now"

echo "[sprint clock] ${elapsed}/${budget} min elapsed, ${left} left. Phase: ${phase}"
exit 0
