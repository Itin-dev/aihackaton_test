# Generic — Agent Entrypoint

Starting point for Claude Code in repositories created from this template. Claude Code is the only supported agent; project skills live in `.claude/skills/` and load automatically.

## What this project is

**generic** is a meta-kit for AI-assisted development: agent skills/rules/hooks, SemVer + GitOps automation, Docker/localdev conventions, and modular docs. Application code lives in projects created *from* this template — not in the template itself unless you are extending the kit.

## Read first

| Resource | Purpose |
|----------|---------|
| [README.md](README.md) | Human overview, Use this template |
| [docs/INDEX.md](docs/INDEX.md) | Docs map |
| [docs/cleanliness-and-organization.md](docs/cleanliness-and-organization.md) | Clean & organized contract (mandatory) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Setup, branch workflow |
| [CHANGELOG.md](CHANGELOG.md) | Keep a Changelog + SemVer |
| `.claude/skills/generic-project/` | Layout, SoC, libraries-first |
| `.claude/skills/generic-workflow/` | Git flow, hooks (auto) |
| `.claude/skills/generic-versioning/` | SemVer / release-please |
| `.claude/skills/generic-cleanliness/` | Tidy repo checklist |
| `.claude/skills/generic-language/` | English-only repo content |

## Language (mandatory)

**English only** in code, comments, docs, commits, and skills you write.
Read `.claude/skills/generic-language/SKILL.md`. User chat may be any language; repo files must be English.

## Token efficiency skills

| Skill | When |
|-------|------|
| `caveman` | User wants terse / fewer tokens |
| `caveman-compress` | Compress docs to save context |
| `cavecrew` | Compressed subagent delegation |
| `caveman-commit` | Draft conventional commit messages |
| `caveman-review` | Terse code review |
| `caveman-help` | Skill discovery |

## Recommended community skills

Installed by `bootstrap.sh --with-recommended-skills` (pinned in `skills-lock.json` when present):

- `test-driven-development`, `security-and-hardening`, `planning-and-task-breakdown`
- `skill-creator`
- Code review: `caveman-review`

See [docs/agent-os.md](docs/agent-os.md) for sources and registries.

## Project layout

```
services/         # microservices (preferred)
apps/             # frontends / CLIs / BFF
packages/         # shared libraries
tests/            # integration / repo-level tests
src/              # optional single-app layout (use OR services/, not both)
scripts/          # validate, bootstrap, secrets (invoked by hooks/CI)
docs/             # modular docs — start at docs/INDEX.md
.claude/skills/   # Claude Code skills
docker/           # compose example (infra placeholders)
```

## Mandatory workflow

### Binding (non-negotiable)

Git hooks (`.githooks/`) plus branch protection on `main` (PR + passing `validate` check) enforce the flow. Agents must not invent shortcuts, skip hooks, or commit on `main`. See [docs/agent-os.md](docs/agent-os.md#enforcement).

### 0. Branch first

```bash
git checkout main && git pull
git checkout -b feature/short-description   # or fix/...
```

Never implement on `main`.

### 1. Keep the repo clean

Follow [docs/cleanliness-and-organization.md](docs/cleanliness-and-organization.md).
Thin root, one responsibility per module, prefer existing libraries, prune unused placeholders, update docs INDEX.

### 2. Modular changes

- Prefer `services/<name>/` with a single responsibility per service
- Shared code → `packages/`
- Thin entrypoints; no mixed concerns

### 3. Documentation

- Behaviour changes → `CHANGELOG.md` `[Unreleased]`
- Large work → update `PLAN.md` / `PROGRESS.md`
- New docs → register in `docs/INDEX.md`

### 4. Commit and push — hooks run validation

After one-time `bash scripts/bootstrap.sh`, hooks run automatically:

| Git action | Hook | Effect |
|------------|------|--------|
| `git commit` | pre-commit | `scripts/validate.sh` |
| `git commit` | commit-msg | Conventional Commits |
| `git push` | pre-push | `scripts/validate.sh --pre-push` |

CI runs the same `scripts/validate.sh`. Releases are automated via **release-please** (do not bump versions by hand).

## Service paths (skip app gates)

Changes only under paths in `scripts/service-paths.list` skip app-oriented gates.
