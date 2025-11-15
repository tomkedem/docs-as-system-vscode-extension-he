#!/usr/bin/env bash
set -euo pipefail

log()  { echo "[MERGE] $*"; }
fail() { echo "[MERGE][ERROR] $*" >&2; exit 1; }

CONFIG_FILE="docs/agent/AGENT_CONFIG.yaml"

# Runtime arg: PR number
PR_NUMBER="${1:-}"

# This script is intended to be run by a human only.
# Agents must not be allowed to execute it.
if [[ "${AGENT_EXECUTION:-false}" == "true" ]]; then
  fail "This script must not be executed by an agent. Human-only operation."
fi

[[ -n "$PR_NUMBER" ]] || fail "Pull Request number is required. Usage: MERGE_AFTER_APPROVAL.sh <pr-number>"

# Validate config file
[[ -f "$CONFIG_FILE" ]] || fail "AGENT_CONFIG.yaml not found at: $CONFIG_FILE"

# Validate tools
command -v yq >/dev/null 2>&1 || fail "yq is required but not installed. Install from https://github.com/mikefarah/yq"
command -v gh  >/dev/null 2>&1 || fail "GitHub CLI (gh) is required but not installed. See https://cli.github.com"
command -v git >/dev/null 2>&1 || fail "git is required but not installed."

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "Not inside a Git repository"

# Load protected branches from config
mapfile -t PROTECTED_BRANCHES < <(yq '.git.protectedBranches[]' "$CONFIG_FILE")

# Fetch PR details
log "Fetching PR #$PR_NUMBER details via gh"
PR_JSON="$(gh pr view "$PR_NUMBER" --json state,mergeable,headRefName,baseRefName,checksStatus,url 2>/dev/null)" ||
  fail "Failed to fetch PR #$PR_NUMBER. Make sure you are in the correct repository and authenticated with gh."

PR_STATE="$(printf '%s' "$PR_JSON" | yq '.state')"
PR_MERGEABLE="$(printf '%s' "$PR_JSON" | yq '.mergeable')"
PR_HEAD_BRANCH="$(printf '%s' "$PR_JSON" | yq '.headRefName')"
PR_BASE_BRANCH="$(printf '%s' "$PR_JSON" | yq '.baseRefName')"
PR_CHECKS_STATUS="$(printf '%s' "$PR_JSON" | yq '.checksStatus')"
PR_URL="$(printf '%s' "$PR_JSON" | yq '.url')"

log "PR #$PR_NUMBER state: $PR_STATE"
log "Head branch: $PR_HEAD_BRANCH"
log "Base branch: $PR_BASE_BRANCH"
log "Checks status: ${PR_CHECKS_STATUS:-unknown}"
log "URL: $PR_URL"

# Validate PR state
if [[ "$PR_STATE" != "OPEN" ]]; then
  fail "PR #$PR_NUMBER is not open. Current state: $PR_STATE"
fi

# Validate mergeability
if [[ "$PR_MERGEABLE" != "MERGEABLE" && "$PR_MERGEABLE" != "MERGEABLE_UNCLEAN" ]]; then
  fail "PR #$PR_NUMBER is not mergeable at this time (mergeable=$PR_MERGEABLE). Resolve conflicts or issues first."
fi

# Require checks to be successful if checksStatus is reported
if [[ -n "$PR_CHECKS_STATUS" && "$PR_CHECKS_STATUS" != "SUCCESS" ]]; then
  fail "Status checks are not successful for PR #$PR_NUMBER (checksStatus=$PR_CHECKS_STATUS). Merge is blocked."
fi

# Ensure base branch is a protected branch (this script is intended for protected branches like main/release/*)
is_protected_base=false
for pattern in "${PROTECTED_BRANCHES[@]}"; do
  if [[ "$PR_BASE_BRANCH" == $pattern ]]; then
    is_protected_base=true
    break
  fi
done

if [[ "$is_protected_base" != "true" ]]; then
  log "Warning: base branch '$PR_BASE_BRANCH' is not listed as protected in AGENT_CONFIG.yaml."
  log "This script is intended primarily for merging into protected branches like main or release/*."
fi

# Final human confirmation (unless explicitly bypassed)
if [[ "${HUMAN_MERGE_CONFIRM:-}" != "true" ]]; then
  echo
  echo "About to merge PR #$PR_NUMBER into '$PR_BASE_BRANCH'"
  echo "PR URL: $PR_URL"
  echo
  read -r -p "Are you sure you want to proceed with the merge? [y/N] " answer
  case "$answer" in
    [yY][eE][sS]|[yY]) ;;
    *) fail "Merge aborted by user." ;;
  esac
fi

# Perform merge via gh
log "Merging PR #$PR_NUMBER into $PR_BASE_BRANCH"
if ! gh pr merge "$PR_NUMBER" --merge --delete-branch; then
  fail "gh failed to merge PR #$PR_NUMBER"
fi

log "PR #$PR_NUMBER merged successfully into $PR_BASE_BRANCH."
log "The source branch '$PR_HEAD_BRANCH' has been deleted if allowed by repository settings."
