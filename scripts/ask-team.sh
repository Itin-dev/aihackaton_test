#!/usr/bin/env bash
# Post a question to the team's Discord questions channel (send-only incoming webhook).
#
# Usage: bash scripts/ask-team.sh [--dry-run] "<question>"
# Needs: DISCORD_QUESTIONS_WEBHOOK_URL in the environment or in .env (see docs/gitops.md).
# --dry-run prints the JSON payload instead of sending it (no URL needed).
set -euo pipefail

MAX_LEN=2000  # Discord message content limit

usage() { echo 'Usage: bash scripts/ask-team.sh [--dry-run] "<question>"' >&2; exit 2; }

# build_payload <author> <branch> <question> -> webhook JSON (mentions disabled, length capped)
build_payload() {
  jq -n --arg author "$1" --arg branch "$2" --arg q "$3" --argjson max "$MAX_LEN" '
    ("❓ **Question** · `" + $branch + "`\n") as $prefix
    | ($max - ($prefix | length)) as $room
    | {
        username: ($author + "'\''s agent"),
        allowed_mentions: {parse: []},
        content: ($prefix + (if ($q | length) > $room then $q[0:$room - 1] + "…" else $q end))
      }'
}

# webhook_url -> URL from the environment, else from the .env file (never sourced, only read)
webhook_url() {
  local env_file="${ASK_TEAM_ENV_FILE:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)/.env}"
  if [ -n "${DISCORD_QUESTIONS_WEBHOOK_URL:-}" ]; then
    printf '%s\n' "$DISCORD_QUESTIONS_WEBHOOK_URL"
  elif [ -f "$env_file" ]; then
    sed -n 's/^DISCORD_QUESTIONS_WEBHOOK_URL=//p' "$env_file" | tail -n 1 | tr -d '"'"'"
  fi
}

main() {
  local dry_run=false question author branch payload url
  if [ "${1:-}" = "--dry-run" ]; then dry_run=true; shift; fi
  question="${1:-}"
  [ -n "${question//[[:space:]]/}" ] || usage

  author="$(git config user.name 2>/dev/null || true)"
  branch="$(git branch --show-current 2>/dev/null || true)"
  payload="$(build_payload "${author:-$USER}" "${branch:-unknown}" "$question")"

  if [ "$dry_run" = true ]; then
    printf '%s\n' "$payload"
    exit 0
  fi

  url="$(webhook_url)"
  if [ -z "$url" ]; then
    echo "DISCORD_QUESTIONS_WEBHOOK_URL is not set. Add it to .env (see docs/gitops.md)." >&2
    exit 1
  fi
  if [[ ! "$url" =~ ^https://(discord\.com|discordapp\.com)/api/webhooks/ ]]; then
    echo "DISCORD_QUESTIONS_WEBHOOK_URL is not a Discord webhook URL." >&2
    exit 1
  fi

  curl -fsS -H "Content-Type: application/json" -d "$payload" "$url" >/dev/null
  echo "Question posted to Discord."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
