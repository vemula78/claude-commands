#!/usr/bin/env bash
# Validates every command .md file in this repo:
#   - has YAML frontmatter delimited by --- ... ---
#   - frontmatter contains description, argument-hint, allowed-tools
#   - no unclosed code fences
# Used by the git pre-commit hook, CI, and the Claude Code PostToolUse hook —
# keep this the single source of truth for all three.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
for f in *.md; do
  [ -f "$f" ] || continue
  [ "$f" = "README.md" ] && continue

  if ! head -1 "$f" | grep -q '^---$'; then
    echo "FAIL $f: missing opening frontmatter delimiter"
    fail=1
    continue
  fi

  fm=$(awk '/^---$/{c++; next} c==1' "$f")
  for key in description argument-hint allowed-tools; do
    if ! echo "$fm" | grep -q "^${key}:"; then
      echo "FAIL $f: frontmatter missing '${key}:'"
      fail=1
    fi
  done

  fences=$(grep -c '^```' "$f" || true)
  if [ $((fences % 2)) -ne 0 ]; then
    echo "FAIL $f: unclosed code fence (odd number of \`\`\` lines)"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "OK: all command files valid"
fi
exit "$fail"
