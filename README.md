# aihackaton

Team repository for the [Powercoders Hackathon "AI for Access"](https://hackathon.powercoders.org/en/)
(Bern, 20–21 November 2026). Code freeze: Saturday 18:00.

## Team

| Role | Focus |
| --- | --- |
| Dev + DevOps | Skeleton app, CI, preview deploys, OpenRouter client |
| Dev | Features from issues |
| UI/UX designer | Figma, design handoff |
| Presenter | Ideas, pitch, demo script |

Tools: Claude Code (agentic coding), Figma (design), Discord (communication),
OpenRouter (AI backend), `gh` CLI (GitHub).

Figma boards: [Brain-Storming](https://www.figma.com/board/u8YyBh0deFEbRGSNhzfKJB/Brain-Storming?node-id=891-131)
· [Persona](https://www.figma.com/board/0xhOoQCvKNhARWytHY9IFa/Persona?node-id=0-1)
· [Design-Project](https://www.figma.com/design/oOu7PPG4eIaWZPFVOELCCI/Design-Project?node-id=0-1) (final app design)

## Quick start

```bash
git clone <repo-url> && cd aihackaton
bash scripts/bootstrap.sh   # once: git hooks, pre-commit, shellcheck, then runs the doctor
bash scripts/doctor.sh      # any time: checks your machine matches the team setup
```

Run the app:

```bash
make api   # terminal 1 → http://localhost:8000
make web   # terminal 2 → http://localhost:5173
```

Stack: FastAPI + React — see [docs/stack.md](docs/stack.md).

Claude Code runs the doctor quietly at every session start and tells you what is missing.

Work on a branch, open a PR, merge it yourself once the `validate` check is green.
Merges are announced in Discord. Details: [docs/gitops.md](docs/gitops.md).

## Voice capture

In Claude Code, dictate (or type) a prompt that starts with a trigger word:

| Say | Result |
| --- | --- |
| **Decision:** we deploy on Vercel | Closed issue labelled `decision` (the decision log) |
| **Ticket:** export the login screen from Figma | Open issue with an `area:*` label on the board |
| **Idea:** live captions for doctor visits | Open issue labelled `idea` — vote with 👍 |
| **Recap** | Summary of today's issues, ready to paste into Discord |

Speak any language; issues are written in English. One-time setup: `bash scripts/setup-labels.sh`.
How it works: [.claude/skills/capture/SKILL.md](.claude/skills/capture/SKILL.md).

## Documentation

Start at [docs/INDEX.md](docs/INDEX.md). Claude Code starts at [CLAUDE.md](CLAUDE.md).

## License

MIT — see [LICENSE](LICENSE).
