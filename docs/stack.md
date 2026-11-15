# Tech stack

Decided in [#19](https://github.com/Itin-dev/aihackaton_test/issues/19).

| Part | Path | Tech |
| --- | --- | --- |
| Backend | `services/api/` | Python 3.12, FastAPI, uv, pytest, ruff |
| Frontend | `apps/web/` | Vite, React, TypeScript, Tailwind v4, Vitest, oxlint |
| AI | `services/api/app/llm.py` | OpenRouter via the `openai` SDK (OpenAI-compatible API) |

## Run locally

```bash
make api   # http://localhost:8000  (docs: /docs)
make web   # http://localhost:5173  (proxies /api → :8000)
```

`.env` at the repo root holds `OPENROUTER_API_KEY` (and optionally `OPENROUTER_MODEL`).

## Conventions

- All HTTP routes live under `/api` so the frontend proxy and a single deploy stay simple.
- Routes stay thin (`app/main.py`); logic goes into its own module.
- Call LLMs only through the `get_llm` dependency — tests override it with a fake, so
  tests never hit the network or cost money.
- Frontend calls relative URLs (`/api/...`), never `localhost:8000`.

## Tests (TDD)

| Part | Command | Runs in |
| --- | --- | --- |
| Backend | `cd services/api && uv run pytest` | `scripts/validate-stack.sh` |
| Frontend | `npm --prefix apps/web test` (watch) | `npm run check` in `validate-stack.sh` |

## Adding dependencies

```bash
cd services/api && uv add <package>        # dev-only: uv add --dev <package>
npm --prefix apps/web install <package>    # dev-only: add -D
```

Commit the lockfiles (`uv.lock`, `package-lock.json`). Teammates get them via `bash scripts/bootstrap.sh`.
