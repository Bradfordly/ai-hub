#!/usr/bin/env bash
# Install ai-hub's agents, skills, and rules into the current user's harness.
#
#   scripts/bootstrap.sh            # plugin mode (default when `claude` is on PATH)
#   scripts/bootstrap.sh --link     # symlink mode: ~/.claude/{agents,skills} and ~/.agents/skills
#
# Idempotent: safe to re-run, for example from a cloud environment setup script.
#
# Environment:
#   AI_HUB_MARKETPLACE   marketplace source for plugin mode (default: Bradfordly/ai-hub)
#   AI_HUB_CACHE         where --link clones upstream skills (default: ~/.cache/ai-hub)
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE="${AI_HUB_MARKETPLACE:-Bradfordly/ai-hub}"
CACHE="${AI_HUB_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/ai-hub}"
UPSTREAM_URL="https://github.com/mattpocock/skills.git"

mode="plugin"
case "${1:-}" in
  --link) mode="link" ;;
  --plugin|"") ;;
  -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
  *) echo "unknown option: $1" >&2; exit 2 ;;
esac
if [ "$mode" = "plugin" ] && ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found; falling back to --link" >&2
  mode="link"
fi

# Symlink $1 to $2, replacing an existing symlink but never a real file or directory.
link() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip $dest (exists and is not a symlink)" >&2
    return
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

install_plugins() {
  # A fresh HOME (e.g. a cloud VM) may not have the official marketplace registered or current.
  if ! claude plugin marketplace list 2>/dev/null | grep -q claude-plugins-official; then
    claude plugin marketplace add anthropics/claude-plugins-official
  fi
  claude plugin marketplace update claude-plugins-official
  claude plugin install mattpocock-skills@claude-plugins-official
  claude plugin install ai-hub --marketplace "$MARKETPLACE"
  claude plugin list
}

link_all() {
  local skill_dests=("$HOME/.claude/skills" "$HOME/.agents/skills")
  mkdir -p "$HOME/.claude/agents" "${skill_dests[@]}"

  for agent in "$REPO"/agents/*.md; do
    link "$agent" "$HOME/.claude/agents/$(basename "$agent")"
  done

  # Upstream mattpocock skills: the promoted set listed in its plugin.json.
  local upstream="$CACHE/mattpocock-skills"
  if [ -d "$upstream/.git" ]; then
    git -C "$upstream" pull --ff-only --quiet
  else
    mkdir -p "$CACHE"
    git clone --depth 1 --quiet "$UPSTREAM_URL" "$upstream"
  fi
  local skill_dirs=()
  while IFS= read -r rel; do
    skill_dirs+=("$upstream/$rel")
  done < <(sed -n 's/^ *"\.\/\(skills\/[^"]*\)",\{0,1\}$/\1/p' "$upstream/.claude-plugin/plugin.json")

  # Hub skills and rules (rules are reference skills; see docs/adr/0002).
  while IFS= read -r -d '' skill_md; do
    skill_dirs+=("$(dirname "$skill_md")")
  done < <(find "$REPO/skills" "$REPO/rules" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

  for dest in "${skill_dests[@]}"; do
    for dir in "${skill_dirs[@]}"; do
      link "$dir" "$dest/$(basename "$dir")"
    done
  done
}

if [ "$mode" = "plugin" ]; then
  install_plugins
else
  link_all
fi
