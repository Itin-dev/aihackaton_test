#!/usr/bin/env bash
# shellcheck disable=SC2016  # $vars inside GraphQL queries are GraphQL variables
# Start work on a GitHub issue: assign it to you, create its branch from main,
# and move its card on the "Hackathon" board to "In progress".
#
# Usage: bash scripts/start-task.sh <issue-number>
# Needs: gh with the `project` scope (gh auth refresh -s project).
# Board steps are best-effort: a failure there warns but never blocks the branch.
set -euo pipefail

BOARD_TITLE="Hackathon"
STATUS="In progress"

# branch_name <number> <title> [labels-csv] -> feature/<n>-<slug> (fix/ for bugs)
branch_name() {
  local number="$1" title="$2" labels="${3:-}" prefix="feature" slug
  [[ ",$labels," == *",bug,"* ]] && prefix="fix"
  slug="$(printf '%s' "$title" | LC_ALL=C tr '[:upper:]' '[:lower:]' \
    | LC_ALL=C tr -cs 'a-z0-9' ' ' | awk '{for (i = 1; i <= NF && i <= 6; i++) printf "%s%s", (i > 1 ? "-" : ""), $i}')"
  printf '%s/%s-%s\n' "$prefix" "$number" "${slug:-task}"
}

warn() { echo "warning: $*" >&2; }

move_to_in_progress() {
  local issue_url="$1" owner="$2" number project_id field_id option_id item_id
  number="$(gh project list --owner "$owner" --format json \
    --jq ".projects[] | select(.title == \"$BOARD_TITLE\") | .number" | head -n 1)"
  [ -n "$number" ] || { warn "board \"$BOARD_TITLE\" not found"; return 1; }
  project_id="$(gh project view "$number" --owner "$owner" --format json --jq .id)"
  read -r field_id option_id < <(gh project field-list "$number" --owner "$owner" --format json \
    --jq ".fields[] | select(.name == \"Status\") | [.id, (.options[] | select(.name == \"$STATUS\") | .id)] | @tsv")
  # item-add is idempotent: returns the existing item when the issue is already on the board.
  item_id="$(gh project item-add "$number" --owner "$owner" --url "$issue_url" --format json --jq .id)"
  gh project item-edit --project-id "$project_id" --id "$item_id" \
    --field-id "$field_id" --single-select-option-id "$option_id" >/dev/null
  echo "Board: \"$STATUS\""
}

main() {
  local issue="${1:-}" repo owner title labels url state branch
  if [[ ! "$issue" =~ ^[0-9]+$ ]]; then
    echo "Usage: bash scripts/start-task.sh <issue-number>" >&2
    exit 2
  fi
  repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
  owner="${repo%%/*}"
  IFS=$'\t' read -r title labels url state < <(gh issue view "$issue" --json title,labels,url,state \
    --jq '[.title, ([.labels[].name] | join(",")), .url, .state] | @tsv')
  [ "$state" = "OPEN" ] || { echo "Issue #$issue is $state" >&2; exit 1; }

  if [ -n "$(git status --porcelain)" ]; then
    echo "Working tree not clean; commit or stash first." >&2
    exit 1
  fi

  branch="$(branch_name "$issue" "$title" "$labels")"
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch"
  else
    git checkout main && git pull --ff-only
    git checkout -b "$branch"
  fi

  gh issue edit "$issue" --add-assignee @me >/dev/null || warn "could not assign #$issue"
  move_to_in_progress "$url" "$owner" || warn "board not updated (gh auth refresh -s project?)"

  echo "Started #$issue: $title"
  echo "Branch: $branch"
  echo "Open the PR with \"Closes #$issue\" in the body so the board moves to Review and Done."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
