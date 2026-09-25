# Plan — readonly lines emit the same JSON stream as run
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:b265466fc87a -->

**Goal:** An end-to-end check of plan `output-decoder` found that core runs `readonly` through the same `Execute`, which applies the adapter's `output_decoder`; a reviewer's JSON finding lines are unknown events to the decoder and were dropped, so `batuta review` reported "reviewer output contains rejected findings or invalid framing" with this branch and SHIP with the installed copy. The same path serves verifiers and scouts. With `readonly` on the same stream as `run`, the reviewer's text arrives whole as agent text, and read-only sessions report usage too.
**Created:** 2026-09-25 · **Status:** approved

## Tasks
- [ ] 1. claude, codex, opencode and agy readonly lines emit their JSON stream — general/medium
      Scope: skills/batuta/adapters/claude.md, skills/batuta/adapters/codex.md, skills/batuta/adapters/opencode.md, skills/batuta/adapters/agy.md
      Accept: claude.md `readonly` adds `--output-format stream-json --verbose` right after `claude -p` → grep -q '^readonly: env -u CLAUDECODE claude -p --output-format stream-json --verbose ' skills/batuta/adapters/claude.md; codex.md `readonly` adds `--json` right after `codex exec` → grep -q '^readonly: codex exec --json ' skills/batuta/adapters/codex.md; opencode.md `readonly` adds `--format json` right after `opencode run` → grep -q "^readonly: 'opencode run --format json " skills/batuta/adapters/opencode.md; agy.md `readonly` adds `--output-format stream-json` right after the prompt argument → grep -q '^readonly: .*--output-format stream-json' skills/batuta/adapters/agy.md; cursor-agent.md is unchanged → git diff --quiet origin/main -- skills/batuta/adapters/cursor-agent.md; the skills lint passes → bash tests/skills/check.sh

## Decisions and context

Conventional commits. Only the four `readonly` lines change; everything else in the frontmatter stays. Keep the cycle packet within 9500 tokens (it is at 9499); if the flags push it over, shorten an adapter note rather than the lines.
