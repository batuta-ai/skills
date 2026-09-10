# Profile — skills

Written by /batuta-init on 2026-09-09. Complements README.md; never repeats it.

Stack: Markdown only, agentskills.io format (no runtime, no dependencies); bash test harness; GitHub Actions CI; release-please
Methodology: gate after writing (the lint script is the test); conventional commits; feature branches with a PR to main (ruleset protect-main, required check `skills`)
Test: bash tests/skills/check.sh
Build:
Install:
Execution: sequential
Worktree: always
Template: templates/generic.md

## Conventions

- Every file under `skills/` is prose an agent loads at runtime. Length is a cost: `tests/skills/check.sh` caps each `SKILL.md` body (120 lines for `batuta`, 110 for `batuta-init`, 60 for every other skill) and caps the conductor cycle packet at 9500 tokens and the executor brief overhead at 1000.
- `name:` in the frontmatter must equal the directory name; `description:` is at most 300 characters.
- Forbidden strings anywhere under `skills/`: the name of the third-party framework the QA method was distilled from, the name of the CompozyOS extension repository, and host-specific tool names (`AskUserQuestion`, `TodoWrite`, `TaskCreate`, `SlashCommand`, `run_in_background`, `Task tool`). A skill that only runs on one host is a bug.
- Every relative reference a skill cites must exist; the linter resolves it against the citing file and the skill root.
- A reference over 100 lines opens with a `## Contents` section.
- Each skill carries `agents/openai.yaml` with `interface.display_name`, `short_description` and `default_prompt`.
- `feat:` and `fix:` drive the release, `chore:` and `docs:` never do. A docs-only change the host must vendor needs an empty `chore:` commit with a `Release-As:` footer.
- English in the repository; `README.pt-BR.md` mirrors `README.md`.

## Project map

Swept by the conductor on 2026-09-09; the repository is small enough that a research pass would cost more than it returns.

Pure markdown package. No build, no runtime, no third-party dependency. The gate is one shell script.

- `skills/batuta/` — the conducting cycle itself, the largest multi-part skill. `SKILL.md` is the five-step cycle; `references/` carries the contracts a cycle reads (`brief.md`, `verification.md`, `routing.md`, `state.md`, `worktree.md`, `scout.md`, plus `method/` for clarify, debug and no-workarounds); `adapters/` is one file per executor CLI (`agy`, `claude`, `codex`, `cursor-agent`, `opencode`, `self`) whose frontmatter is a machine contract the linter parses; `templates/` is one file per stack, chained through `Extends`.
- `skills/batuta-*/` — one directory per command skill (`init`, `loop`, `pause`, `plan`, `resume`, `review`, `route`, `status`). Each is a single `SKILL.md` under the 60-line budget plus `agents/openai.yaml`. `batuta-init` also ships `assets/agents-md-block.md`.
- `skills/batuta-qa-plan/` and `skills/batuta-qa-run/` — the real-user QA pair, each a `SKILL.md` under the same 60-line budget plus `references/`. The planner owns the tree and registry contracts (`tree.md`, `planning.md`, `bugs.md`); the runner owns the session contracts (`session.md`, `probes.md`, `close.md`) and cites the planner's `bugs.md` across skills.
- `docs/qa-retro.md` — the retro protocol for testing Batuta itself with a persona. Not a skill; not loaded at runtime.
- `tests/skills/check.sh` — the whole gate: per-skill line budgets, frontmatter rules, forbidden strings, relative-reference resolution, adapter frontmatter parsing (inline Python), the `## Contents` rule, and the two token packets computed over every template chain by every adapter.
- `.github/workflows/ci.yml` runs that script as the required check `skills`; `release-please.yml` cuts releases and auto-merges its own PR.
- Consumers: the host package `batuta-ai/batuta` vendors this repository at a pinned ref and installs it into `~/.agents/skills`; the `batuta` binary in `batuta-ai/core` reads the state files these skills write.

Generated or owned elsewhere, never edited here: `CHANGELOG.md` and `.release-please-manifest.json` (release-please), the README header images (the `.github` brand repository).
