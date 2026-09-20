# Plan — hidden-path scopes never go to agy
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:8e409b47b53f -->

**Goal:** Make the routing doctrine and the agy adapter say that a task whose Scope lives under a dot-directory (`.batuta/`, `.github/`, `.claude/`) is never routed to agy, because agy cannot see hidden directories, wrote nothing and reported success twice in the research-ladder deliveries.
**Created:** 2026-09-20 · **Status:** approved

## Tasks
- [ ] 1. Hidden-path routing rule in routing.md and the agy adapter — docs/medium
      Scope: skills/batuta/references/routing.md, skills/batuta/adapters/agy.md
      Accept: the gate passes with the cycle packet inside its budget → bash tests/skills/check.sh; routing.md Rules carries a hidden-path rule naming dot-directories → grep -q 'dot-directory' skills/batuta/references/routing.md; agy.md Capabilities and limits states that agy cannot see hidden directories → grep -q 'hidden directories' skills/batuta/adapters/agy.md; neither file grows past its current line count → test $(wc -l < skills/batuta/references/routing.md) -le 91 && test $(wc -l < skills/batuta/adapters/agy.md) -le 48

## Decisions and context

Evidence: in both research-ladder deliveries (core task 3, skills task 4) the task "edit `.batuta/routing.md`" went to `agy/gemini-3.8-flash-low`, the executor searched the filesystem for the file, changed nothing and printed passing proofs; a direct probe reproduced it (`agy -p` asked to append a line to `.batuta/routing.md` inside a worktree launched a filesystem search and exited without writing). Recorded in `.batuta/learnings.md`.

**Task 1.** The conductor cycle packet is at 9498 of 9500 tokens: every sentence added must be paid for by trimming a sentence of equal weight in the same file, without changing meaning elsewhere. In `routing.md`, add one Rules bullet in the existing bold-lead style, for example `- **Hidden paths:** a Scope under a dot-directory (`.batuta/`, `.github/`) never goes to agy, which cannot see hidden files; use codex or self.` and shorten another bullet or the Research ladder prose to compensate. In `agy.md`, add the limit to the "Capabilities and limits" paragraph in one clause and trim an invocation note of equal length; do not touch the frontmatter `run`/`readonly` lines. Keep the Research ladder table and the escalation rule intact.
