# Plan — native dispatch with compact context
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:556eb69f6375 -->

**Goal:** Use a compatible native host subagent when explicitly opted in, preserving route/model, isolation, evidence and skills-only CLI behavior. Reduce conductor context without discarding acceptance criteria.
**Created:** 2026-09-11 · **Status:** done

## Tasks
- [x] 1. Define native eligibility and preserve route selection — docs/medium
      Scope: skills/batuta/SKILL.md, skills/batuta/references/dispatch.md, skills/batuta/references/routing.md, tests/skills/check.sh
      Accept: absent Dispatch preserves CLI behavior and auto uses native only with compatible explicit model/effort and isolation, with no native-tool assumptions in headless mode; installed skills satisfy existing line and token limits → bash tests/skills/check.sh
- [x] 2. Bound delegation context and return compact evidence — docs/medium
      Depends on: 1
      Scope: skills/batuta/references/dispatch.md, skills/batuta/references/brief.md, skills/batuta/references/scout.md, skills/batuta/references/verification.md, tests/skills/check.sh, docs/native-dispatch-scenarios.md
      Accept: scenarios cover native available, unavailable, model mismatch, inherited context, cancellation, partial results and skills-only fallback with explicit expected decisions; brief retains eight required sections and mandatory conventions while receipts distinguish worker claims from verified results; gate accounts for newly referenced dispatch material and preserves 9500/1000 estimated-token budgets → bash tests/skills/check.sh

## Decisions and context

The approved design is recorded in the host repository `.batuta/dispatch-design.md`; the execution contract below is self-contained. This plan does not require an ACP core release and must ship independently. Routing predicts codex/gpt-5.6-sol for both medium tasks. No current product files are changed by authoring this plan. Reconcile the existing skills feature branch before implementation; use isolated worktrees and required PR review.

Before any implementation, record the exact core/skills/host baseline commits and tool versions for later matched measurements; preserve baseline in an isolated checkout, not by resetting current work.

Use `Dispatch: auto` as opt-in, absent means legacy CLI. Select the route first, transport second. Native capability is discovered from the current host's actual tools and controls, not inferred from installed CLIs. Preserve exact model and effort where the route specifies them; unknown or incompatible values mean ineligible. Explicit user model overrides remain authoritative. Do not spawn the default expensive host model merely because it is available. Keep host-tool names out of generic skills.

Native host dispatch lives in skills, not core. Standalone headless core cannot invoke the parent's native tool. No new native runtime adapter, local daemon, installation requirement or journal-writing command. Interactive native receipts are consumed by the conductor with existing state/worktree/verification mechanisms. Do not append arbitrary records to a loop-owned journal.

**Task 2.** Context is task-specific and self-sufficient. Prefer an isolated child context; no full conversation fork by default. Keep all required conventions and stop conditions. Receipts contain outcome, changed paths, proof evidence references and uncertainty, target at most 4 KiB with explicit overflow. Do not hide failures or treat a self-report as gate evidence. Full logs stay in owned artifacts, read selectively. Progress updates go through existing facilities at meaningful changes, not every chunk. No extra summarizing LLM. Existing size gates use bytes/4 estimates; call them estimates.

**Task 2.** docs/native-dispatch-scenarios.md is a small reusable acceptance matrix, not a new QA framework. Actual native smoke and token measurements occur in the cross-repository pilot. Passing lint alone does not establish native runtime compatibility or savings.
