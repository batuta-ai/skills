# Plan — optional external ACP in conductor skills
<!-- inputs: profile.md@sha256:3f3de48a1e13 routing.md@sha256:556eb69f6375 -->

**Goal:** Connect interactive delegation to the qualified core dispatch command while retaining native preference for compatible routes and full skills-only CLI behavior.
**Created:** 2026-09-11 · **Status:** approved

## Tasks
- [ ] 1. Add optional ACP launch metadata and external dispatch selection — docs/medium
      Scope: skills/batuta/adapters/codex.md, skills/batuta/adapters/claude.md, skills/batuta/adapters/cursor-agent.md, skills/batuta/adapters/opencode.md, skills/batuta/references/dispatch.md, tests/skills/check.sh
      Accept: adapter metadata is accepted by the qualified core version and older run/readonly paths remain valid; version-gated core dispatch is used only when available, otherwise skills-only CLI remains functional → bash tests/skills/check.sh
- [ ] 2. Document capability-aware dispatch and conformance scenarios — docs/medium
      Depends on: 1
      Scope: skills/batuta/SKILL.md, skills/batuta/references/dispatch.md, skills/batuta/references/verification.md, skills/batuta-loop/SKILL.md, README.md, README.pt-BR.md, docs/native-dispatch-scenarios.md, tests/skills/check.sh
      Accept: native and ACP remain separate capabilities with route/model invariants, uncertain outcomes stop rather than replay and independent verification remains mandatory; scenarios cover missing core, old core, missing adapter, rejected model, quota failure and explicit CLI recovery; all limits and reference checks pass → bash tests/skills/check.sh

## Decisions and context

Prerequisites before execution: native-dispatch plan completed and qualified core dispatch command from core acp-dispatch plan available. Stop at preflight if these are absent. Cross-repository prerequisites are not numeric task dependencies. Routing predicts codex/gpt-5.6-sol for both tasks. The approved host design is `.batuta/dispatch-design.md`; inspect the actual core command/adapter contract and do not invent flag names from a stale brief.

Only source skills are edited here. Host vendor copies are updated by the separate release plan. Preserve explicit model/effort and current route costs. Native host tools are detected only in the current interactive runtime. ACP is a transport for an external agent, not a replacement for a host native child. No unsupported nested ACP session extension is required.

ACP stays opt-in. Missing core must not trigger installation, a new dependency or loss of skills-only functionality. Explicit ACP failures remain visible. Automatic CLI fallback is only pre-submission and only when policy permits; possible execution means stop/reconcile. Do not include raw protocol logs in briefs or receipts. Keep current packet caps and include new dispatch references in the accounting. Do not add ACP metadata to Agy until its adapter is independently qualified.
