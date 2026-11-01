#!/usr/bin/env bash
# Scaffold a consumer repo with ai-hub's starter files. Existing files are left untouched.
#
#   scripts/new-project.sh <target-dir>
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$REPO/templates/project"
target="${1:?usage: new-project.sh <target-dir>}"
mkdir -p "$target"

while IFS= read -r -d '' src; do
  rel="${src#"$TEMPLATE"/}"
  dest="$target/$rel"
  if [ -e "$dest" ]; then
    echo "kept     $rel (already exists)"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "created  $rel"
  fi
done < <(find "$TEMPLATE" -type f -print0)

cat <<EOF

Next steps in $target:
  1. Fill in the TODOs in AGENTS.md (stack, public surface, commands).
  2. Install the hub if this machine doesn't have it: $REPO/scripts/bootstrap.sh
  3. Open Claude Code there, trust the folder, and run /setup-matt-pocock-skills once.
EOF
