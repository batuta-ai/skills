# batuta-ai/skills

> 🇧🇷 [Versão em português](README.pt-BR.md)

> *Quem rege não toca.* — The conductor does not play.

The Batuta skills: a conducting cycle for AI coding agents. The agent you
talk to becomes the **conductor** — it classifies the task, routes it to
the cheapest executor that can handle it, writes the brief, delegates,
verifies the diff and commits. The code is written by **executors**:
`codex`, `opencode` (Kimi, DeepSeek, GLM…), `cursor-agent`, `gemini`, a
background `claude`, or the conductor itself only for critical work.

This repository is pure markdown in the [agentskills.io](https://agentskills.io)
format. It installs into any host that reads `SKILL.md` files. Host
packages with hooks, commands and manifests live in
[batuta-ai/batuta](https://github.com/batuta-ai/batuta); the CompozyOS
extension in [batuta-ai/compozy](https://github.com/batuta-ai/compozy);
the `batuta` binary (gates, inventory, unattended loop) in
[batuta-ai/core](https://github.com/batuta-ai/core).

## Install

```bash
npx skills add batuta-ai/skills            # every detected agent, this project
npx skills add batuta-ai/skills -g         # user-wide
npx skills add batuta-ai/skills -a codex   # one agent
```

Then, in a project: `/batuta-init` once, `/batuta` from there on.

## The four guarantees

| Guarantee | How |
|---|---|
| **Atomic commits** | one verified task = one commit; a list of six becomes six cycles |
| **Resumable state** | `WORK.md` in prose at the project root; `/batuta-pause` and `/batuta-resume` across sessions |
| **Plan when needed** | clear task goes straight in; ambiguous task gets two or three questions; long work gets `/batuta-plan` |
| **Verification always** | scope check, diff review, tests run by the conductor, criteria with re-run proof — the executor's report is never evidence |

## Skills

| Skill | Invoked by | Does |
|---|---|---|
| `batuta` | the model, on any delegable task | the cycle: classify → decompose → brief → delegate → verify → commit |
| `batuta-review` | the model, on "review this" | Step 4 over any diff, optional second reviewer |
| `batuta-init` | `/batuta-init` | onboarding and reconfiguration: profile, lanes, models, project map |
| `batuta-plan` | `/batuta-plan` | approvable plan of atomic-commit-sized tasks |
| `batuta-loop` | `/batuta-loop` | unattended run of an approved plan through the `batuta` binary |
| `batuta-status` | `/batuta-status` | in progress, done, leftovers, delegation and escalation rates |
| `batuta-route` | `/batuta-route` | view and edit the routing table |
| `batuta-pause` / `batuta-resume` | `/batuta-pause`, `/batuta-resume` | session handoff |

Only `batuta` and `batuta-review` load on the model's own initiative; the
rest cost nothing until invoked.

## Routing

Four lanes by complexity, optionally split by domain, each naming an
executor and an exact model:

| Lane | Default executor | Cost |
|---|---|---|
| `low` | opencode + a budget model | cents |
| `medium` | codex, default model | ChatGPT subscription |
| `high` | codex, strongest model, high reasoning | ChatGPT subscription |
| `critical` | the conducting host itself | host subscription |

Onboarding discovers what is installed and proposes the table; you confirm.
An executor that fails twice escalates one row up. Adding an executor is
one markdown file: copy `skills/batuta/adapters/_template.md`, fill the
YAML frontmatter, add a row.

## Layout

```
skills/
  batuta/            SKILL.md + references/ (brief, verification, routing, state, scout, worktree, method/)
                     adapters/ (self, claude, codex, opencode, cursor-agent, gemini) · templates/ (per stack)
  batuta-<command>/  one directory per command skill, agents/openai.yaml for Codex
tests/skills/check.sh   lint and token budget — CI gate
docs/qa-retro.md        the dogfooding protocol
```

Everything under `references/`, `adapters/` and `templates/` is dormant:
read only by the step that needs it.

## Contributing

`bash tests/skills/check.sh` must pass. Skill and reference text is
English; the README is bilingual. Retro rounds follow `docs/qa-retro.md`.

## License

[MIT](LICENSE)
