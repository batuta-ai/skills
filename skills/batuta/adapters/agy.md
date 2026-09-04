---
name: agy
executable: agy
run: agy -p "{brief}" {model_flags} --mode=accept-edits --dangerously-skip-permissions --sandbox --print-timeout 30m < /dev/null
run_file: agy -p "Follow the instructions in {brief_file}" {model_flags} --mode=accept-edits --dangerously-skip-permissions --sandbox --print-timeout 30m < /dev/null
model_flags: --model {model} --effort {effort}
readonly: agy -p "Read-only task: do not create, edit or delete any file. {prompt}" --model {model} --mode=plan --print-timeout 15m < /dev/null
available: command -v agy
models: agy models
finished: exit_code
limit_regex: "quota|rate limit|RESOURCE_EXHAUSTED|429|out of credits"
brief_limit_lines: 100
cwd_flag: env
---

# Adapter: agy — Google Antigravity CLI, non-interactive

Google's terminal agent (`agy`), multi-model: Gemini Flash and Pro, Claude,
GPT-OSS through one account. A cheap `low`/`medium` row with a Flash model,
or research with Flash on the free quota. Replaces the discontinued Gemini
CLI.

## Invocation notes

- `-p` runs one prompt and exits. `--mode=accept-edits` approves file edits; `--dangerously-skip-permissions` also approves commands — the executor needs it to run tests. `--sandbox` keeps the terminal restricted; keep both.
- `--print-timeout` defaults to 5 minutes, too short for a task: the `run` line raises it. Raise further for long suites.
- Working directory: run inside `{cwd}`; there is no cd flag.
- `--effort low|medium|high` is the reasoning knob; drop it when the row names none. `--model` takes the slug from `agy models` (e.g. `gemini-3.5-flash-medium`); record the slug, not the display name.
- `--output-format json` gives a single envelope with a terminal `status` (`SUCCESS`, `ERROR`, `CANCELED`, …); then `finished` becomes `status == SUCCESS`. Responses go to stdout, diagnostics to stderr — capture them separately.
- `agy models` is a network call: run it at onboarding and on demand, never in a per-delegation availability check.
- Headless auth: keyring, or `GEMINI_API_KEY` with `modelProvider: "gemini"` in `~/.gemini/antigravity-cli/settings.json` (CI).

## Capabilities and limits

Flash models: `low` and research. Pro and Claude models: `medium`; `high`
only with a strong slug and `--effort high` named in the row. Budget models
follow briefs literally; be exhaustive.

## Cost

Google account quota or credits; flat under the plan, pay-per-use on an
API key. Check `/usage` in an interactive session.

## Review invocation

`--mode=plan` proposes without editing; the prompt states read-only anyway,
and the scout guard (`references/scout.md`) is the guarantee.
