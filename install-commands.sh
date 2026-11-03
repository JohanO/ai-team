#!/usr/bin/env bash
# Installs the AI team commands globally (~/.claude/commands).
#
# Reads the template commands in .claude/commands (people/, workflows/ and team.md),
# flattens them so they are available as /alice, /bob, /feature etc., and rewrites
# the relative file references to absolute paths into this repo.
# Re-run after editing a template command or moving the repo.
#
# Usage: ./install-commands.sh [destination]

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$repo_root/.claude/commands"
destination="${1:-$HOME/.claude/commands}"

mkdir -p "$destination"

while IFS= read -r file; do
    out="$destination/$(basename "$file")"

    while IFS= read -r line || [ -n "$line" ]; do
        if [[ $line =~ ^-\ ([A-Za-z0-9_./-]+\.md)[[:space:]]*$ ]]; then
            ref="$repo_root/${BASH_REMATCH[1]}"
            # Warn early on references that don't exist in the repo
            [ -f "$ref" ] || echo "WARNING: $ref is referenced but does not exist" >&2
            line="- $ref"
        fi
        printf '%s\n' "$line"
    done < "$file" > "$out"

    echo "Installed /$(basename "$file" .md)"
done < <(find "$source_dir" -name '*.md' | sort)
