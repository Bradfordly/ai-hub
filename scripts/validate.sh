#!/usr/bin/env bash
# Lint the hub: skill and agent frontmatter, then the Claude Code plugin manifests.
# Exits non-zero on the first category of failure. Run before every commit.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
err() { echo "error: $*" >&2; fail=1; }

# Print the value of frontmatter field $2 in file $1 (first match only).
field() { sed -n '/^---$/,/^---$/{s/^'"$2"': *//p;}' "$1" | head -n1; }

# Skills and rules: name matches the directory, and a description exists.
while IFS= read -r -d '' skill_md; do
  dir="$(basename "$(dirname "$skill_md")")"
  [ "$(field "$skill_md" name)" = "$dir" ] || err "$skill_md: name must equal '$dir'"
  [ -n "$(field "$skill_md" description)" ] || err "$skill_md: missing description"
done < <(find "$REPO/skills" "$REPO/rules" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

# Agents: name matches the filename, description and model are set, no project leakage.
for agent in "$REPO"/agents/*.md; do
  base="$(basename "$agent" .md)"
  [ "$(field "$agent" name)" = "$base" ] || err "$agent: name must equal '$base'"
  [ -n "$(field "$agent" description)" ] || err "$agent: missing description"
  [ -n "$(field "$agent" model)" ] || err "$agent: set a model (see docs/authoring-agents.md)"
done
if grep -rIl -i 'bradfordly-games' "$REPO/agents" "$REPO/rules" "$REPO/skills" >/dev/null 2>&1; then
  err "project-specific name found in agents/rules/skills: $(grep -rIl -i 'bradfordly-games' "$REPO/agents" "$REPO/rules" "$REPO/skills" | tr '\n' ' ')"
fi

if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$REPO/.claude-plugin/plugin.json" --strict || fail=1
  claude plugin validate "$REPO/.claude-plugin/marketplace.json" --strict || fail=1
else
  echo "claude CLI not found; skipped plugin manifest validation" >&2
fi

[ "$fail" -eq 0 ] && echo "ok"
exit "$fail"
