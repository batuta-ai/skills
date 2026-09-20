# Routing — lanes, rules, defaults

Default only: `/batuta-init` writes project `.batuta/routing.md` with real
executors/models, and that editable table wins.

## Contents

- Taxonomy
- Default table
- Rules
- Research ladder
- Adapters

## Taxonomy

**Complexity:**

| Lane | Intent | Minimum posture |
|---|---|---|
| `low` | contained rename/config/copy/simple test | cheapest coder |
| `medium` | isolated feature, clear bug, moderately coordinated interface | mid-tier; raise reasoning before cost |
| `high` | subsystem/multi-file work fully captured by a precise brief | strong model, high reasoning |
| `critical` | architecture, security or work needing conversation/open decisions | host (`self`), or strong CLI when loop-first |

**Domain:** `backend, frontend, mobile, data, infra, security, testing, docs,
general, fullstack`. Rows may select executors by domain; no domain means all.

High vs critical is the **brief test**, not size: self-sufficient → `high`;
conversation-dependent → `critical`. In doubt, `critical`.

## Default table

Onboarding adapts this assumed full installation.

| Lane | Domain | Executor | Model | Cost |
|---|---|---|---|---|
| low | * | opencode | `<provider/model>` set at onboarding (kimi, deepseek, glm…) | cents (API) |
| medium | * | codex | default model | ChatGPT subscription |
| high | * | codex | `<strongest model>`, reasoning high, set at onboarding | ChatGPT subscription |
| critical | * | self | the session's model | host subscription |

Loop-first seats `critical` on a strong CLI; open decisions park with `BATUTA-QUESTION`.

## Rules

- Classify and announce: `→ codex/gpt-5.6-sol: medium backend — <title>`.
- User overrides always win.
- Freeze executor, model and effort before choosing transport; see `dispatch.md`.
- **Escalation:** two failed verifications (original + 1 retry) → one row up.
- **Unavailable executor** (install/login/model) → announce, then one row up.
- **Explicit model:** name the exact CLI model, not its mutable global default. Codex default may serve `medium` (flat task cost); `high` stays explicit.
- **Discover, never recall:** onboarding confirms model IDs via adapter `models`.
- **`self`:** conducting host (Claude Code or Codex session); `claude.md`/`codex.md` invoke a background CLI. Never used below `critical`.
- **Dormant adapters:** read only the routed/added one; onboarding probes shipped adapters only.

## Research ladder

| Lane | Brief |
|---|---|
| low (required) | locate one symbol/file or map a directory |
| medium (recommended) | synthesize cross-module flow, several questions, or diff verification |
| high (optional) | judge ranked hypotheses or architecture |

In doubt use low: a wrong low costs one cheap retry; medium costs only price.

| Role | Lane | Executor | Model | Cost |
|---|---|---|---|---|
| review | — | CLI | exact | — |
| research | low | CLI | exact | cents |
| research | medium | CLI | exact | varies |
| research | high | CLI | exact | varies |

Research uses CLI executors (never `self`) and exact models; review stays one
row. No `Lane` column means research low. Per `scout.md`, ghost anchor or guard
violation gets one same-row retry with feedback, then one row up; top-row
failure/unavailability falls back to researching it yourself.

## Adapters

One file per executor at `adapters/<executor>.md`; the project may override
with `.batuta/adapters/<executor>.md`. The YAML frontmatter is the machine
contract (`run`, `readonly`, `available`, `models`, `finished`,
`limit_regex`); the prose is for you. New executor: copy
`adapters/_template.md`, fill the frontmatter, add a row.
