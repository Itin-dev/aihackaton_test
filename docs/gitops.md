# GitOps

## Branch first

Never implement on `main`. Create `feature/...` or `fix/...` from an updated `main`.

## Hooks equal CI

| Event | What runs |
|-------|-----------|
| commit | `scripts/validate.sh` + Conventional Commit message check |
| push | `scripts/validate.sh --pre-push` |
| GitHub Actions | same `scripts/validate.sh` |

Do not invent a second check path.

## Pull requests and merging

- `main` is protected: changes land via PR, and the `validate` check must pass.
- No reviews are required. Merge your own PR once `validate` is green (`gh pr merge --squash --delete-branch`).
- Discord gets a message when a PR is opened (or leaves draft) and when it is merged to `main`
  (`.github/workflows/notify-discord.yml`). Draft PRs stay quiet until marked ready.

### Discord notification setup (one time)

1. Discord: channel settings → Integrations → Webhooks → New Webhook → copy URL.
2. GitHub: `gh secret set DISCORD_WEBHOOK_URL` and paste the URL.

Without the secret, the workflow skips silently.

## Project board

Board: <https://github.com/orgs/Itin-dev/projects/1> — created and kept in sync by
`bash scripts/setup-project.sh` (idempotent; edit `TEAM` there to change editors).

Columns: Backlog → Todo → In progress → Review → Done. Areas are issue labels (`area:*`),
not board fields, so there is one place to set them.

Built-in workflows (board → ⋯ → Workflows) cannot be set through the API. Enable once:

- **Auto-add to project:** filter `is:issue,pr is:open -label:decision` → status Todo
- **Item closed** and **Pull request merged** → Done (on by default)

## Conventional Commits

Required. Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`, `perf`, `build`.

## Versioning

None. `main` is always the deployable demo; there are no release tags or `VERSION` file.

## Service paths

Changes limited to paths in `scripts/service-paths.list` skip app-oriented pre-push gates (meta-kit / docs / agent config).

## History

No CHANGELOG. PRs are squash-merged, so `git log --oneline main` reads as the change log —
one Conventional Commit per PR. CI rejects PR titles that are not Conventional Commits.
