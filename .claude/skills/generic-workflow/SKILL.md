---
name: generic-workflow
description: Git branch-first workflow, automatic hooks validation, and GitOps parity with CI. Use when committing, pushing, opening PRs, or setting up a new clone.
---

# generic-workflow

## Branch first

```bash
git checkout main && git pull
git checkout -b feature/short-description
```

Never implement on `main`.

## Automation

After `bash scripts/bootstrap.sh`:

| Action | Automatic check |
|--------|-----------------|
| commit | `scripts/validate.sh` + Conventional Commits |
| push | `scripts/validate.sh --pre-push` |
| merge to main | Discord notification (`notify-discord.yml`) |

Do not ask the user to run validate scripts manually. No reviews are required — merge your own PR once `validate` is green.

## Docs in the same PR

Update `docs/INDEX.md` when docs change. The PR title is the squash-commit message, so it must be a Conventional Commit.
