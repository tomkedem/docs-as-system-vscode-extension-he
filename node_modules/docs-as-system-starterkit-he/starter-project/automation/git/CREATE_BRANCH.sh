#!/usr/bin/env bash
set -euo pipefail

log()  { echo "[CREATE_BRANCH] $*"; }
fail() { echo "[CREATE_BRANCH][ERROR] $*" >&2; exit 1; }

CONFIG_FILE="docs/agent/AGENT_CONFIG.yaml"

# Validate config file
[[ -f "$CONFIG_FILE" ]] || fail "AGENT_CONFIG.yaml not found at: $CONFIG_FILE"

# Validate yq installation
command -v yq >/dev/null 2>&1 ||
  fail "yq is required but not installed. Install from https://github.com/mikefarah/yq"

# Load Git-related configuration
DEFAULT_BRANCH="$(yq '.git.defaultBranch' "$CONFIG_FILE")"
WORKING_PATTERN_STR="$(yq '.git.workingBranchPattern' "$CONFIG_FILE")"
ALLOW_AGENT_PUSH="$(yq '.git.allowAgentPush' "$CONFIG_FILE")"

mapfile -t PROTECTED_BRANCHES < <(yq '.git.protectedBranches[]' "$CONFIG_FILE")

# Runtime argument: branch name
BRANCH_NAME="${1:-}"

# Preconditions
[[ -n "$BRANCH_NAME" ]] || fail "Branch name is required. Example: feature/initial-setup"

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "Not inside a Git repository"

# Try to fetch from origin if it exists
if git remote get-url origin >/dev/null 2>&1; then
  log "Fetching from origin (prune)"
  git fetch origin --prune
else
  log "Warning: no 'origin' remote detected. Working with local branches only."
fi

# Validate branch name against workingBranchPattern (globs separated by '|')
IFS='|' read -r -a WORKING_PATTERNS <<< "$WORKING_PATTERN_STR"

allowed=false
for pat in "${WORKING_PATTERNS[@]}"; do
  if [[ "$BRANCH_NAME" == $pat ]]; then
    allowed=true
    break
  fi
done

if [[ "$allowed" != "true" ]]; then
  fail "Branch name '$BRANCH_NAME' does not match workingBranchPattern: $WORKING_PATTERN_STR"
fi

# Ensure branch name is not protected
for pattern in "${PROTECTED_BRANCHES[@]}"; do
  if [[ "$BRANCH_NAME" == $pattern ]]; then
    fail "Cannot create or overwrite protected branch: $BRANCH_NAME (matched: $pattern)"
  fi
done

# Ensure clean working tree
if ! git diff --quiet || ! git diff --cached --quiet; then
  fail "Working tree is not clean. Commit, stash or discard changes before creating a branch."
fi

# Checkout default branch
log "Checking out default branch: $DEFAULT_BRANCH"
git checkout "$DEFAULT_BRANCH"

# Fast-forward from origin if available
if git remote get-url origin >/dev/null 2>&1; then
  log "Updating default branch from origin with fast-forward only"
  if ! git pull --ff-only origin "$DEFAULT_BRANCH"; then
    log "Warning: could not fast-forward from origin. Using local state of $DEFAULT_BRANCH."
  fi
fi

# Create new branch
log "Creating new branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Optional push controlled by allowAgentPush
if [[ "$ALLOW_AGENT_PUSH" == "true" ]]; then
  if git remote get-url origin >/dev/null 2>&1; then
    log "Pushing new branch to origin and setting upstream: $BRANCH_NAME -> origin/$BRANCH_NAME"
    git push -u origin "$BRANCH_NAME" || fail "Push failed for branch: $BRANCH_NAME"
  else
    log "Warning: allowAgentPush=true but no 'origin' remote is configured. Skipping push."
  fi
else
  log "Branch created locally: $BRANCH_NAME. Push is blocked by policy (allowAgentPush=false). Use PUSH_BRANCH.sh or a human-controlled push when appropriate."
fi
