#!/usr/bin/env bash
set -euo pipefail

log()  { echo "[OPEN_PR] $*"; }
fail() { echo "[OPEN_PR][ERROR] $*" >&2; exit 1; }

CONFIG_FILE="docs/agent/AGENT_CONFIG.yaml"

# Optional runtime vars
BASE_BRANCH_ARG="${1:-}"          # optional: override default base branch
PR_TITLE_OVERRIDE="${PR_TITLE:-}" # optional: override generated title
PR_BODY_OVERRIDE="${PR_BODY:-}"   # optional: override generated body
CYCLE_ID="${CYCLE_ID:-}"          # optional, used for tagging

# Validate config file
[[ -f "$CONFIG_FILE" ]] || fail "AGENT_CONFIG.yaml not found at: $CONFIG_FILE"

# Validate tools
command -v yq >/dev/null 2>&1 || fail "yq is required but not installed. See https://github.com/mikefarah/yq"
command -v gh >/dev/null 2>&1 || fail "GitHub CLI (gh) is required but not installed. See https://cli.github.com"
command -v git >/dev/null 2>&1 || fail "git is required but not installed."

# Validate Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  fail "Not inside a Git repository"

# Load config values
DEFAULT_BRANCH="$(yq '.git.defaultBranch' "$CONFIG_FILE")"
mapfile -t PROTECTED_BRANCHES < <(yq '.git.protectedBranches[]' "$CONFIG_FILE")

BASE_BRANCH="${BASE_BRANCH_ARG:-$DEFAULT_BRANCH}"

# Determine current branch (source branch)
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[[ -n "$CURRENT_BRANCH" ]] || fail "No active branch detected"

log "Current branch: $CURRENT_BRANCH"
log "Base branch:    $BASE_BRANCH"

# Ensure source branch is not protected
for pattern in "${PROTECTED_BRANCHES[@]}"; do
  if [[ "$CURRENT_BRANCH" == $pattern ]]; then
    fail "Opening a PR from a protected branch is not allowed: $CURRENT_BRANCH (matched: $pattern)"
  fi
done

# Ensure origin exists
git remote get-url origin >/dev/null 2>&1 ||
  fail "No 'origin' remote found. Cannot create Pull Request."

# Ensure branch is pushed and has an upstream
if ! git rev-parse --abbrev-ref "@{u}" >/dev/null 2>&1; then
  fail "Current branch has no upstream. Push the branch first (e.g., using PUSH_BRANCH.sh) before opening a PR."
fi

# Check if a PR already exists for this branch
if gh pr view "$CURRENT_BRANCH" >/dev/null 2>&1; then
  fail "A Pull Request already exists for branch: $CURRENT_BRANCH"
fi

# Build PR title
if [[ -n "$PR_TITLE_OVERRIDE" ]]; then
  PR_TITLE="$PR_TITLE_OVERRIDE"
else
  if [[ -n "$CYCLE_ID" ]]; then
    PR_TITLE="[Cycle $CYCLE_ID] Work from branch $CURRENT_BRANCH"
  else
    PR_TITLE="Work from branch $CURRENT_BRANCH"
  fi
fi

# Build PR body
if [[ -n "$PR_BODY_OVERRIDE" ]]; then
  PR_BODY="$PR_BODY_OVERRIDE"
else
  PR_BODY="Draft Pull Request created from branch \`$CURRENT_BRANCH\` targeting \`$BASE_BRANCH\`.

This PR is intended for human review and approval before merge.

- Source branch: \`$CURRENT_BRANCH\`
- Base branch:   \`$BASE_BRANCH\`"

  if [[ -n "$CYCLE_ID" ]]; then
    PR_BODY="$PR_BODY
- Cycle Id:      \`$CYCLE_ID\`"
  fi

  PR_BODY="$PR_BODY

According to Docs-as-System policy, this PR must be reviewed and approved by a human before any merge action."
fi

log "Creating draft Pull Request via gh..."
log "Title: $PR_TITLE"

# Create PR as draft
if ! gh pr create \
  --base "$BASE_BRANCH" \
  --head "$CURRENT_BRANCH" \
  --title "$PR_TITLE" \
  --body "$PR_BODY" \
  --draft; then
  fail "Failed to create Pull Request for branch: $CURRENT_BRANCH"
fi

log "Draft Pull Request created successfully for branch: $CURRENT_BRANCH"
log "A human reviewer must now review and approve this PR before merge."
