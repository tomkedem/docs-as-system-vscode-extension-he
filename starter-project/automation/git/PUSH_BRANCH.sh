#!/usr/bin/env bash
set -euo pipefail

log()  { echo "[PUSH] $*"; }
fail() { echo "[PUSH][ERROR] $*" >&2; exit 1; }

CONFIG_FILE="docs/agent/AGENT_CONFIG.yaml"

# Validate config file
[[ -f "$CONFIG_FILE" ]] || fail "AGENT_CONFIG.yaml not found at: $CONFIG_FILE"

# Validate tools
command -v yq  >/dev/null 2>&1 || fail "yq is required but not installed. See https://github.com/mikefarah/yq"
command -v git >/dev/null 2>&1 || fail "git is required but not installed."

# Load Git-related configuration from YAML
ALLOW_AGENT_PUSH="$(yq '.git.allowAgentPush' "$CONFIG_FILE")"
mapfile -t PROTECTED_BRANCHES < <(yq '.git.protectedBranches[]' "$CONFIG_FILE")

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "Not inside a Git repository"

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[[ -n "$BRANCH" ]] || fail "No active branch detected"

log "Current branch: $BRANCH"

# Prevent pushing protected branches via this script
for pattern in "${PROTECTED_BRANCHES[@]}"; do
  if [[ "$BRANCH" == $pattern ]]; then
    fail "Push to protected branch is not allowed via this script: $BRANCH (matched: $pattern)"
  fi
done

# Enforce allowAgentPush policy
if [[ "$ALLOW_AGENT_PUSH" != "true" ]]; then
  fail "Push is blocked by policy (allowAgentPush=false). A human or CI pipeline must perform the push."
fi

# Ensure 'origin' exists
if ! git remote get-url origin >/dev/null 2>&1; then
  fail "No 'origin' remote found. Cannot push branch."
fi

# Perform push
log "Pushing branch to origin with upstream: $BRANCH -> origin/$BRANCH"
if ! git push -u origin "$BRANCH"; then
  fail "Push failed for branch: $BRANCH"
fi

log "Branch successfully pushed to origin/$BRANCH"
