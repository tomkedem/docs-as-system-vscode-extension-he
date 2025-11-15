#!/usr/bin/env bash
set -euo pipefail

# Runtime vars (provided by caller)
CYCLE_ID="${CYCLE_ID:-UNSPECIFIED_CYCLE}"
COMMIT_SCOPE="${COMMIT_SCOPE:-docs}"  # docs | src | mixed
MESSAGE="${MESSAGE:-}"

log()  { echo "[COMMIT] $*"; }
fail() { echo "[COMMIT][ERROR] $*" >&2; exit 1; }

CONFIG_FILE="docs/agent/AGENT_CONFIG.yaml"

# Validate config
[[ -f "$CONFIG_FILE" ]] || fail "AGENT_CONFIG.yaml not found at: $CONFIG_FILE"

command -v yq >/dev/null 2>&1 ||
  fail "yq is required but not installed. Install from https://github.com/mikefarah/yq"

# Load Git-related configuration
ALLOW_AGENT_COMMIT="$(yq '.git.allowAgentCommit' "$CONFIG_FILE")"

mapfile -t PROTECTED_BRANCHES < <(yq '.git.protectedBranches[]' "$CONFIG_FILE")
mapfile -t ALLOWED_PATHS_ARRAY < <(yq '.git.allowedPaths[]' "$CONFIG_FILE")

COMMIT_INCLUDE_TAGS="$(yq '.git.commitMessage.includeTags' "$CONFIG_FILE")"
COMMIT_INCLUDE_CYCLE_LINK="$(yq '.git.commitMessage.includeCycleLogLink' "$CONFIG_FILE")"
mapfile -t COMMIT_TRAILERS < <(yq '.git.commitMessage.trailers[]' "$CONFIG_FILE")

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "Not inside a Git repository"

# Enforce commit permission
if [[ "$ALLOW_AGENT_COMMIT" != "true" ]]; then
  fail "Commit is blocked by policy (allowAgentCommit=false)."
fi

# Enforce CYCLE_ID
if [[ "$CYCLE_ID" == "UNSPECIFIED_CYCLE" || -z "$CYCLE_ID" ]]; then
  fail "CYCLE_ID is missing. Expected format: YYYY_MM_DD_XXX (e.g., 2025_11_13_001)"
fi

# Optional: enforce expected CYCLE_ID format
if ! [[ "$CYCLE_ID" =~ ^[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{3}$ ]]; then
  log "Warning: CYCLE_ID does not match expected format YYYY_MM_DD_NNN: $CYCLE_ID"
fi

# Protect configured branches
current_branch="$(git rev-parse --abbrev-ref HEAD)"
for pattern in "${PROTECTED_BRANCHES[@]}"; do
  if [[ "$current_branch" == $pattern ]]; then
    fail "Commit on protected branch is not allowed: $current_branch (matched: $pattern)"
  fi
done

# Stage according to allowed paths
log "Staging paths allowed for this commit: ${ALLOWED_PATHS_ARRAY[*]}"
git add "${ALLOWED_PATHS_ARRAY[@]}"

# Ensure there are staged changes
if git diff --cached --quiet; then
  fail "No staged changes. Nothing to commit."
fi

# Build commit message
if [[ -z "$MESSAGE" ]]; then
  MESSAGE="Update within cycle $CYCLE_ID"
fi

if [[ "$COMMIT_INCLUDE_TAGS" == "true" ]]; then
  MESSAGE="$MESSAGE

Tags: CYCLE:$CYCLE_ID, SCOPE:$COMMIT_SCOPE, DOCS_AS_SYSTEM"
fi

# Build final commit message with optional trailers and cycle log link
tmpfile="$(mktemp)"
{
  printf '%s\n' "$MESSAGE"
  printf '\n'

  if [[ "$COMMIT_INCLUDE_CYCLE_LINK" == "true" ]]; then
    # Generic reference to the cycle log; exact path is resolved by logging configuration
    printf 'Cycle-Log: See IMPLEMENTATION_LOG for CYCLE_ID=%s\n' "$CYCLE_ID"
    printf '\n'
  fi

  printf 'Cycle-Id: %s\n' "$CYCLE_ID"
  printf 'Scope: %s\n' "$COMMIT_SCOPE"
  printf 'Automation: Agent-Commit\n'

  for trailer in "${COMMIT_TRAILERS[@]}"; do
    printf '%s\n' "$trailer"
  done
} > "$tmpfile"

git commit -F "$tmpfile"
rm -f "$tmpfile"

log "Commit created with CYCLE_ID=$CYCLE_ID. A Pull Request must be opened for human review."
