# Agent OS

Skills, hooks, and plugins for this template.

## Entrypoints

- Agents: [AGENTS.md](../AGENTS.md)
- Docs: [INDEX.md](INDEX.md)

## Skills (`.agents/skills/`)

Project skills (always present):

| Skill | Role |
|-------|------|
| `generic-project` | Layout, SoC, libraries-first |
| `generic-workflow` | Branch / hooks / GitOps |
| `generic-versioning` | SemVer / release-please |
| `generic-language` | English-only |
| `generic-tdd` | Test-first |
| `generic-docker` | Microservices + Compose |
| `generic-cleanliness` | Tidy repo checklist |
| `caveman*` / `cavecrew` | Token efficiency |

Continue mirrors live under `.continue/skills/` for caveman (and can mirror project skills).

### Recommended community skills

Installed by `bootstrap.sh --with-recommended-skills` via the [skills CLI](https://github.com/vercel-labs/skills):

| Skill | Source |
|-------|--------|
| `test-driven-development` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| `security-and-hardening` | addyosmani/agent-skills |
| `planning-and-task-breakdown` | addyosmani/agent-skills |
| `skill-creator` | [anthropics/skills](https://github.com/anthropics/skills) |

Code review: use `caveman-review` (vendored).

Opt-in (stack recipes / as needed):

- `performance` (addyosmani)
- `backend-development`, `web-development`, `web-testing`, `cybersecurity` ([rubencr14/agent-skills](https://github.com/rubencr14/agent-skills))
- `frontend-design`, `mcp-builder` (anthropics)

### Discovery registries

- [skills.sh](https://skills.sh)
- [claude-plugins.dev](https://claude-plugins.dev)

Pin installs in `skills-lock.json` when the CLI writes one.

## Enforcement

Docs and skills are guidance. **Enforcement** is layered so agents cannot casually bypass flows:

| Layer | What | Can model ignore? |
|-------|------|-------------------|
| Git hooks (`.githooks`) | `validate.sh` on commit/push; Conventional Commits | No (unless bypassed with `--no-verify`) |
| Branch protection on `main` | PR required, `validate` CI check must pass | No (server-side) |
| `AGENTS.md` | Binding workflow instructions | Soft |
| Skills / docs | Procedures and checklists | Soft — use for how-to |

If an agent tries to skip validation or push to `main`, git hooks and branch protection block it. Prefer fixing the failure over disabling hooks.

## Plugins

Do not commit a `plugins/` tree. Document Marketplace recommendations in AGENTS.md; install per machine/team.
