#!/usr/bin/env bash
# Install the sprint harness into the project you run this from.
#   cd /path/to/project && bash george-setup-lite/install.sh
# Copies .claude/ (agents, skills, hooks, settings), then hides it from git locally.
set -e
src=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
tgt=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Run this inside the project's git repo." >&2; exit 1; }
[ "$src" = "$tgt" ] && { echo "Run it from the target project, not from the setup repo." >&2; exit 1; }

mkdir -p "$tgt/.claude"
for d in agents skills hooks; do
  mkdir -p "$tgt/.claude/$d"
  cp -Rp "$src/.claude/$d/." "$tgt/.claude/$d/"
done
chmod +x "$tgt"/.claude/hooks/*.sh "$tgt"/.claude/skills/hide-harness/hide.sh

if [ ! -f "$tgt/.claude/settings.json" ]; then
  cp "$src/.claude/settings.json" "$tgt/.claude/settings.json"
elif command -v jq >/dev/null; then
  tmp=$(mktemp)
  jq -s '
    def addnew($xs): reduce $xs[] as $x (.; if index([$x]) then . else . + [$x] end);
    .[0] as $t | .[1] as $s | $t
    | .permissions = (($t.permissions // {})
        | .allow = ((.allow // []) | addnew($s.permissions.allow // []))
        | .deny  = ((.deny  // []) | addnew($s.permissions.deny  // [])))
    | .hooks = reduce (($s.hooks // {}) | to_entries[]) as $e (($t.hooks // {});
        .[$e.key] = ((.[$e.key] // []) | addnew($e.value)))
  ' "$tgt/.claude/settings.json" "$src/.claude/settings.json" > "$tmp" && mv "$tmp" "$tgt/.claude/settings.json"
else
  echo "settings.json exists and jq is missing: merge $src/.claude/settings.json by hand." >&2
fi

(cd "$tgt" && bash .claude/skills/hide-harness/hide.sh)
# Hide the setup folder itself if it was cloned inside the project.
case "$src" in "$tgt"/*)
  rel=${src#"$tgt"/}; ex=$(git -C "$tgt" rev-parse --git-path info/exclude)
  grep -qxF "$rel/" "$tgt/$ex" 2>/dev/null || grep -qxF "$rel/" "$ex" 2>/dev/null || echo "$rel/" >> "$(cd "$tgt" && git rev-parse --git-path info/exclude)" ;;
esac
echo "Installed. Restart Claude Code, then: /sprint 90 <problem>"
