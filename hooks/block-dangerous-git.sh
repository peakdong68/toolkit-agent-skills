#!/usr/bin/env bash
# PreToolUse hook — blocks dangerous git commands
# Uses CLAUDE_TOOL_ARG_command env var (consistent with inline hooks in hooks.json)
set -euo pipefail

COMMAND="${CLAUDE_TOOL_ARG_command:-}"

# Fallback: if env var is empty, try reading JSON from stdin
if [ -z "$COMMAND" ] && [ ! -t 0 ]; then
    COMMAND=$(jq -r '.tool_input.command // empty' 2>/dev/null || true)
fi

if [ -z "$COMMAND" ]; then
    exit 0
fi

DANGEROUS_PATTERNS=(
    "git push"
    "git reset --hard"
    "git clean -fd"
    "git clean -f"
    "git branch -D"
    "git checkout \."
    "git restore \."
    "git checkout -- ."
    "git restore -- ."
    "git stash drop"
    "git stash clear"
    "rm -rf .git"
    "git reflog expire"
    "push --force"
    "reset --hard"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern"; then
        printf '{"message": "BLOCKED: '\\''%s'\\'' matches dangerous pattern '\\''%s'\\''", "blocked": true}\n' \
            "$COMMAND" "$pattern" >&2
        exit 2
    fi
done

exit 0