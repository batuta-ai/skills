# WORK — skills

## In progress
- [ ] Approved native-dispatch (2 tasks) and later acp-dispatch (2 tasks), 2026-09-11. Execute native plan here; external ACP waits for qualified core. Baseline skills 94b6b19, core 940a7b3, host 32702e8.
- None. QA round 3 is verified locally; no push or merge authorized.

## Follow-ups
- [ ] After QA skills are reviewed and merged: host command wiring and vendoring in a separate repository plan.
- [ ] File the nested-conductor and verifier-incomplete retry-policy issues recorded below. No issues filed in this planning session.
  - Nested conductors: qa-skills task 5 e1 and qa-skills-fixes task 1 e1 tried nested `codex exec` and hit `Operation not permitted (os error 1)`. The AGENTS guard is partial mitigation, not a complete plugin-level fix.
  - Verifier retry policy: qa-skills-fixes journal seq 47 records `verifier_incomplete` because agy emitted no parseable `TASK n: DONE|INCOMPLETE` lines. The loop reran implementation despite green task gates. Investigate retrying/escalating verification rather than implementation.
- [ ] Deferred decisions: preventive Compozy guard and whether delivery review becomes a loop gate.
- [ ] Next-delivery candidate, agreed with the user: a common loop-supervision contract with host-specific native subagent instructions where supported and managed-background fallback elsewhere. Verify each host's capabilities before designing the integration; do not replace core routing, gates or journal ownership.
- [ ] Claude readonly adapter: `--disallowedTools` consumes the following prompt as option values on the installed CLI. The original invocation exits 1 with missing prompt; inserting `--` before the prompt returns OK. Plan a separate adapter fix with regression coverage. No issue filed yet.

## Done
- [x] QA round 3 final verification (2026-09-10): independent public gate passed, seven fixture tests passed, and agy/gemini-3.8-flash-low delivery review returned SHIP with no findings, 1/1 cohort covered and 13/13 criteria satisfied. Conductor agrees after scope, diff and test-hygiene review. The first Claude review had missing coverage due to the adapter defect above, not implementation findings. Evidence: `.batuta/reviews/2026-09-10-qa-skills-round3/review.md` and `.batuta/runs/2026-09-10-qa-skills-round3-final-verification.md`.
- [x] Root `AGENTS.md` delegated-brief guard copied verbatim from the init asset, verified with cmp and git diff --check, committed separately as d6bc86f before executors (2026-09-10).
- [x] QA tree contract reference → codex (gpt-5.6-sol), commit 6d35c183b876 (trail: .batuta/runs/2026-09-09-qa-skills-task-1.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Planner skill → codex (gpt-6-astra), commit 37b6467391b6 (trail: .batuta/runs/2026-09-09-qa-skills-task-2.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Bug registry reference → codex (gpt-5.6-sol), commit 9863015b2a2b (trail: .batuta/runs/2026-09-09-qa-skills-task-3.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Runner skill and cross-skill references in the gate → codex (gpt-6-astra), commit 138a5df46ce5 (trail: .batuta/runs/2026-09-09-qa-skills-task-4.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Probe catalogs → codex (gpt-5.6-sol), 1 retry, commit 057bee84529b (trail: .batuta/runs/2026-09-09-qa-skills-task-5.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Close and fix governor → codex (gpt-5.6-sol), commit cdddfadcf61f (trail: .batuta/runs/2026-09-09-qa-skills-task-6.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Docs wiring → agy (gemini-3.8-flash-low), commit 3a20fc204302 (trail: .batuta/runs/2026-09-09-qa-skills-task-7.md, delivery qa-skills-20260909-154719, plan qa-skills, 2026-09-09)
- [x] Dedup transitions bound to explicit statuses → codex (gpt-5.6-sol), commit 929fd7b98ec4 (trail: .batuta/runs/2026-09-09-qa-skills-fixes-task-1.md, delivery qa-skills-fixes-20260909-205535, plan qa-skills-fixes, 2026-09-10)
- [x] Wire the unreachable references into their skills → codex (gpt-6-astra), 1 retry, commit ae269d1b2169 (trail: .batuta/runs/2026-09-09-qa-skills-fixes-task-2.md, delivery qa-skills-fixes-20260909-205535, plan qa-skills-fixes, 2026-09-10)
- [x] Give each QA run a stable unique identity and preserve observed failures → codex (gpt-6-astra), commit 08e53d9dc9c2 (trail: .batuta/runs/2026-09-10-qa-skills-round3-task-1.md, delivery qa-skills-round3-20260910-132031, plan qa-skills-round3, 2026-09-10)
- [x] Reject references unreachable from shipped skill entrypoints → codex (gpt-5.6-sol), commit b37f520a3257 (trail: .batuta/runs/2026-09-10-qa-skills-round3-task-2.md, delivery qa-skills-round3-20260910-132031, plan qa-skills-round3, 2026-09-10)
- [x] Define native eligibility and preserve route selection → codex (gpt-5.6-sol), 1 retry, commit 72c9111a1469 (trail: .batuta/runs/2026-09-11-native-dispatch-task-1.md, delivery native-dispatch-20260911-132638, plan native-dispatch, 2026-09-11)
- [x] Bound delegation context and return compact evidence → codex (gpt-5.6-sol), commit 6374ebe48222 (trail: .batuta/runs/2026-09-11-native-dispatch-task-2.md, delivery native-dispatch-20260911-132638, plan native-dispatch, 2026-09-11)
