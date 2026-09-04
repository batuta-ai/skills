---
name: gemini
executable: gemini
run: gemini -p "{brief}" {model_flags} --approval-mode yolo < /dev/null
run_file: gemini -p "Follow the instructions in {brief_file}" {model_flags} --approval-mode yolo < /dev/null
model_flags: -m {model}
readonly: gemini -p "Read-only task: do not create, edit or delete any file. {prompt}" -m {model} --approval-mode plan < /dev/null
available: command -v gemini
models: declared
finished: exit_code
limit_regex: "rate limit|quota exceeded|RESOURCE_EXHAUSTED|429"
brief_limit_lines: 100
cwd_flag: env
---

# Adapter: gemini — Gemini CLI, non-interactive

Google's CLI. A cheap `low`/`medium` row with a Flash model, or research
with the free tier.

## Invocation notes

- `-p` is headless mode; `--approval-mode yolo` auto-approves tool calls. Confirm both flags with `gemini --help` on first use — this CLI's flags moved between versions; the row records what the installed version accepts.
- Working directory: run inside `{cwd}`; there is no cd flag.
- Models are declared in the row (`gemini-2.5-flash`, `gemini-2.5-pro`, or newer): the CLI has no list command. Confirm the ID with a one-line `-p` call at onboarding.
- `--sandbox` enables the CLI's own sandbox when available.

## Capabilities and limits

Flash models: `low` and research. Pro models: `medium`. Budget models
follow briefs literally; be exhaustive.

## Cost

Free tier or Google AI subscription; pay-per-use on an API key.

## Review invocation

`--approval-mode plan` proposes without editing; the prompt states
read-only anyway, and the scout guard is the guarantee.
