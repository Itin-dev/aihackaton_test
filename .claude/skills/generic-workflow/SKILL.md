---
name: generic-workflow
description: Git branch-first workflow, automatic hooks validation, and GitOps parity with CI. Use when committing, pushing, opening PRs, or setting up a new clone.
---

# generic-workflow

## Start a ticket (mandatory when work maps to an issue)

When you pick up a GitHub issue ("take #33", "work on the home screen ticket"), run first:

```bash
bash scripts/start-task.sh <issue-number>
```

It assigns the issue to the current `gh` user, creates `feature/<n>-<slug>` (or `fix/…` for
`bug` issues) from fresh `main`, and moves the card on the Hackathon board to **In progress**.
Board warnings do not block work; mention them to the user.

Unsure which issue? `gh issue list --label P0 --assignee ""` — take the highest priority
(`P0` → `P1` → `P2`) unassigned one.

## Branch first (no issue)

```bash
git checkout main && git pull
git checkout -b feature/short-description
```

Never implement on `main`.

## Pull requests close their issue

Put `Closes #<n>` in the PR body (the template has the line). The board then moves the card
to **Review** when the PR opens and to **Done** when it merges.

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
